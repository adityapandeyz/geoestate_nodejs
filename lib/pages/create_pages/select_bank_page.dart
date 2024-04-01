import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../Models/bank.dart';
import '../../provider/bank_provider.dart';
import '../../constants/utils.dart';
import '../../widgets/custom_page2.dart';
import '../../widgets/custom_textfield.dart';
import 'add_dataset_page.dart';

class SelectBankPage extends StatefulWidget {
  final double lat;
  final double lng;
  final DateTime dateTime;
  final int marketRate;
  final String unit;
  const SelectBankPage({
    super.key,
    required this.lat,
    required this.lng,
    required this.dateTime,
    required this.marketRate,
    required this.unit,
  });

  @override
  State<SelectBankPage> createState() => _SelectBankPageState();
}

class _SelectBankPageState extends State<SelectBankPage> {
  final TextEditingController _bankNameController = TextEditingController();
  final TextEditingController _branchNameController = TextEditingController();
  final TextEditingController _ifscController = TextEditingController();
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _bankNameController.dispose();
    _ifscController.dispose();
    _searchController.dispose();

    super.dispose();
  }

  addBank() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CustomTextfield(
                  title: 'Bank Name',
                  controller: _bankNameController,
                ),
                const SizedBox(
                  height: 10,
                ),
                CustomTextfield(
                  title: 'Branch Name',
                  controller: _branchNameController,
                ),
                const SizedBox(
                  height: 10,
                ),
                CustomTextfield(
                  title: 'IFSC Code',
                  controller: _ifscController,
                ),
              ],
            ),
            actions: [
              TextButton(
                child: const Text(
                  "Cancel",
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              ElevatedButton(
                child: const Text(
                  "OK",
                ),
                onPressed: () async {
                  Navigator.pop(context);

                  try {
                    Bank bank = Bank(
                      id: 0,
                      bankName: _bankNameController.text.toUpperCase(),
                      branchName: _branchNameController.text.toUpperCase(),
                      ifscCode: _ifscController.text.toUpperCase(),
                    );
                    (context).read<BankProvider>().createBank(bank);
                  } catch (e) {
                    showAlert(
                      context,
                      e.toString(),
                    );

                    return;
                  }

                  showAlert(
                    context,
                    'Bank Added to Database!',
                  );
                },
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return CustomPage2(
      pageTitle: 'Select Bank',
      sidebar: Consumer<BankProvider>(builder: (
        context,
        bankProver,
        child,
      ) {
        final List<Bank> documents = bankProver.banks!;
        final filteredData = documents.where((doc) {
          final docBankName = doc.bankName.toString().toUpperCase();
          final docBranchName = doc.branchName.toString().toUpperCase();
          final docIfscCode = doc.ifscCode.toString().toUpperCase();
          final searchText = _searchController.text.toUpperCase();

          final searchTerms = searchText.split(' ');

          // Check if any of the search terms is present in either bank name or branch name
          return searchTerms.every((term) =>
                  docBankName.contains(term) || docBranchName.contains(term)) ||
              docIfscCode.contains(searchText);
        }).toList();

        // if (filteredData.isEmpty) {
        //   return noDataIcon();
        // }
        return Padding(
          padding: const EdgeInsets.all(68.0),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Select Bank',
                      style: GoogleFonts.poppins(
                        textStyle: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 21,
                          // letterSpacing: .5,
                        ),
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      addBank();
                    },
                    child: const Text('Add Bank'),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              CustomTextfield(
                  title: 'Search Bank',
                  controller: _searchController,
                  onChanged: (value) {
                    setState(() {});
                  }),
              Expanded(
                child: ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  itemCount: filteredData.length,
                  shrinkWrap: true,
                  itemBuilder: (BuildContext context, int index) {
                    final data = filteredData[index];
                    return Card(
                      margin: const EdgeInsets.all(20),
                      child: ListTile(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => AddDataSet(
                                latitude: widget.lat,
                                longitude: widget.lng,
                                unit: widget.unit.toString(),
                                dateTime: DateTime.now(),
                                marketRate: widget.marketRate.toInt(),
                                bankName: data.bankName.toString(),
                                branchName: data.branchName.toString(),
                                ifscCode: data.ifscCode.toString(),
                              ),
                            ),
                          );
                        },
                        leading: const SizedBox(
                          width: 60,
                          // child: Image.network(
                          //     'https://upload.wikimedia.org/wikipedia/commons/thumb/a/a8/London.bankofengland.arp.jpg/220px-London.bankofengland.arp.jpg'),
                          child: Icon(FontAwesomeIcons.bank),
                        ),
                        title: Text(
                            '${data.bankName.toString()} ${data.branchName.toString()}'),
                        subtitle: Text(data.ifscCode.toString()),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}

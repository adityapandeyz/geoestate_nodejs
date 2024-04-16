import 'package:flutter/material.dart';
import 'package:geoestate/provider/auth_provider.dart';
import 'package:geoestate/services/dataset_services.dart';

import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../Models/dataset.dart';
import '../provider/dataset_provider.dart';
import '../constants/utils.dart';
import '../widgets/custom_textfield.dart';
import 'map_page.dart';

class DatasetPage extends StatefulWidget {
  static const String routeName = '/dataset';

  final double latitude;
  final double longitude;

  const DatasetPage({
    super.key,
    this.latitude = 0.0,
    this.longitude = 0.0,
  });

  @override
  _DatasetPageState createState() => _DatasetPageState();
}

class _DatasetPageState extends State<DatasetPage> {
  late TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  TextEditingController updatePartyNameController = TextEditingController();
  TextEditingController updaterefNoController = TextEditingController();

  TextEditingController updateColonyNameController = TextEditingController();
  TextEditingController updateCityVillageNameController =
      TextEditingController();
  TextEditingController updateMarketRateController = TextEditingController();
  TextEditingController updateRemarksController = TextEditingController();
  TextEditingController updateUnitController = TextEditingController();

  DateTime _selectedDate = DateTime.now();
  bool _isLoading = false;

  Future<void> _selectDate(
      BuildContext context, DateTime initDate, int id) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initDate,
      firstDate: DateTime(1900),
      lastDate: DateTime(2101),
    );

    if (picked != null && picked != initDate) {
      setState(() {
        _selectedDate = picked;

        _updateDateOnFirestore(id);
      });
    }
  }

  Future<void> _updateDateOnFirestore(int id) async {
    setState(() {
      _isLoading = true;
    });
    try {
      await DatasetServices.updateDateOfVisit(
        id: id,
        dateOfVisit: _selectedDate,
      );
      await (context).read<DatasetProvider>().loadDatasets();
    } catch (e) {
      showAlert(context, e.toString());
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    updaterefNoController.dispose();
    updatePartyNameController.dispose();
    updateColonyNameController.dispose();
    updateCityVillageNameController.dispose();
    updateMarketRateController.dispose();
    updateUnitController.dispose();
    updateRemarksController.dispose();

    super.dispose();
  }

  // _selectDateRange(context) {
  //   return showDialog(
  //     context: context,
  //     builder: (context) {
  //       return StatefulBuilder(builder: (context, setState) {
  //         return ContentDialog(
  //           title: const Text(
  //             "Select Date Range for Exporting!",
  //             style: TextStyle(fontSize: 16),
  //           ),
  //           content:
  //           ],
  //         );
  //       });
  //     },
  //   );
  // }

  String selectedColor = 'white'; // Default selected color
  List<String> colors = [
    'red',
    'orange',
    'green',
    'blue',
    'yellow',
    'white',
    'purple',
    'indigo'
  ];

  Color getColor(String colorName) {
    switch (colorName) {
      case 'red':
        return Colors.red;
      case 'orange':
        return Colors.orange;
      case 'green':
        return Colors.green;
      case 'blue':
        return Colors.blue;
      case 'yellow':
        return Colors.yellow;
      case 'purple':
        return Colors.purple;
      case 'indigo':
        return Colors.indigo;
      default:
        return Colors.white; // Default color
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('View Existing Datasets'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              setState(() {
                _isLoading = true;
              });
              context.read<DatasetProvider>().loadDatasets();

              setState(() {
                _isLoading = false;
              });
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 10,
            ),
            Container(
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.white.withOpacity(0.1),
                    spreadRadius: 2,
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Row(
                children: [
                  const SizedBox(
                    width: 10,
                  ),
                  const Icon(
                    Icons.search,
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: CustomTextfield(
                      title:
                          'Search [Ref No., Bank Name, Branch Name, Colony Name, City/Village Name]',
                      controller: _searchController,
                      onChanged: (value) {
                        setState(
                            () {}); // Trigger a rebuild when search input changes
                      },
                    ),
                  ),
                  const SizedBox(
                    width: 5,
                  ),

                  // const m.VerticalDivider(
                  //   thickness: 5,
                  //   width: 5,
                  //   color: Color.fromARGB(255, 18, 19, 19),
                  // ),
                  const SizedBox(
                    width: 5,
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 10,
            ),

            // Data Table
            Consumer<DatasetProvider>(
              builder: (context, datasetProvider, child) {
                final filteredData = datasetProvider.datasets!.where((doc) {
                  if (widget.longitude != 0.0) {
                    final double docLongitude = doc.longitude;
                    return docLongitude == widget.longitude;
                  }
                  final docBankName = doc.bankName.toString().toLowerCase();
                  final docBranchName = doc.branchName.toString().toLowerCase();
                  final partyName = doc.partyName.toString().toLowerCase();
                  final docColonyName = doc.colonyName.toString().toLowerCase();
                  final docCityVillageName =
                      doc.cityVillageName.toString().toLowerCase();
                  final docRefNo = doc.refNo.toString().toLowerCase();
                  final searchQuery = _searchController.text.toLowerCase();

                  final searchTerms = searchQuery.split(' ');

                  return searchTerms.every(
                    (term) =>
                        docBankName.contains(term) ||
                        docBranchName.contains(term) ||
                        partyName.contains(term) ||
                        docColonyName.contains(term) ||
                        docCityVillageName.contains(term) ||
                        docRefNo.contains(term),
                  );
                }).toList();

                if (filteredData.isEmpty) {
                  return noDataIcon();
                }
                return Padding(
                    padding: const EdgeInsets.all(16),
                    child: Card(
                      elevation: 6,
                      // decoration: BoxDecoration(
                      //   // color: FluentTheme.of(context).activeColor,
                      //   borderRadius: BorderRadius.circular(16),
                      //   boxShadow: [
                      //     BoxShadow(
                      //       color: Colors.white.withOpacity(0.2),
                      //       spreadRadius: 2,
                      //       blurRadius: 8,
                      //       offset: const Offset(0, 3),
                      //     ),
                      //   ],
                      // ),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        // physics: ClampingScrollPhysics(),
                        child: DataTable(
                          columnSpacing: 12,
                          horizontalMargin: 12,
                          headingRowColor: MaterialStateProperty.all(
                            const Color.fromARGB(255, 163, 163, 163),
                          ),
                          columns: const [
                            DataColumn(label: Text('S. No.')),
                            DataColumn(label: Text('Ref. No.')),
                            DataColumn(label: Text('Bank Name')),
                            DataColumn(label: Text('Branch Name')),
                            DataColumn(label: Text('Party Name')),
                            DataColumn(label: Text('Colony Name')),
                            DataColumn(label: Text('City/Village Name')),
                            DataColumn(label: Text('Coordinates')),
                            DataColumn(label: Text('Market Rate (₹)')),
                            DataColumn(label: Text('Unit (per)')),
                            // DataColumn(label: Text('Date of Valuation')),
                            DataColumn(label: Text('Date of Visit')),
                            DataColumn(label: Text('Remarks')),
                            DataColumn(label: Text('Entry By')),
                            DataColumn(label: Text('Edit')),
                            DataColumn(label: Text('Remove Data')),
                          ],
                          rows: List<DataRow>.generate(
                            filteredData.length,
                            (index) {
                              List<Dataset> data = filteredData.toList();

                              return DataRow(
                                color:
                                    MaterialStateProperty.resolveWith<Color?>(
                                  (Set<MaterialState> states) {
                                    return getColor(data[index]
                                            .colorMark
                                            .toString()
                                            .toLowerCase())
                                        .withOpacity(0.6);
                                  },
                                ),
                                cells: [
                                  DataCell(
                                    Text(
                                      data[index].id.toString(),
                                    ),
                                  ),
                                  DataCell(
                                    Text(
                                      data[index].refNo.toString(),
                                    ),
                                  ),
                                  DataCell(
                                    Text(
                                      data[index].bankName.toString(),
                                    ),
                                  ),
                                  DataCell(
                                    Text(
                                      data[index].branchName.toString(),
                                    ),
                                  ),
                                  DataCell(
                                      SizedBox(
                                        width: 250,
                                        child: Text(
                                          data[index].partyName.toString(),
                                        ),
                                      ), onTap: () {
                                    // _navigateToNextPage(context,
                                    //     refNo: data['refNo'],
                                    //     partyName: data['partyName'],
                                    //     address:
                                    //         '${data['colonyName']}, ${data['cityVillageName']}',
                                    //     billId: data['billId'],
                                    //     bankName: data['bankName'],
                                    //     branchName: data['branchName']);
                                  }),
                                  DataCell(Text(
                                    data[index].colonyName.toString(),
                                  )),
                                  DataCell(Text(
                                      data[index].cityVillageName.toString())),
                                  DataCell(
                                    Text(
                                      '${data[index].latitude}°N, ${data[index].longitude}°E',
                                    ),
                                    onTap: () {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (_) => MapPage(
                                            latitude:
                                                data[index].latitude.toString(),
                                            longitude:
                                                data[index].latitude.toString(),
                                            zoom: 20,
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                  DataCell(
                                      Text(data[index].marketRate.toString())),
                                  DataCell(Text(data[index].unit.toString())),
                                  // DataCell(Text(DateFormat('yyyy-MM-dd')
                                  //     .format(data['dateOfValuation'].toDate())
                                  //     .toString())),
                                  _isLoading
                                      ? DataCell(
                                          CircularProgressIndicator(),
                                        )
                                      : DataCell(
                                          Row(
                                            children: [
                                              Text(
                                                DateFormat('dd-MM-yyyy').format(
                                                  data[index].dateOfVisit,
                                                ),
                                              ),
                                              IconButton(
                                                onPressed: () {
                                                  _selectDate(
                                                    context,
                                                    data[index].dateOfVisit,
                                                    data[index].id,
                                                  );
                                                },
                                                icon: const Icon(Icons.edit),
                                              )
                                            ],
                                          ),
                                        ),
                                  DataCell(Text(
                                    data[index].remarks.toString(),
                                  )),
                                  DataCell(Text(
                                    data[index].entryBy.toString(),
                                  )),
                                  DataCell(SizedBox(
                                    child: TextButton(
                                      child: const Text('Edit'),
                                      onPressed: () {
                                        updateDataset(
                                          id: data[index].id,
                                          refNo: data[index].refNo,
                                          partyName: data[index].partyName,
                                          colonyName: data[index].colonyName,
                                          cityVillageName:
                                              data[index].cityVillageName,
                                          marketRate: data[index].marketRate,
                                          unit: data[index].unit,
                                          remarks: data[index].remarks,
                                          colorMark: data[index].colorMark,
                                          // Keep existing datasetName
                                          bankName: data[index]
                                              .bankName, // Keep existing bankName
                                          latitude: data[index]
                                              .latitude, // Keep existing latitude
                                          branchName: data[index]
                                              .branchName, // Keep existing branchName
                                          longitude: data[index]
                                              .longitude, // Keep existing longitude

                                          createdAt: data[index]
                                              .createdAt, // Keep existing createdAt
                                          dateOfVisit: data[index]
                                              .dateOfVisit, // Keep existing dateOfVisit
                                          entryBy: data[index].entryBy,
                                        );
                                      },
                                    ),
                                  )),
                                  DataCell(SizedBox(
                                    child: TextButton(
                                        child: const Text(
                                          'Remove',
                                          style: TextStyle(
                                            color: Colors.red,
                                          ),
                                        ),
                                        onPressed: () {
                                          removeExistingDataset(
                                            data[index].id,
                                          );
                                        }),
                                  )),
                                ],
                              );
                            },
                          ),
                        ),
                      ),
                    ));
              },
            )
          ],
        ),
      ),
    );
  }

  // Route _popupScreen() {
  //   return PageRouteBuilder(
  //     pageBuilder: (context, animation, secondaryAnimation) =>
  //         const ExportExcelPage(),
  //     transitionsBuilder: (context, animation, secondaryAnimation, child) {
  //       const begin = Offset(1.0, 0.0);
  //       const end = Offset.zero;
  //       const curve = Curves.easeInOut;
  //       var tween =
  //           Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

  //       var offsetAnimation = animation.drive(tween);
  //       return SlideTransition(
  //         position: offsetAnimation,
  //         child: child,
  //       );
  //     },
  //   );
  // }

  updateDataset({
    required String refNo,
    required String bankName,
    required String branchName,
    required String partyName,
    required String colonyName,
    required String cityVillageName,
    required double latitude,
    required double longitude,
    required int marketRate,
    required String unit,
    required DateTime createdAt,
    required String remarks,
    required String colorMark,
    required DateTime dateOfVisit,
    required int id,
    required String entryBy,
  }) {
    return showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
            title: const Text(
              "Update Dataset",
              style: TextStyle(fontSize: 16),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CustomTextfield(
                  title: refNo,
                  controller: updaterefNoController,
                ),
                const SizedBox(height: 10),
                CustomTextfield(
                  title: partyName,
                  controller: updatePartyNameController,
                ),
                const SizedBox(height: 10),
                CustomTextfield(
                  title: colonyName,
                  controller: updateColonyNameController,
                ),
                const SizedBox(height: 10),
                CustomTextfield(
                  title: cityVillageName,
                  controller: updateCityVillageNameController,
                ),
                const SizedBox(height: 10),
                CustomTextfield(
                  title: '₹$marketRate',
                  controller: updateMarketRateController,
                ),
                const SizedBox(height: 10),
                CustomTextfield(
                  title: unit.isEmpty ? 'Unit' : unit,
                  controller: updateUnitController,
                ),
                const SizedBox(height: 10),
                CustomTextfield(
                  title: remarks.isNotEmpty ? remarks : 'Remarks',
                  maxLines: 3,
                  controller: updateRemarksController,
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      "Color Marker: ",
                      style: TextStyle(fontSize: 16),
                    ),
                    DropdownButton<String>(
                      value: colorMark.toLowerCase(),
                      onChanged: (String? newValue) async {
                        setState(() {
                          // selectedColor = newValue!;
                          colorMark = newValue!;
                          selectedColor = newValue;
                        });
                      },
                      items:
                          colors.map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4.0),
                            child: Container(
                              padding: const EdgeInsets.all(8.0),
                              child: CircleAvatar(
                                backgroundColor: getColor(
                                    value), // Implement getColor onChanged
                                radius: 16.0,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ],
            ),
            actions: [
              TextButton(
                child: const Text(
                  "Cancel",
                ),
                onPressed: () {
                  updaterefNoController.clear();
                  updatePartyNameController.clear();
                  updateCityVillageNameController.clear();
                  updateColonyNameController.clear();
                  updateMarketRateController.clear();
                  updateUnitController.clear();
                  updateRemarksController.clear();
                  Navigator.pop(context);
                },
              ),
              ElevatedButton(
                child: _isLoading
                    ? const CircularProgressIndicator()
                    : const Text(
                        "Update",
                      ),
                onPressed: () async {
                  setState(() {
                    _isLoading = true;
                  });
                  try {
                    // Create a new Dataset object with existing values
                    Dataset datasetToUpdate = Dataset(
                      refNo: refNo,
                      bankName: bankName,
                      branchName: branchName,
                      partyName: partyName,
                      colonyName: colonyName,
                      cityVillageName: cityVillageName,
                      latitude: latitude,
                      longitude: longitude,
                      marketRate: marketRate,
                      unit: unit,
                      createdAt: createdAt,
                      remarks: remarks,
                      colorMark: colorMark,
                      dateOfVisit: dateOfVisit,
                      id: id,
                      entryBy: entryBy,
                    );

                    // Update specific fields if they are not empty
                    if (updaterefNoController.text.isNotEmpty) {
                      datasetToUpdate.refNo =
                          updaterefNoController.text.toUpperCase();
                    }
                    if (updateColonyNameController.text.isNotEmpty) {
                      datasetToUpdate.colonyName =
                          updateColonyNameController.text.toUpperCase();
                    }
                    if (updatePartyNameController.text.isNotEmpty) {
                      datasetToUpdate.partyName =
                          updatePartyNameController.text.toUpperCase();
                    }
                    if (updateCityVillageNameController.text.isNotEmpty) {
                      datasetToUpdate.cityVillageName =
                          updateCityVillageNameController.text.toUpperCase();
                    }
                    if (updateMarketRateController.text.isNotEmpty) {
                      datasetToUpdate.marketRate =
                          int.parse(updateMarketRateController.text);
                    }
                    if (updateUnitController.text.isNotEmpty) {
                      datasetToUpdate.unit =
                          updateUnitController.text.toUpperCase();
                    }
                    if (updateRemarksController.text.isNotEmpty) {
                      datasetToUpdate.remarks =
                          updateRemarksController.text.toUpperCase();
                    }
                    if (colorMark.toString().toUpperCase().isNotEmpty) {
                      datasetToUpdate.colorMark =
                          colorMark.toString().toUpperCase();
                    }

                    await DatasetServices.updateDataset(
                      context: context,
                      id: id,
                      dataset: datasetToUpdate,
                    );

                    await context.read<DatasetProvider>().loadDatasets();

                    // Clear all text controllers after successful update
                    updaterefNoController.clear();
                    updatePartyNameController.clear();
                    updateCityVillageNameController.clear();
                    updateColonyNameController.clear();
                    updateMarketRateController.clear();
                    updateUnitController.clear();
                    updateRemarksController.clear();
                  } catch (e) {
                    print(e);
                  }

                  setState(() {
                    _isLoading = false;
                  });
                  Navigator.pop(context);
                },
              )
            ],
          );
        });
      },
    );
  }

  Future<void> updateDatasetLogic(
      Dataset dataset, Map<String, dynamic> updates) async {
    Dataset updatedDataset = dataset.copyWith(updates);

    try {
      await DatasetServices.updateDataset(
        context: context,
        id: dataset.id,
        dataset: updatedDataset,
      );

      await context.read<DatasetProvider>().loadDatasets();
    } catch (e) {
      showAlert(context, e.toString());
    }
  }

  removeExistingDataset(int id) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            "Are you Sure?",
            style: TextStyle(fontSize: 18),
          ),
          content: const Text(
            "This action will parmanently delete this data.",
            style: TextStyle(fontSize: 16),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Delete'),
            )
          ],
        );
      },
    );
    if (result == null || !result) {
      return;
    }
    setState(() {
      _isLoading = true;
    });
    try {
      final datasetId = context
          .read<DatasetProvider>()
          .datasets!
          .where((element) => element.id == id)
          .first
          .id;

      // context.read<DatasetProvider>().deleteDataset(dataset);
      await DatasetServices.deleteDataset(datasetId);

      await context.read<DatasetProvider>().loadDatasets();
    } catch (e) {
      showAlert(context, e.toString());
      return;
    }
    setState(() {
      _isLoading = false;
    });
  }

  void _navigateToNextPage(BuildContext context,
      {required refNo,
      required String address,
      required partyName,
      required billId,
      required bankName,
      required branchName}) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        TextEditingController _phraseController = TextEditingController();

        return AlertDialog(
          title: const Text('Enter Phrase'),
          content: TextField(
            controller: _phraseController,
            decoration: const InputDecoration(labelText: 'Phrase'),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                // Navigator.of(context).pop();
                // _navigateToNewPage(
                //   context,
                //   _phraseController.text,
                //   partyName,
                //   refNo,
                //   address,
                //   billId,
                //   bankName,
                //   branchName,
                // );
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

//   void _navigateToNewPage(
//     BuildContext context,
//     String phrase,
//     partyName,
//     refNo,
//     address,
//     billId,
//     bankName,
//     branchName,
//   ) {
//     if (phrase == 'AdminNavigator08') {
//       Navigator.push(
//         context,
//         MaterialPageRoute(
//           builder: (context) => BillingPage(
//             partyName: partyName,
//             refNo: refNo,
//             address: address,
//             billId: billId,
//             bankName: bankName,
//             branchName: branchName,
//           ),
//         ),
//       );
//     } else {
//       // Show an error message or handle the case when the phrase doesn't match
//       showDialog(
//         context: context,
//         builder: (BuildContext context) {
//           return AlertDialog(
//             title: const Text('Error'),
//             content: const Text('Invalid phrase.'),
//             actions: <Widget>[
//               ElevatedButton(
//                 onPressed: () {
//                   Navigator.of(context).pop(); // Close the dialog
//                 },
//                 child: const Text('OK'),
//               ),
//             ],
//           );
//         },
//       );
//     }
//   }
// }
}

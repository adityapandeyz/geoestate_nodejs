import 'dart:math';

import 'package:easy_date_timeline/easy_date_timeline.dart';

import 'package:flutter/material.dart';
import 'package:geoestate/pages/home_page.dart';
import 'package:geoestate/provider/dataset_provider.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import '../../Models/dataset.dart';
import '../../constants/utils.dart';
import '../../services/dataset_services.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_page2.dart';
import '../../widgets/custom_textfield.dart';
import '../map_page.dart';

// import 'package:neopop/widgets/buttons/neopop_button/neopop_button.dart';

class AddDataSet extends StatefulWidget {
  final double latitude;
  final double longitude;
  final DateTime dateTime;
  final int marketRate;
  final String unit;
  final String bankName;
  final String branchName;
  final String ifscCode;

  const AddDataSet({
    super.key,
    required this.latitude,
    required this.longitude,
    required this.dateTime,
    required this.marketRate,
    required this.unit,
    required this.bankName,
    required this.ifscCode,
    required this.branchName,
  });

  @override
  State<AddDataSet> createState() => _AddDataSetState();
}

class _AddDataSetState extends State<AddDataSet> {
  final _formKey = GlobalKey<FormState>();

  // Position? _currentLocation;
  late bool servicePermission = false;
  // late LocationPermission permission;

  TextEditingController partyNameController = TextEditingController();
  TextEditingController colonyNameController = TextEditingController();
  TextEditingController cityVillageNameController = TextEditingController();
  TextEditingController marketRateController = TextEditingController();
  TextEditingController remarksController = TextEditingController();

  DateTime _selectedDate = DateTime.now();

  // // String _currentAddress = "";

  // Future<Position> _getCurrentLocation() async {
  //   servicePermission = await Geolocator.isLocationServiceEnabled();

  //   if (!servicePermission) {
  //     print('Service Disabled');
  //   }
  //   permission = await Geolocator.checkPermission();

  //   if (permission == LocationPermission.denied) {
  //     permission = await Geolocator.requestPermission();
  //   }
  //   return await Geolocator.getCurrentPosition();
  // }

  // _getAddressFromCoordinates() async {
  //   try {
  //     List<Placemark> placemarks = await placemarkFromCoordinates(
  //         _currentLocation!.latitude, _currentLocation!.longitude);

  //     Placemark place = placemarks[0];

  //     setState(() {
  //       _currentAddress = "${place.locality}, ${place.country}";
  //     });
  //   } catch (e) {
  //     print(e);
  //   }
  // }

  @override
  void dispose() {
    partyNameController.dispose();
    cityVillageNameController.dispose();
    colonyNameController.dispose();
    marketRateController.dispose();
    remarksController.dispose();

    super.dispose();
  }

  Color selectedColor = Colors.red;
  // final List<Color> colors = [
  //   Colors.red,
  //   Colors.orange,
  //   Colors.green,
  //   Colors.blue,
  //   Colors.yellow,
  // ];

  final Map<int, ColorInfo> colorInfos = {
    Colors.white.value: ColorInfo('White', 'Unknown'),
    Colors.red.value: ColorInfo('Red', 'Cancel'),
    Colors.green.value: ColorInfo('Green', 'Complete'),
    Colors.blue.value: ColorInfo('Blue', 'Complete but not printed'),
    Colors.yellow.value:
        ColorInfo('Yellow', 'Drafting (Complete but value not put)'),
    Colors.orange.value: ColorInfo('Orange', 'Hold'),
    Colors.purple.value: ColorInfo('Purple', 'Purple'),
    Colors.indigo.value: ColorInfo('Indigo', 'Indigo'),
  };

  int documentCount = 1;

  @override
  void initState() {
    super.initState();
    getDocumentCount(widget.ifscCode);
  }

  Future<void> getDocumentCount(String ifscCode) async {
    try {
      final querySnapshot =
          await context.read<DatasetProvider>().datasets!.where((element) {
        return element.refNo.contains(ifscCode);
      });

      setState(() {
        documentCount = querySnapshot.length;
      });
      print(querySnapshot.length);
    } catch (e) {
      showAlert(context, e.toString());
    }
  }

  DateTime selectedDate = DateTime.now();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomPage2(
      showBack: true,
      pageTitle: 'Create Dateset',
      sidebar: Material(
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(60.0),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Text(
                    'CREATE DATASET',
                    style: GoogleFonts.poppins(
                      textStyle: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 30,
                        // letterSpacing: .5,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                    'PA/${widget.ifscCode}/VR/${documentCount + 1}',
                    style: GoogleFonts.poppins(
                      textStyle: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                    widget.bankName,
                    style: GoogleFonts.poppins(
                      textStyle: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ),
                  Text(
                    '${widget.branchName} Branch',
                    style: GoogleFonts.poppins(
                      textStyle: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ),
                  Text(
                    widget.ifscCode,
                    style: GoogleFonts.poppins(
                      textStyle: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),

                  CustomTextfield(
                    title: 'Party Name',
                    autoFocus: true,
                    controller: partyNameController,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Expanded(
                        child: CustomTextfield(
                          title: 'Colony Name',
                          autoFocus: true,
                          controller: colonyNameController,
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: CustomTextfield(
                          title: 'City/Village Name',
                          autoFocus: true,
                          controller: cityVillageNameController,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  CustomTextfield(
                    title: 'Remarks (Optional)',
                    maxLines: 3,
                    autoFocus: true,
                    controller: remarksController,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                    'Location Coordinates',
                    style: GoogleFonts.poppins(
                      textStyle: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      """Latitude: ${widget.latitude}°N
Longitude: ${widget.longitude}°E""",
                      style: GoogleFonts.poppins(
                        textStyle: const TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),

                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "Market Rate: ",
                        style: GoogleFonts.poppins(
                          textStyle: const TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      Text(
                        "₹${widget.marketRate} per ${widget.unit}",
                        style: GoogleFonts.poppins(
                          textStyle: const TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 21,
                          ),
                        ),
                      ),
                    ],
                  ),
                  // CustomTextfield(
                  //   title: 'Market Rate',
                  //   autoFocus: true,
                  //   controller: marketRateController,
                  // ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: [
                      Text(
                        'Date of Visit: ',
                        style: GoogleFonts.poppins(
                          textStyle: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ),
                      Text(
                        DateFormat('dd-MM-yyyy')
                            .format(selectedDate.toLocal())
                            .toString(),
                        style: GoogleFonts.poppins(
                          textStyle: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 21,
                          ),
                        ),
                      ),
                      const Spacer(),
                      IconButton(
                        onPressed: () {
                          _selectDate(context);
                        },
                        icon: const Icon(Icons.edit),
                      )
                    ],
                  ),
                  // EasyDateTimeLine(
                  //   initialDate: DateTime.now(),
                  //   onDateChange: (selectedDate) {
                  //     setState(() {
                  //       _selectedDate = selectedDate;
                  //     });
                  //   },
                  //   activeColor: const Color(0xff116A7B),
                  //   dayProps: const EasyDayProps(
                  //     landScapeMode: true,
                  //     activeDayStyle: DayStyle(
                  //       borderRadius: 48.0,
                  //     ),
                  //     dayStructure: DayStructure.dayStrDayNum,
                  //   ),
                  //   headerProps: const EasyHeaderProps(
                  //     selectedDateFormat:
                  //         SelectedDateFormat.fullDateDMonthAsStrY,
                  //   ),
                  // ),
                  // const SizedBox(
                  //   height: 20,
                  // ),
                  // NeoPopButton(
                  //   color: CustomColors.mainColor,
                  //   functionUp: () => HapticFeedback.vibrate(),
                  //   functionDown: () => HapticFeedback.vibrate(),
                  //   parentColor: Colors.transparent,
                  //   // buttonPosition: Position.center,
                  //   child: const Padding(
                  //     padding: EdgeInsets.symmetric(
                  //         horizontal: 20, vertical: 15),
                  //     child: Row(
                  //       mainAxisAlignment: MainAxisAlignment.center,
                  //       children: [
                  //         Text(
                  //           "Upload Data",
                  //           style: TextStyle(
                  //             color: Colors.white,
                  //           ),
                  //         ),
                  //       ],
                  //     ),
                  //   ),
                  // ),
                  const SizedBox(
                    height: 30,
                  ),
                  Text(
                    'Color Marker',
                    style: GoogleFonts.poppins(
                      textStyle: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Center(
                    child: SizedBox(
                      height: 80.0,
                      child: ListView.builder(
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        itemCount: colorInfos.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              // Update the selected color
                              setState(() {
                                selectedColor =
                                    Color(colorInfos.keys.toList()[index]);
                              });
                            },
                            child: Container(
                              width: selectedColor ==
                                      Color(colorInfos.keys.toList()[index])
                                  ? 100.0
                                  : 80.0,
                              decoration: BoxDecoration(
                                  color: Color(colorInfos.keys.toList()[index]),
                                  border: Border.all(color: Colors.black87)),
                              margin: const EdgeInsets.all(8.0),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  Card(
                    elevation: 4.0,
                    margin: const EdgeInsets.all(16.0),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            selectedColor != null
                                ? getColorInfo(selectedColor).info
                                : '',
                            style: const TextStyle(fontSize: 14.0),
                          ),
                        ],
                      ),
                    ),
                  ),
                  CustomButton(
                    text: 'Create',
                    onClick: () {
                      if (_formKey.currentState!.validate()) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Data uploaded successfully!!!'),
                          ),
                        );
                      }
                      uploadData();
                    },
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void uploadData() async {
    if (partyNameController.text.isEmpty ||
        cityVillageNameController.text.isEmpty ||
        colonyNameController.text.isEmpty) {
      showAlert(context, 'Empty fields!');
      return;
    }

    try {
      String billId = const Uuid().v4();

      Dataset dataset = Dataset(
        id: 0,
        refNo: 'PA/${widget.ifscCode}/VR/${documentCount + 1}',
        bankName: widget.bankName,
        branchName: widget.branchName,
        partyName: partyNameController.text.toUpperCase(),
        colonyName: colonyNameController.text.toUpperCase(),
        cityVillageName: cityVillageNameController.text.toUpperCase(),
        latitude: widget.latitude,
        longitude: widget.longitude,
        marketRate: widget.marketRate,
        unit: widget.unit.toUpperCase(),
        dateOfVisit: DateTime(
          selectedDate.year,
          selectedDate.month,
          selectedDate.day,
        ),
        remarks: remarksController.text.toUpperCase(),
        createdAt: DateTime.now(),
        colorMark: getColorInfo(selectedColor).name.toUpperCase(),
      );

      await DatasetServices.createDataset(context: context, dataset: dataset);
    } catch (e) {
      showAlert(context, e.toString());
    }

    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const HomePage()), (route) => false);
    showAlert(context, 'Dataset created successfully!');
  }

  ColorInfo getColorInfo(Color color) {
    // Use the colorInfos map to get the ColorInfo object
    return colorInfos[color.value] ?? ColorInfo('Unknown', 'Unknown');
  }
}

class ColorInfo {
  final String name;
  final String info;

  ColorInfo(this.name, this.info);
}

// import 'dart:html' as html;

// import 'package:easy_date_timeline/easy_date_timeline.dart';
// import 'package:excel/excel.dart';
// import 'package:flutter/material.dart' as material;
// import 'package:flutter/material.dart';
// import 'package:geoestate/widgets/custom_button.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:intl/intl.dart';

// import '../utils/utils.dart';
// import '../widgets/custom_page2.dart';

// class ExportExcelPage extends StatefulWidget {
//   const ExportExcelPage({super.key});

//   @override
//   State<ExportExcelPage> createState() => _ExportExcelPageState();
// }

// class _ExportExcelPageState extends State<ExportExcelPage> {
//   DateTime _startDate = DateTime.now();
//   DateTime _endDate = DateTime.now();

//   Future<void> _selectStartDate(BuildContext context) async {
//     DateTime? picked = await showDatePicker(
//       context: context,
//       initialDate: _startDate,
//       firstDate: DateTime(2000),
//       lastDate: DateTime(2101),
//     );

//     if (picked != null && picked != _startDate) {
//       setState(() {
//         _startDate = picked;
//       });
//     }
//   }

//   Future<void> _selectEndDate(BuildContext context) async {
//     DateTime? picked = await showDatePicker(
//       context: context,
//       initialDate: _endDate,
//       firstDate: DateTime(2000),
//       lastDate: DateTime(2101),
//     );

//     if (picked != null && picked != _endDate) {
//       setState(() {
//         _endDate = picked;
//       });
//     }
//   }

//   Future<void> exportDataToExcel(
//       DateTime selectedFromDate, DateTime selectedToDate) async {
//     // Fetch data from Firestore based on the date range
//     try {
//       final QuerySnapshot querySnapshot = await FirebaseFirestore.instance
//           .collection('datasets')
//           .where(
//             'dateOfVisit',
//             isGreaterThanOrEqualTo: DateTime(
//               selectedFromDate.year,
//               selectedFromDate.month,
//               selectedFromDate.day,
//             ),
//           )
//           .where(
//             'dateOfVisit',
//             isLessThanOrEqualTo: DateTime(
//               selectedToDate.year,
//               selectedToDate.month,
//               selectedToDate.day,
//             ),
//           )
//           .get();

//       // Create Excel workbook and sheet
//       final Excel excel = Excel.createExcel();
//       final Sheet sheetObject = excel['Sheet1'];

//       // Add headers to the Excel sheet
//       sheetObject.appendRow([
//         'Ref. No.',
//         'Bank Name',
//         'Branch Name',
//         'Party Name',
//         'Colony Name',
//         'City/Village Name',
//         'Coordinates',
//         'Market Rate (₹)',
//         'Unit (per)',
//         'Date of Valuation',
//         'Date of Visit',
//         'Remarks'
//       ]);

//       final List<QueryDocumentSnapshot> documents = querySnapshot.docs;

//       for (QueryDocumentSnapshot document in documents) {
//         // var data = document.data();
//         sheetObject.appendRow([
//           document['refNo'],
//           document['bankName'],
//           document['branchName'],
//           document['partyName'],
//           document['colonyName'],
//           document['cityVillageName'],
//           '${document['latitude']}°N, ${document['longitude']}°E',
//           document['marketRate'],
//           document['unit'],
//           DateFormat('yyyy-MM-dd')
//               .format(document['dateOfValuation'].toDate())
//               .toString(),
//           DateFormat('yyyy-MM-dd')
//               .format(document['dateOfVisit'].toDate())
//               .toString(),
//           document['remarks'],
//         ]);
//       }

//       // Save Excel file
//       final fileBytes = excel.encode();

//       // Use dart:html to create a Blob and trigger a download
//       final blob = html.Blob([fileBytes]);
//       final url = html.Url.createObjectUrlFromBlob(blob);
//       final anchor = html.AnchorElement(href: url)
//         ..target = 'webbrowser' // Open in a new tab
//         ..download = 'exported_data.xlsx' // Specify the filename
//         ..click();

//       // Clean up
//       html.Url.revokeObjectUrl(url);
//     } on Exception catch (e) {
//       showAlert(context, e.toString());
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return CustomPage2(
//       pageTitle: 'Export Dataset to Excel',
//       sidebar: material.Material(
//         child: SingleChildScrollView(
//           child: Padding(
//             padding: const EdgeInsets.all(60.0),
//             child: Center(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Text(
//                     'Export Dataset to Excel',
//                     style: GoogleFonts.poppins(
//                       textStyle: const TextStyle(
//                         fontWeight: FontWeight.bold,
//                         fontSize: 32,
//                       ),
//                     ),
//                   ),
//                   const SizedBox(
//                     height: 30,
//                   ),
//                   Text(
//                     'Start Date (Date of Visit)',
//                     style: GoogleFonts.poppins(
//                       textStyle: const TextStyle(
//                         fontWeight: FontWeight.bold,
//                         fontSize: 16,
//                       ),
//                     ),
//                   ),
//                   Row(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       Text(
//                         DateFormat('dd-MM-yyyy')
//                             .format(_startDate.toLocal())
//                             .toString(),
//                         style: GoogleFonts.poppins(
//                           textStyle: const TextStyle(
//                             fontWeight: FontWeight.bold,
//                             fontSize: 21,
//                           ),
//                         ),
//                       ),
//                       const SizedBox(
//                         width: 20,
//                       ),
//                       IconButton(
//                         onPressed: () {
//                           _selectStartDate(context);
//                         },
//                         icon: const Icon(Icons.edit),
//                       )
//                     ],
//                   ),
//                   const SizedBox(
//                     height: 20,
//                   ),
//                   Text(
//                     'End Date (Date of Visit)',
//                     style: GoogleFonts.poppins(
//                       textStyle: const TextStyle(
//                         fontWeight: FontWeight.bold,
//                         fontSize: 16,
//                       ),
//                     ),
//                   ),
//                   Row(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       Text(
//                         DateFormat('dd-MM-yyyy')
//                             .format(_endDate.toLocal())
//                             .toString(),
//                         style: GoogleFonts.poppins(
//                           textStyle: const TextStyle(
//                             fontWeight: FontWeight.bold,
//                             fontSize: 21,
//                           ),
//                         ),
//                       ),
//                       const SizedBox(
//                         width: 20,
//                       ),
//                       IconButton(
//                         onPressed: () {
//                           _selectEndDate(context);
//                         },
//                         icon: const Icon(Icons.edit),
//                       )
//                     ],
//                   ),
//                   const SizedBox(
//                     height: 30,
//                   ),
//                   CustomButton(
//                     text: "Export",
//                     onClick: () async {
//                       setState(() {});
//                       await exportDataToExcel(_startDate, _endDate);
//                     },
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

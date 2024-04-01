// import 'package:flutter/material.dart';

// import 'package:geo_estate/widgets/custom_page2.dart';
// import 'package:pdf/pdf.dart';
// import 'package:pdf/widgets.dart' as pw;
// import 'package:printing/printing.dart';

// class BillPrintingPage extends StatelessWidget {
//   const BillPrintingPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return CustomPage2(
//       sidebar: Column(
//         children: [
//           Center(
//             child: ElevatedButton(
//               onPressed: () => _generatePDF(context),
//               child: const Text('Generate GST Bill PDF'),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Future<void> _generatePDF(BuildContext context) async {
//     final pdf = pw.Document();

//     // Add your GST bill content here
//     _buildBill(pdf);

//     // Save PDF file or print it
//     await Printing.layoutPdf(
//       onLayout: (PdfPageFormat format) async => pdf.save(),
//     );
//   }

//   void _buildBill(pw.Document pdf) {
//     pdf.addPage(
//       pw.Page(
//         build: (pw.Context context) {
//           final List<Map<String, dynamic>> items = [
//             {'item': 'Product A', 'quantity': 2, 'price': 20.0},
//             {'item': 'Product B', 'quantity': 1, 'price': 15.0},
//           ];
//           const double total = 55.0;

//           return pw.Column(
//             crossAxisAlignment: pw.CrossAxisAlignment.start,
//             children: [
//               pw.Text('Invoice',
//                   style: pw.TextStyle(
//                       fontSize: 20, fontWeight: pw.FontWeight.bold)),
//               pw.SizedBox(height: 10),
//               pw.Text('Date: ${DateTime.now().toLocal()}'),
//               pw.SizedBox(height: 10),
//               pw.Text('Customer: John Doe'),
//               pw.SizedBox(height: 20),
//               // pw.Table.fromTextArray(
//               //   context: context,
//               //   headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold),
//               //   headers: ['Item', 'Quantity', 'Price', 'Total'],
//               //   data: List<List<String>>.generate(
//               //     items.length,
//               //     (index) => [
//               //       items[index]['item'].toString(),
//               //       items[index]['quantity'].toString(),
//               //       '\$${items[index]['price']}',
//               //       '\$${items[index]['quantity'] * items[index]['price']}',
//               //     ],
//               //   ),
//               // ),
//               pw.SizedBox(height: 20),
//               pw.Text('Total: \$${total.toStringAsFixed(2)}',
//                   style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
//               pw.SizedBox(height: 20),
//             ],
//           );
//         },
//       ),
//     );
//   }
// }

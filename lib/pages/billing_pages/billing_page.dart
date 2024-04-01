// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:easy_date_timeline/easy_date_timeline.dart';
// import 'package:flutter/material.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:geo_estate/widgets/custom_button.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:intl/intl.dart';

// import '../../utils/utils.dart';
// import '../../widgets/custom_page2.dart';
// import '../../widgets/custom_textfield.dart';

// import 'package:pdf/pdf.dart';
// import 'package:pdf/widgets.dart' as pw;
// import 'package:printing/printing.dart';

// class BillingPage extends StatefulWidget {
//   final String partyName;
//   final String refNo;
//   final String address;
//   final String billId;
//   final String bankName;
//   final String branchName;
//   const BillingPage({
//     super.key,
//     required this.partyName,
//     required this.refNo,
//     required this.address,
//     required this.billId,
//     required this.bankName,
//     required this.branchName,
//   });

//   @override
//   State<BillingPage> createState() => _BillingPageState();
// }

// class _BillingPageState extends State<BillingPage> {
//   DateTime _dueDate = DateTime.now();
//   final TextEditingController _ammountController = TextEditingController();
//   final TextEditingController _remarksController = TextEditingController();
//   final TextEditingController _paymentReceivingBankName =
//       TextEditingController();

//   num ammount = 0;
//   var modeOfPayment = '';

//   bool isGstIncluded = false;
//   bool isBillPaid = false;
//   String remarks = 'Remarks';

//   bool isNeft = false;
//   String paymentReceivingBankName = '';

//   @override
//   void dispose() {
//     _ammountController.dispose();
//     _remarksController.dispose();
//     _paymentReceivingBankName.dispose();
//     super.dispose();
//   }

//   @override
//   void initState() {
//     super.initState();
//     getData();
//   }

//   getData() async {
//     try {
//       DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
//           .collection('billing')
//           .doc(widget.billId)
//           .get();

//       if (documentSnapshot.exists) {
//         setState(() {
//           ammount = documentSnapshot['subtotalAmmount'] ?? 0.0;
//           modeOfPayment =
//               documentSnapshot['modeOfPayment'].toString().toLowerCase();
//           _dueDate = documentSnapshot['dueDate'].toDate();
//           remarks = documentSnapshot['remarks'].toString().toUpperCase();
//           paymentReceivingBankName =
//               documentSnapshot['paymentReceivingBankName(NEFT)']
//                   .toString()
//                   .toUpperCase();
//         });
//       } else {
//         _dueDate = DateTime.now();
//         ammount = 0;
//         modeOfPayment = 'gpay';
//       }
//     } catch (e) {
//       showAlert(
//         context,
//         e.toString(),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return CustomPage2(
//       pageTitle: 'Billing',
//       sidebar: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.all(60.0),
//           child: Column(
//             children: [
//               Text(
//                 widget.partyName,
//                 style: GoogleFonts.poppins(
//                   textStyle: const TextStyle(
//                     fontWeight: FontWeight.bold,
//                     fontSize: 21,
//                   ),
//                 ),
//               ),
//               Text(
//                 widget.refNo,
//                 style: GoogleFonts.poppins(
//                   textStyle: const TextStyle(
//                       fontWeight: FontWeight.bold,
//                       fontSize: 16,
//                       color: Colors.grey),
//                 ),
//               ),
//               Text(
//                 widget.address,
//                 style: GoogleFonts.poppins(
//                   textStyle: const TextStyle(
//                       fontWeight: FontWeight.bold,
//                       fontSize: 16,
//                       color: Colors.grey),
//                 ),
//               ),
//               const SizedBox(
//                 height: 20,
//               ),
//               Text(
//                 widget.bankName,
//                 style: GoogleFonts.poppins(
//                   textStyle: const TextStyle(
//                       fontWeight: FontWeight.bold,
//                       fontSize: 16,
//                       color: Colors.grey),
//                 ),
//               ),
//               Text(
//                 '${widget.branchName} branch',
//                 style: GoogleFonts.poppins(
//                   textStyle: const TextStyle(
//                       fontWeight: FontWeight.bold,
//                       fontSize: 16,
//                       color: Colors.grey),
//                 ),
//               ),
//               const SizedBox(
//                 height: 20,
//               ),
//               SizedBox(
//                 width: 300,
//                 child: Row(
//                   children: [
//                     Text(
//                       'Is Bill Paid?',
//                       style: GoogleFonts.poppins(
//                         textStyle: const TextStyle(
//                           fontWeight: FontWeight.bold,
//                           fontSize: 13,
//                         ),
//                       ),
//                     ),
//                     const SizedBox(
//                       width: 20,
//                     ),
//                     InkWell(
//                       onTap: () {
//                         setState(() {
//                           isBillPaid = true;
//                         });
//                       },
//                       child: Card(
//                         color: isBillPaid == true ? Colors.redAccent : null,
//                         child: const SizedBox(
//                           height: 40,
//                           width: 40,
//                           child: Center(child: Text('YES')),
//                         ),
//                       ),
//                     ),
//                     const SizedBox(
//                       width: 10,
//                     ),
//                     InkWell(
//                       onTap: () {
//                         setState(() {
//                           isBillPaid = false;
//                         });
//                       },
//                       child: Card(
//                         color: isBillPaid == false ? Colors.redAccent : null,
//                         child: const SizedBox(
//                           height: 40,
//                           width: 40,
//                           child: Center(child: Text('No')),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               const SizedBox(
//                 height: 20,
//               ),
//               Text(
//                 'Mode of Payment',
//                 style: GoogleFonts.poppins(
//                   textStyle: const TextStyle(
//                     fontWeight: FontWeight.bold,
//                     fontSize: 13,
//                   ),
//                 ),
//               ),
//               const SizedBox(
//                 height: 20,
//               ),
//               SizedBox(
//                 height: 60,
//                 child: ListView(
//                   shrinkWrap: true,
//                   scrollDirection: Axis.horizontal,
//                   children: [
//                     InkWell(
//                       onTap: () {
//                         setState(() {
//                           modeOfPayment = 'cash';
//                         });
//                       },
//                       child: Card(
//                         color:
//                             modeOfPayment == 'cash' ? Colors.redAccent : null,
//                         child: const SizedBox(
//                           height: 60,
//                           width: 80,
//                           child: Column(
//                             children: [
//                               SizedBox(
//                                 width: 60,
//                                 child: Icon(FontAwesomeIcons.cashRegister),
//                               ),
//                               Text('Cash'),
//                             ],
//                           ),
//                         ),
//                       ),
//                     ),
//                     const SizedBox(
//                       width: 20,
//                     ),
//                     InkWell(
//                       onTap: () {
//                         setState(() {
//                           modeOfPayment = 'gpay';
//                         });
//                       },
//                       child: Card(
//                         color:
//                             modeOfPayment == 'gpay' ? Colors.redAccent : null,
//                         child: const SizedBox(
//                           height: 60,
//                           width: 80,
//                           child: Column(
//                             children: [
//                               SizedBox(
//                                 width: 60,
//                                 child: Icon(FontAwesomeIcons.googlePay),
//                               ),
//                               Text('GPay'),
//                             ],
//                           ),
//                         ),
//                       ),
//                     ),
//                     const SizedBox(
//                       width: 20,
//                     ),
//                     InkWell(
//                       onTap: () {
//                         setState(() {
//                           modeOfPayment = 'neft';
//                         });
//                       },
//                       child: Card(
//                         color:
//                             modeOfPayment == 'neft' ? Colors.redAccent : null,
//                         child: const SizedBox(
//                           height: 60,
//                           width: 80,
//                           child: Column(
//                             children: [
//                               SizedBox(
//                                 width: 60,
//                                 child: Icon(FontAwesomeIcons.bank),
//                               ),
//                               Text('NEFT'),
//                             ],
//                           ),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               modeOfPayment == 'neft'
//                   ? Card(
//                       child: SizedBox(
//                         width: 300,
//                         child: Center(
//                           child: Padding(
//                             padding: const EdgeInsets.all(8.0),
//                             child: Column(
//                               children: [
//                                 Row(
//                                   children: [
//                                     Text(
//                                       'Bank Name:   ',
//                                       style: GoogleFonts.poppins(
//                                         textStyle: const TextStyle(
//                                           fontWeight: FontWeight.bold,
//                                           fontSize: 14,
//                                         ),
//                                       ),
//                                     ),
//                                     Flexible(
//                                       child: Text(
//                                         paymentReceivingBankName,
//                                         style: GoogleFonts.poppins(
//                                           textStyle: const TextStyle(
//                                               fontWeight: FontWeight.bold,
//                                               fontSize: 14,
//                                               color: Colors.green),
//                                         ),
//                                       ),
//                                     ),
//                                     const Spacer(),
//                                     IconButton(
//                                       onPressed: () {
//                                         addPaymentReceivingBankName();
//                                       },
//                                       icon: const Icon(FontAwesomeIcons.edit),
//                                     ),
//                                   ],
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),
//                       ),
//                     )
//                   : const SizedBox(),
//               const SizedBox(
//                 width: 20,
//               ),
//               Text(
//                 'Remarks: ',
//                 style: GoogleFonts.poppins(
//                   textStyle: const TextStyle(
//                     fontWeight: FontWeight.bold,
//                     fontSize: 14,
//                   ),
//                 ),
//               ),
//               const SizedBox(
//                 width: 10,
//               ),
//               Card(
//                 child: SizedBox(
//                   width: 300,
//                   child: Center(
//                     child: Padding(
//                       padding: const EdgeInsets.all(8.0),
//                       child: CustomTextfield(
//                         controller: _remarksController,
//                         title: remarks.toString(),
//                         maxLines: 4,
//                         onChanged: (value) {
//                           setState(() {
//                             remarks = value.toUpperCase();
//                           });
//                         },
//                       ),
//                       // child: Row(
//                       //   children: [
//                       //     // // Text(
//                       //     // //   _remarksController.text.toUpperCase(),
//                       //     // //   softWrap: true,
//                       //     // //   maxLines: 4,
//                       //     // //   style: GoogleFonts.poppins(
//                       //     // //     textStyle: const TextStyle(
//                       //     // //       // fontWeight: FontWeight.bold,
//                       //     // //       fontSize: 13,
//                       //     // //     ),
//                       //     // //   ),
//                       //     // // ),
//                       //     // const Spacer(),
//                       //     // IconButton(
//                       //     //   onPressed: () {
//                       //     //     addRemarks();
//                       //     //   },
//                       //     //   icon: const Icon(FontAwesomeIcons.edit),
//                       //     // ),
//                       //   ],
//                       // ),
//                     ),
//                   ),
//                 ),
//               ),
//               const SizedBox(
//                 height: 20,
//               ),
//               Card(
//                 child: SizedBox(
//                   width: 300,
//                   child: Center(
//                     child: Padding(
//                       padding: const EdgeInsets.all(8.0),
//                       child: Column(
//                         children: [
//                           Row(
//                             children: [
//                               Text(
//                                 'Subtotal Amount: ',
//                                 style: GoogleFonts.poppins(
//                                   textStyle: const TextStyle(
//                                     fontWeight: FontWeight.bold,
//                                     fontSize: 14,
//                                   ),
//                                 ),
//                               ),
//                               Text(
//                                 '₹$ammount',
//                                 style: GoogleFonts.poppins(
//                                   textStyle: const TextStyle(
//                                       fontWeight: FontWeight.bold,
//                                       fontSize: 21,
//                                       color: Colors.green),
//                                 ),
//                               ),
//                               const Spacer(),
//                               IconButton(
//                                 onPressed: () {
//                                   addAmmount();
//                                 },
//                                 icon: const Icon(FontAwesomeIcons.edit),
//                               ),
//                             ],
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//               const SizedBox(
//                 height: 20,
//               ),
//               SizedBox(
//                 width: 300,
//                 child: Row(
//                   children: [
//                     Text(
//                       'Include GST',
//                       style: GoogleFonts.poppins(
//                         textStyle: const TextStyle(
//                           fontWeight: FontWeight.bold,
//                           fontSize: 13,
//                         ),
//                       ),
//                     ),
//                     const SizedBox(
//                       width: 20,
//                     ),
//                     InkWell(
//                       onTap: () {
//                         setState(() {
//                           isGstIncluded = true;
//                         });
//                       },
//                       child: Card(
//                         color: isGstIncluded == true ? Colors.redAccent : null,
//                         child: const SizedBox(
//                           height: 40,
//                           width: 40,
//                           child: Center(child: Text('YES')),
//                         ),
//                       ),
//                     ),
//                     const SizedBox(
//                       width: 10,
//                     ),
//                     InkWell(
//                       onTap: () {
//                         setState(() {
//                           isGstIncluded = false;
//                         });
//                       },
//                       child: Card(
//                         color: isGstIncluded == false ? Colors.redAccent : null,
//                         child: const SizedBox(
//                           height: 40,
//                           width: 40,
//                           child: Center(child: Text('No')),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               const SizedBox(
//                 height: 20,
//               ),
//               isGstIncluded == true
//                   ? Card(
//                       child: SizedBox(
//                         width: 300,
//                         child: Padding(
//                           padding: const EdgeInsets.all(8.0),
//                           child: Column(
//                             children: [
//                               Row(
//                                 children: [
//                                   Text(
//                                     'CGST(9%): ',
//                                     style: GoogleFonts.poppins(
//                                       textStyle: const TextStyle(
//                                         fontWeight: FontWeight.bold,
//                                         fontSize: 13,
//                                       ),
//                                     ),
//                                   ),
//                                   const SizedBox(
//                                     width: 10,
//                                   ),
//                                   Text(
//                                     '₹${(9 / 100) * ammount}',
//                                     style: GoogleFonts.poppins(
//                                       textStyle: const TextStyle(
//                                         fontWeight: FontWeight.bold,
//                                         fontSize: 16,
//                                       ),
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                               Row(
//                                 children: [
//                                   Text(
//                                     'SGST(9%): ',
//                                     style: GoogleFonts.poppins(
//                                       textStyle: const TextStyle(
//                                         fontWeight: FontWeight.bold,
//                                         fontSize: 13,
//                                       ),
//                                     ),
//                                   ),
//                                   const SizedBox(
//                                     width: 10,
//                                   ),
//                                   Text(
//                                     '₹${(9 / 100) * ammount}',
//                                     style: GoogleFonts.poppins(
//                                       textStyle: const TextStyle(
//                                         fontWeight: FontWeight.bold,
//                                         fontSize: 16,
//                                       ),
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                     )
//                   : const SizedBox(),
//               const SizedBox(
//                 height: 10,
//               ),
//               Card(
//                 child: SizedBox(
//                   width: 300,
//                   child: Padding(
//                     padding: const EdgeInsets.all(8.0),
//                     child: Row(
//                       children: [
//                         Text(
//                           'Gross Total: ',
//                           style: GoogleFonts.poppins(
//                             textStyle: const TextStyle(
//                               fontWeight: FontWeight.bold,
//                               fontSize: 16,
//                             ),
//                           ),
//                         ),
//                         Text(
//                           '₹${(isGstIncluded ? ((9 / 100) * ammount) + ((9 / 100) * ammount) : 0) + ammount}',
//                           style: GoogleFonts.poppins(
//                             textStyle: const TextStyle(
//                                 fontWeight: FontWeight.bold,
//                                 fontSize: 21,
//                                 color: Colors.green),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//               const SizedBox(
//                 height: 20,
//               ),
//               Text(
//                 'Due Date: ${DateFormat('yyyy-MM-dd').format(_dueDate).toString()}',
//                 style: GoogleFonts.poppins(
//                   textStyle: const TextStyle(
//                     fontWeight: FontWeight.bold,
//                     fontSize: 21,
//                   ),
//                 ),
//               ),
//               Padding(
//                 padding: const EdgeInsets.all(21.0),
//                 child: EasyDateTimeLine(
//                   initialDate: _dueDate,
//                   onDateChange: (selectedDate) {
//                     setState(() {
//                       _dueDate = selectedDate;
//                     });
//                   },
//                   activeColor: const Color(0xff116A7B),
//                   dayProps: const EasyDayProps(
//                     landScapeMode: true,
//                     activeDayStyle: DayStyle(
//                       borderRadius: 48.0,
//                     ),
//                     dayStructure: DayStructure.dayStrDayNum,
//                   ),
//                   headerProps: const EasyHeaderProps(
//                     selectedDateFormat: SelectedDateFormat.fullDateDMonthAsStrY,
//                   ),
//                 ),
//               ),
//               const SizedBox(
//                 height: 20,
//               ),
//               Row(
//                 children: [
//                   Expanded(
//                     child: CustomButton(
//                       text: 'Update',
//                       onClick: () {
//                         uploadeBillingData();
//                         setState(() {});
//                       },
//                     ),
//                   ),
//                   const SizedBox(
//                     width: 20,
//                   ),
//                   Expanded(
//                     child: CustomButton(
//                       text: 'Export',
//                       onClick: () {
//                         _generatePDF(context);
//                       },
//                     ),
//                   ),
//                 ],
//               )
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   addPaymentReceivingBankName() {
//     showDialog(
//         context: context,
//         builder: (context) {
//           return AlertDialog(
//             content: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 CustomTextfield(
//                   title: 'Bank Name',
//                   autoFocus: true,
//                   controller: _paymentReceivingBankName,
//                   onChanged: (value) {
//                     setState(() {
//                       paymentReceivingBankName = value.toUpperCase();
//                     });
//                   },
//                 ),
//               ],
//             ),
//             actions: [
//               TextButton(
//                 child: const Text(
//                   "Cancel",
//                 ),
//                 onPressed: () {
//                   Navigator.pop(context);
//                 },
//               ),
//               ElevatedButton(
//                 child: const Text(
//                   "OK",
//                 ),
//                 onPressed: () {
//                   setState(() {});
//                   Navigator.of(context).pop();
//                 },
//               ),
//             ],
//           );
//         });
//   }

//   addAmmount() {
//     showDialog(
//         context: context,
//         builder: (context) {
//           return AlertDialog(
//             content: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 CustomTextfield(
//                   title: 'Amount',
//                   autoFocus: true,
//                   controller: _ammountController,
//                   onChanged: (value) {
//                     setState(() {
//                       ammount = num.tryParse(value) ?? 0;
//                     });
//                   },
//                 ),
//               ],
//             ),
//             actions: [
//               TextButton(
//                 child: const Text(
//                   "Cancel",
//                 ),
//                 onPressed: () {
//                   Navigator.pop(context);
//                 },
//               ),
//               ElevatedButton(
//                 child: const Text(
//                   "OK",
//                 ),
//                 onPressed: () {
//                   // setState(() {});
//                   Navigator.of(context).pop();
//                 },
//               ),
//             ],
//           );
//         });
//   }

//   addRemarks() {
//     showDialog(
//         context: context,
//         builder: (context) {
//           return AlertDialog(
//             content: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 CustomTextfield(
//                   title: 'Remarks',
//                   autoFocus: true,
//                   maxLines: 4,
//                   controller: _remarksController,
//                   onChanged: (value) {
//                     setState(() {});
//                   },
//                 ),
//               ],
//             ),
//             actions: [
//               TextButton(
//                 child: const Text(
//                   "Cancel",
//                 ),
//                 onPressed: () {
//                   Navigator.pop(context);
//                 },
//               ),
//               ElevatedButton(
//                 child: const Text(
//                   "OK",
//                 ),
//                 onPressed: () {
//                   Navigator.of(context).pop();
//                 },
//               ),
//             ],
//           );
//         });
//   }

//   uploadeBillingData() async {
//     try {
//       await FirebaseFirestore.instance
//           .collection('billing')
//           .doc(widget.billId)
//           .set({
//         'refNo': widget.refNo.toString().toUpperCase(),
//         'partyName': widget.partyName.toString().toUpperCase(),
//         'partyAddress': widget.address.toString().toUpperCase(),
//         'bankName': widget.bankName.toString().toUpperCase(),
//         'branchName': widget.branchName.toString().toUpperCase(),
//         'modeOfPayment': modeOfPayment.toString().toUpperCase(),
//         'isBillPaid': isBillPaid,
//         'remarks': remarks.toString().toUpperCase(),
//         'subtotalAmmount': ammount,
//         'paymentReceivingBankName(NEFT)':
//             paymentReceivingBankName.toString().toUpperCase(),
//         'isGstIncluded': isGstIncluded,
//         'CGST(9%)': isGstIncluded ? ((9 / 100) * ammount) : 0,
//         'SGST(9%)': isGstIncluded ? ((9 / 100) * ammount) : 0,
//         'grossTotal': (isGstIncluded
//                 ? ((9 / 100) * ammount) + ((9 / 100) * ammount)
//                 : 0) +
//             ammount,
//         'dueDate': _dueDate,
//         'createdAt': DateTime.now(),
//       });
//     } catch (e) {
//       showAlert(
//         context,
//         e.toString(),
//       );

//       return;
//     }
//     showAlert(
//       context,
//       'Billing Updated!',
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
//               pw.Text('Party Name: Example Name'),
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
//               pw.Text('Total: ${total.toStringAsFixed(2)}',
//                   style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
//               pw.SizedBox(height: 20),
//             ],
//           );
//         },
//       ),
//     );
//   }
// }

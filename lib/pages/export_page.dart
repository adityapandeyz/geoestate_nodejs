import 'dart:io';

import 'package:excel/excel.dart';
import 'package:flutter/material.dart' as material;
import 'package:flutter/material.dart';
import 'package:geoestate/provider/dataset_provider.dart';
import 'package:geoestate/widgets/custom_button.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

import '../constants/utils.dart';
import '../widgets/custom_page2.dart';

class ExportExcelPage extends StatefulWidget {
  static const routeName = '/export-excel';
  const ExportExcelPage({super.key});

  @override
  State<ExportExcelPage> createState() => _ExportExcelPageState();
}

class _ExportExcelPageState extends State<ExportExcelPage> {
  DateTime _startDate = DateTime.now();
  DateTime _endDate = DateTime.now();

  Future<void> _selectStartDate(BuildContext context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _startDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (picked != null && picked != _startDate) {
      setState(() {
        _startDate = picked;
      });
    }
  }

  Future<void> _selectEndDate(BuildContext context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _endDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (picked != null && picked != _endDate) {
      setState(() {
        _endDate = picked;
      });
    }
  }

  Future<void> exportDataToExcel(
      DateTime selectedFromDate, DateTime selectedToDate) async {
    try {
      final filteredData = context
          .read<DatasetProvider>()
          .datasets!
          .where((dataset) =>
              dataset.dateOfVisit.isAfter(selectedFromDate) &&
              dataset.dateOfVisit.isBefore(selectedToDate))
          .toList();

      // Create Excel workbook and sheet
      final Excel excel = Excel.createExcel();
      final Sheet sheetObject = excel['Sheet1'];

      // Add headers to the Excel sheet
      sheetObject.appendRow(
        [
          TextCellValue('Ref No'),
          TextCellValue('Bank Name'),
          TextCellValue('Branch Name'),
          TextCellValue('Party Name'),
          TextCellValue('Colony Name'),
          TextCellValue('City/Village Name'),
          TextCellValue('Location'),
          TextCellValue('Market Rate'),
          TextCellValue('Unit'),
          TextCellValue('Date of Visit'),
          TextCellValue('Remarks'),
        ],
      );

      for (final document in filteredData) {
        // var data = document.data();
        sheetObject.appendRow([
          TextCellValue(document.refNo),
          TextCellValue(document.bankName),
          TextCellValue(document.branchName),
          TextCellValue(document.partyName),
          TextCellValue(document.colonyName),
          TextCellValue(document.cityVillageName),
          TextCellValue('${document.latitude}°N, ${document.longitude}°E'),
          TextCellValue(document.marketRate.toString()),
          TextCellValue(document.unit),
          TextCellValue(DateFormat('yyyy-MM-dd').format(document.dateOfVisit)),
          TextCellValue(document.remarks),
        ]);
      }

      // Save Excel file
      final fileBytes = excel.encode();

      final String fileName =
          'GeoEstate_${DateFormat('dd-MM-yyyy').format(selectedFromDate)}_to_${DateFormat('dd-MM-yyyy').format(selectedToDate)}.xlsx';

      final String path = await saveFile(fileName, fileBytes!);

      showAlert(context, 'File saved at $path');
    } on Exception catch (e) {
      showAlert(context, e.toString());
    }
  }

  saveFile(String fileName, List<int> bytes) async {
    final path = await await getDownloadsDirectory();
    final file = File('${path!.path}/$fileName');
    await file.writeAsBytes(bytes, flush: true);
    return file.path;
  }

  @override
  Widget build(BuildContext context) {
    return CustomPage2(
      pageTitle: 'Export Dataset',
      sidebar: material.Material(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(60.0),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Export Dataset to Excel',
                    style: GoogleFonts.poppins(
                      textStyle: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 32,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Text(
                    'Start Date (Date of Visit)',
                    style: GoogleFonts.poppins(
                      textStyle: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        DateFormat('dd-MM-yyyy')
                            .format(_startDate.toLocal())
                            .toString(),
                        style: GoogleFonts.poppins(
                          textStyle: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 21,
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      IconButton(
                        onPressed: () {
                          _selectStartDate(context);
                        },
                        icon: const Icon(Icons.edit),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                    'End Date (Date of Visit)',
                    style: GoogleFonts.poppins(
                      textStyle: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        DateFormat('dd-MM-yyyy')
                            .format(_endDate.toLocal())
                            .toString(),
                        style: GoogleFonts.poppins(
                          textStyle: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 21,
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      IconButton(
                        onPressed: () {
                          _selectEndDate(context);
                        },
                        icon: const Icon(Icons.edit),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  CustomButton(
                    text: "Export",
                    onClick: () async {
                      setState(() {});
                      await exportDataToExcel(_startDate, _endDate);
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

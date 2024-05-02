import 'package:flutter/material.dart';
import 'package:geoestate/services/dataset_services.dart';

import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:data_table_2/data_table_2.dart';

import '../Models/dataset.dart';
import '../provider/dataset_provider.dart';
import '../constants/utils.dart';
import '../widgets/custom_textfield.dart';
import 'map_page.dart';

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

class _DataSource extends DataTableSource {
  final List<Dataset> data;
  final BuildContext context;
  final void Function(bool) setIsLoading;
  final void Function(DateTime, int id) setSelectedDate;

  _DataSource({
    required this.data,
    required this.context,
    required this.setIsLoading,
    required this.setSelectedDate,
  });

  bool _isLoading = false;
  String selectedColor = 'white'; // Default selected color

  TextEditingController updatePartyNameController = TextEditingController();
  TextEditingController updaterefNoController = TextEditingController();

  TextEditingController updateColonyNameController = TextEditingController();
  TextEditingController updateCityVillageNameController =
      TextEditingController();
  TextEditingController updateMarketRateController = TextEditingController();
  TextEditingController updateRemarksController = TextEditingController();
  TextEditingController updateUnitController = TextEditingController();

  void _selectDate(BuildContext context, DateTime date, int id) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: date,
      firstDate: DateTime(1600),
      lastDate: DateTime(2350),
    );
    if (picked != null && picked != date) {
      setSelectedDate(picked.toLocal(), id);
    }
  }

  void removeExistingDataset(int id, context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            "Remove Dataset",
            style: TextStyle(fontSize: 16),
          ),
          content: const Text(
            "Are you sure you want to remove this dataset?",
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
              child: _isLoading
                  ? const CircularProgressIndicator()
                  : const Text(
                      "Remove",
                    ),
              onPressed: () async {
                setIsLoading(true);

                try {
                  await DatasetServices.deleteDataset(id);

                  await context.read<DatasetProvider>().loadDatasets();
                } catch (e) {
                  print(e);
                }

                setIsLoading(false);
                Navigator.pop(context);
              },
            )
          ],
        );
      },
    );
  }

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

  @override
  DataRow? getRow(int index) {
    if (index >= data.length) {
      return null;
    }

    final item = data[index];

    return DataRow(
      color: MaterialStateProperty.resolveWith<Color?>(
        (Set<MaterialState> states) {
          return getColor(data[index].colorMark.toString().toLowerCase())
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
        DataCell(Text(data[index].cityVillageName.toString())),
        DataCell(
          Text(
            '${data[index].latitude}°N, ${data[index].longitude}°E',
          ),
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => MapPage(
                  latitude: data[index].latitude.toString(),
                  longitude: data[index].latitude.toString(),
                  zoom: 20,
                ),
              ),
            );
          },
        ),
        DataCell(Text(data[index].marketRate.toString())),
        DataCell(Text(data[index].unit.toString())),
        // DataCell(Text(DateFormat('yyyy-MM-dd')
        //     .format(data['dateOfValuation'].toDate())
        //     .toString())),
        // _isLoading
        //     ? DataCell(
        //         CircularProgressIndicator(),
        //       )
        //     :
        DataCell(
          Row(
            children: [
              Text(
                DateFormat('EEE dd-MM-yyyy').format(
                  data[index].dateOfVisit.toLocal(),
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
                cityVillageName: data[index].cityVillageName,
                marketRate: data[index].marketRate,
                unit: data[index].unit,
                remarks: data[index].remarks,
                colorMark: data[index].colorMark,
                // Keep existing datasetName
                bankName: data[index].bankName, // Keep existing bankName
                latitude: data[index].latitude, // Keep existing latitude
                branchName: data[index].branchName, // Keep existing branchName
                longitude: data[index].longitude, // Keep existing longitude

                createdAt: data[index].createdAt, // Keep existing createdAt
                dateOfVisit:
                    data[index].dateOfVisit, // Keep existing dateOfVisit
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
                removeExistingDataset(data[index].id, context);
              }),
        )),
      ],
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => data.length;

  @override
  int get selectedRowCount => 0;
}

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

  bool _isLoading = false;
  int _pageSize = 10;

  DateTime _selectedDate = DateTime.now();

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

  void updateDate(
    id,
  ) async {
    try {
      setIsLoading(true);

      await DatasetServices.updateDateOfVisit(
        id: id,
        dateOfVisit: _selectedDate,
      );

      await context.read<DatasetProvider>().loadDatasets();
      setIsLoading(false);
    } catch (e) {
      print(e);
      setIsLoading(false);
    }
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

  void setIsLoading(bool value) {
    setState(() {
      _isLoading = value;
    });
  }

  void setSelectedDate(DateTime value, int id) {
    setState(() {
      _selectedDate = value;
    });
    updateDate(id);
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
      body: Column(
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
              return Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: PaginatedDataTable2(
                    columnSpacing: 12,
                    horizontalMargin: 12,
                    minWidth: 3000,
                    headingRowColor: MaterialStateProperty.all(
                      const Color.fromARGB(255, 163, 163, 163),
                    ),
                    rowsPerPage: _pageSize,
                    availableRowsPerPage: const [10, 25, 50],
                    onRowsPerPageChanged: (value) {
                      setState(() {
                        _pageSize = value!;
                      });
                    },
                    columns: const [
                      DataColumn(
                        label: Text('S. No.'),
                        numeric: true,
                      ),
                      DataColumn(
                        label: Text('Ref. No.'),
                      ),
                      DataColumn(
                        label: Text('Bank Name'),
                      ),
                      DataColumn(
                        label: Text('Branch Name'),
                      ),
                      DataColumn(
                        label: Text('Party Name'),
                      ),
                      DataColumn(
                        label: Text('Colony Name'),
                      ),
                      DataColumn(
                        label: Text('City/Village Name'),
                      ),
                      DataColumn(
                        label: Text('Coordinates'),
                      ),
                      DataColumn(
                        label: Text('Market Rate (₹)'),
                      ),
                      DataColumn(
                        label: Text('Unit (per)'),
                      ),
                      // DataColumn(label: Text('Date of Valuation')),
                      DataColumn(
                        label: Text('Date of Visit'),
                      ),
                      DataColumn(
                        label: Text('Remarks'),
                      ),
                      DataColumn(
                        label: Text('Entry By'),
                      ),
                      DataColumn(
                        label: Text('Edit'),
                      ),
                      DataColumn(
                        label: Text('Remove Data'),
                      ),
                    ],
                    source: _DataSource(
                      data: filteredData,
                      context: context,
                      setIsLoading: setIsLoading,
                      setSelectedDate: setSelectedDate,
                    ),
                  ),
                ),
              );
            },
          )
        ],
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

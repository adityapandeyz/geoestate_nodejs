import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geoestate/Models/my_marker.dart' as myClient;
import 'package:geoestate/constants/global_variables.dart';
import 'package:geoestate/provider/dataset_provider.dart';
import 'package:geoestate/services/marker_services.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../Models/search.dart';

import 'package:latlong2/latlong.dart';

import '../provider/marker_provider.dart';
import '../constants/utils.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_marker_widget.dart';
import '../widgets/custom_textfield.dart';
import 'create_pages/select_bank_page.dart';
import 'dateset_page.dart';

class MapPage extends StatefulWidget {
  static const String routeName = '/map';
  final String latitude;
  final String longitude;
  final int zoom;
  const MapPage({
    super.key,
    this.latitude = '22.1284835',
    this.longitude = '75.4469949',
    this.zoom = 5,
  });

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  final _coordinatesController = TextEditingController();
  final _marketRateController = TextEditingController();
  final _unitController = TextEditingController();
  final _searchController = TextEditingController();
  bool isShowResult = false;
  bool _isLoading = false;

  final _passPhraseController = TextEditingController();

  bool isAdmin = false;
  late String _selectedUnit = "SQFT";

  bool showMenu = true;

  final int initialDisplayLimit = 5;
  int displayLimit = 10;

  @override
  void dispose() {
    _coordinatesController.dispose();
    _passPhraseController.dispose();
    _marketRateController.dispose();
    _unitController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  MapController mapController = MapController();
  String selectedMapType = 'Google Maps Hybrid';
  String locationName = '';

  List<DropdownMenuItem<String>> get dropdownItems {
    List<DropdownMenuItem<String>> menuItems = [
      const DropdownMenuItem(
        value: 'Google Maps Hybrid',
        child: Text('Google Maps Hybrid'),
      ),
      const DropdownMenuItem(
        value: 'Google Maps Normal',
        child: Text('Google Maps Normal'),
      ),
      const DropdownMenuItem(
        value: 'OpenStreetMap',
        child: Text('OpenStreetMap'),
      ),
      const DropdownMenuItem(
        value: 'Mapbox Satellite Imagery',
        child: Text('Mapbox Satellite Imagery'),
      ),
      // const material.DropdownMenuItem(
      //   value: 'Bing Maps Satellite',
      //   child: Text('Bing Maps Satellite'),
      // ),
    ];

    return menuItems;
  }

  TileLayer getTileLayer(String mapType) {
    switch (mapType) {
      case 'Google Maps Hybrid':
        return TileLayer(
          urlTemplate:
              'https://mt0.google.com/vt/lyrs=y@221097413,traffic,transit,bike&x={x}&y={y}&z={z}', // Custom Google Maps Tile URL
          subdomains: const ['mt0', 'mt1', 'mt2', 'mt3'],
        );

      case 'Google Maps Normal':
        return TileLayer(
          urlTemplate: 'https://mt0.google.com/vt/lyrs=m&x={x}&y={y}&z={z}',
          subdomains: const ['mt0', 'mt1', 'mt2', 'mt3'],
        );

      case 'Mapbox Satellite Imagery':
        return TileLayer(
          urlTemplate:
              'https://api.mapbox.com/styles/v1/adityapandeyz/clp6kchsd01mu01qy8dcq3eih/tiles/256/{z}/{x}/{y}@2x?access_token=pk.eyJ1IjoiYWRpdHlhcGFuZGV5eiIsImEiOiJjbGk3c29wdDgxNWZ5M2trYjIxcHkwdGNhIn0.x5TouUXnPBJ4196DGRrfzQ', // Google Maps URL
          subdomains: const ['mt0', 'mt1', 'mt2', 'mt3'],
        );

      case 'OpenStreetMap':
        return TileLayer(
          urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
          subdomains: const ['a', 'b', 'c'],
        );
      default:
        return TileLayer(
          urlTemplate: 'https://mt0.google.com/vt/lyrs=m&x={x}&y={y}&z={z}',
          subdomains: const ['mt0', 'mt1', 'mt2', 'mt3'],
        );
    }
  }

  List userMarkers = [];
  List searchMarkers = [];
  bool isSearching = false;
  bool isDescending = true;

  double latitude = 0.0;
  double longitude = 0.0;

  List<Map<String, dynamic>> cordinatesList = [];
  List<Map<String, dynamic>> lngList = [];

  String selectedColor = 'red'; // Default selected color
  List<String> colors = ['red', 'blue', 'green', 'purple', 'black', 'indigo'];

  Color getColor(String colorName) {
    switch (colorName) {
      case 'red':
        return Colors.red;
      case 'blue':
        return Colors.blue;
      case 'orange':
        return Colors.orange;
      case 'green':
        return Colors.green;
      case 'purple':
        return Colors.purple;
      case 'black':
        return Colors.black;
      case 'indigo':
        return Colors.indigo;
      default:
        return Colors.white; // Default color
    }
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: const Text('Map'),
        actions: [
          DropdownButton(
            value: selectedMapType,
            items: dropdownItems,
            onChanged: (String? newValue) {
              setState(() {
                selectedMapType = newValue!;
              });
            },
          ),
          const SizedBox(
            width: 20,
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              setState(() {
                _isLoading = true;
              });
              context.read<MarkerProvider>().loadMarkers();

              setState(() {
                _isLoading = false;
              });
            },
          ),
          IconButton(
            icon: Icon(Icons.menu), // Drawer icon
            onPressed: () {
              setState(() {
                if (showMenu == false) {
                  showMenu = true;
                } else {
                  showMenu = false;
                }
              });
            },
          ),
        ],
      ),
      body: Consumer<MarkerProvider>(builder: (
        context,
        markersProvider,
        child,
      ) {
        List<Marker> allMarkers = [];

        if (markersProvider.markers != null) {
          allMarkers.addAll(
            markersProvider.markers!.map(
              (doc) {
                return Marker(
                  point: LatLng(doc.latitude, doc.longitude),
                  width: 180,
                  height: 32,
                  child: CustomMarkerWidget(
                    lat: doc.latitude,
                    lng: doc.longitude,
                    price: doc.marketRate,
                    unit: doc.unit,
                    color: doc.color,
                    onTap: () {
                      setState(() {
                        _searchController.value = TextEditingValue(
                          text: '${doc.latitude}',
                        );
                      });
                    },
                  ),
                );
              },
            ),
          );
        }
        if (searchMarkers.isNotEmpty) {
          allMarkers.addAll(
            searchMarkers.map((searchMarker) {
              return Marker(
                point: LatLng(searchMarker.latitude, searchMarker.longitude),
                width: 80,
                height: 80,
                child: const Icon(
                  Icons.location_on,
                  color: Colors.red,
                  size: 60,
                ),
              );
            }),
          );
        }

        return Stack(
          alignment: AlignmentDirectional.centerEnd,
          children: [
            SizedBox(
              width: double.maxFinite,
              child: FlutterMap(
                mapController: mapController,
                options: MapOptions(
                  initialCenter: LatLng(
                    double.parse(widget.latitude),
                    double.parse(
                      widget.longitude,
                    ),
                  ),
                  initialZoom: widget.zoom == 5 ? 5.0 : 19.0,
                  maxZoom: 19.5,
                  minZoom: 5,
                ),
                children: [
                  getTileLayer(selectedMapType),
                  MarkerLayer(markers: allMarkers),
                  RichAttributionWidget(
                    animationConfig:
                        const ScaleRAWA(), // Or `FadeRAWA` as is default
                    attributions: [
                      TextSourceAttribution(
                        'Mapbox',
                        onTap: () => launchUrl(
                          Uri.parse('https://www.mapbox.com/about/maps/'),
                        ),
                      ),
                      TextSourceAttribution(
                        'OpenStreetMap contributors',
                        onTap: () => launchUrl(
                            Uri.parse('hhttps://www.openstreetmap.org/about/')),
                      ),
                      TextSourceAttribution(
                        'Improve this map',
                        onTap: () => launchUrl(Uri.parse(
                            'https://www.mapbox.com/map-feedback/#/-74.5/40/10')),
                        prependCopyright: false,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            if (showMenu) sidebar(context) else SizedBox(),
          ],
        );
      }),
    );
  }

  Container sidebar(BuildContext context) {
    return Container(
      width: 500,
      color: AppColors.backgroundColor,
      child: ListView(
        padding: const EdgeInsets.only(left: 20, right: 20),
        children: [
          const SizedBox(
            height: 20,
          ),
          Text(
            'Markers',
            style: GoogleFonts.poppins(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.start,
          ),
          const SizedBox(
            height: 20,
          ),
          CustomTextfield(
            title: 'Coordinates(,)',
            controller: _coordinatesController,
            onChanged: (value) {},
            suffix: _coordinatesController.text.isNotEmpty
                ? IconButton(
                    icon: const Icon(
                      FontAwesomeIcons.close,
                    ),
                    onPressed: () {
                      searchMarkers.clear();
                      _coordinatesController.clear();
                      _searchController.clear();
                      mapController.move(
                        LatLng(
                          double.parse('20.5937'),
                          double.parse('78.9629'),
                        ),
                        5,
                      );

                      setState(() {});
                    },
                  )
                : const SizedBox(),
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(
                child: CustomButton(
                  text: 'Search',
                  onClick: () {
                    if (_coordinatesController.text.isEmpty) {
                      showAlert(context, 'Empty fields!');
                      return;
                    }

                    List values = _coordinatesController.text.split(',');

                    latitude = double.parse(values[0].trim());
                    longitude = double.parse(values[1].trim());

                    _searchController.value = TextEditingValue(
                      text: latitude.toString(),
                    );

                    if (_coordinatesController.text.isNotEmpty) {
                      _searchCoordiantes(
                          latitude.toString(), longitude.toString());

                      setState(() {
                        isSearching = true;
                      });
                      addSearchMarker();
                    }
                  },
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              Expanded(
                child: CustomButton(
                  text: 'Create Marker',
                  isLoading: _isLoading,
                  onClick: () {
                    searchMarkers.clear();
                    isSearching = false;

                    uploadNewMarkerData();
                  },
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          const Divider(),
          const SizedBox(
            height: 10,
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Existing Markers',
                style: GoogleFonts.poppins(
                  textStyle: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              IconButton(
                onPressed: () {
                  setState(() {
                    isDescending = !isDescending;
                  });
                },
                icon: Icon(isDescending
                    ? Icons.arrow_downward_rounded
                    : Icons.arrow_upward_rounded),
              )
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          CustomTextfield(
            title: 'Search',
            suffix: _searchController.text.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () {
                      _searchController.clear();
                      setState(() {});
                    },
                  )
                : SizedBox(),
            controller: _searchController,
            onChanged: (value) {
              setState(() {});
            },
          ),
          const SizedBox(
            height: 10,
          ),
          Builder(builder: (context) {
            return Consumer<MarkerProvider>(
              builder: (context, markerProvider, child) {
                if (markerProvider.markers != null) {
                  noDataIcon();
                }

                // Extract data from the snapshot
                final List<myClient.Marker> documents = markerProvider.markers!;

                final filteredData = documents.where((doc) {
                  final docLatitude = doc.latitude.toString();

                  final docLongitude = doc.longitude.toString();

                  final docMarketRate = doc.marketRate.toString();

                  final searchQuery = _searchController.text.toLowerCase();

                  return docLatitude.contains(searchQuery) ||
                      docMarketRate.contains(searchQuery) ||
                      docLongitude.contains(searchQuery);
                }).toList();

                if (!isDescending) {
                  filteredData
                      .sort((a, b) => a.marketRate.compareTo(b.marketRate));
                } else {
                  filteredData
                      .sort((a, b) => b.marketRate.compareTo(a.marketRate));
                }

                if (filteredData.isEmpty) {
                  return noDataIcon();
                }

                List<myClient.Marker> displayedData =
                    filteredData.take(displayLimit).toList();

                return ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: displayedData.length + 1,
                  itemBuilder: (BuildContext context, int index) {
                    if (index == displayedData.length) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: TextButton(
                          onPressed: () {
                            setState(() {
                              displayLimit += 5;
                            });
                          },
                          child: Text('View More'),
                        ),
                      );
                    } else {
                      // Display list item
                      return customMarkerTile(displayedData, index, context);
                    }
                  },
                );
              },
            );
          }),
        ],
      ),
    );
  }

  customMarkerTile(
      List<myClient.Marker> data, int index, BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            ListTile(
              title: Column(
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      InkWell(
                        onTap: () {
                          mapController.move(
                            LatLng(
                              data[index].latitude,
                              data[index].longitude,
                            ),
                            19,
                          );
                        },
                        child: Row(
                          children: [
                            Text(
                              "${data[index].latitude}°N",
                              style: const TextStyle(
                                fontSize: 15,
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Text(
                              "${data[index].longitude}°E",
                              style: const TextStyle(
                                fontSize: 15,
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Text(locationName)
                    ],
                  ),
                  data[index].marketRate == 0
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            TextButton(
                              onPressed: () {
                                addPrice(data[index].id);
                              },
                              child: const Text('Add Rate'),
                            ),
                          ],
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            const Text(
                              '₹ ',
                              style:
                                  TextStyle(color: Colors.green, fontSize: 13),
                            ),
                            Text(
                              "${data[index].marketRate}",
                              style: const TextStyle(
                                  color: Colors.green, fontSize: 18),
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            Text(
                              "/ ${data[index].unit}",
                              style: const TextStyle(
                                  color: Colors.green, fontSize: 14),
                            ),
                          ],
                        ),
                ],
              ),
            ),
            _isLoading
                ? const CircularProgressIndicator()
                : Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      // SplitButtonBar(child: , flyout: Flyout),
                      DropdownButton<String>(
                        value: data[index].color,
                        onChanged: (String? newValue) async {
                          setState(() {
                            selectedColor = newValue!;
                            _isLoading = true;
                          });
                          try {
                            await MarkerServices.updateColorInMarker(
                              id: data[index].id,
                              color: selectedColor,
                            );

                            await context.read<MarkerProvider>().loadMarkers();

                            // _marketRateController.clear();
                          } catch (e) {
                            showAlert(context, e.toString());
                          }

                          setState(() {
                            _isLoading = false;
                          });
                        },
                        items: colors
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 4.0),
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
                      const Spacer(),

                      if (context
                          .read<DatasetProvider>()
                          .datasets!
                          .any((cor) => cor.latitude == data[index].latitude))
                        TextButton(
                          child: const Text('View Dataset'),
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => DatasetPage(
                                  // Pass necessary parameters
                                  latitude: data[index].latitude,
                                  longitude: data[index]
                                      .longitude, // Set your desired longitude here
                                ),
                              ),
                            );
                          },
                        )
                      else
                        TextButton(
                          child: const Text('Create Dataset'),
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => SelectBankPage(
                                  lat: data[index].latitude,
                                  lng: data[index].longitude,
                                  dateTime: DateTime.now(),
                                  marketRate: data[index].marketRate,
                                  unit: data[index].unit,
                                ),

                                // AddDataSet(
                                //   // Pass necessary parameters
                                //   latitude: data['latitude'].toString(),
                                //   longitude: data['longitude']
                                //       .toString(), // Set your desired longitude here
                                //   dateTime: DateTime.now(),
                                //   marketRate: data['marketRate'],

                                //   unit: data['unit'], // Set your desired unit here
                                // ),
                              ),
                            );
                          },
                        ),
                      const SizedBox(width: 8),
                      TextButton(
                          onPressed: () {
                            removeExistingMarker(data[index].id);
                          },
                          child: const Text(
                            'Remove',
                            style: TextStyle(color: Colors.red),
                          )),
                      const SizedBox(width: 8),
                    ],
                  ),
          ],
        ),
      ),
    );
  }

  void addSearchMarker() {
    // double latitude = double.tryParse(_latitudeController.text) ?? 0.0;
    // double longitude = double.tryParse(_longitudeController.text) ?? 0.0;

    // Check if latitude and longitude are valid
    if (latitude != 0.0 && longitude != 0.0) {
      SearchMarker searchMarker = SearchMarker(
        latitude: latitude,
        longitude: longitude,
      );

      setState(() {
        searchMarkers.add(searchMarker);
      });
    }
  }

  _searchCoordiantes(String lat, String lng) {
    if (lat.isEmpty || lng.isEmpty) {
      showAlert(context, 'Empty fields!');
      return;
    }

    mapController.move(LatLng(double.parse(lat), double.parse(lng)), 19);

    setState(() {});
  }

  Future<void> uploadNewMarkerData() async {
    setState(() {
      _isLoading = true;
    });

    if (_coordinatesController.text.isEmpty) {
      showAlert(context, 'Empty fields!');
      return;
    }

    List<String> values = _coordinatesController.text.split(',');

    latitude = double.parse(values[0].trim());
    longitude = double.parse(values[1].trim());

    print('step 1');

    if (latitude == 0.0 || longitude == 0.0) {
      showAlert(context, 'Invalid coordinates!');
      return;
    }

    print('step 2');

    try {
      myClient.Marker marker = myClient.Marker(
        id: 0,
        latitude: latitude,
        longitude: longitude,
        marketRate: 0,
        unit: "SQM",
        color: "red",
        createdAt: DateTime.now(),
      );

      print('step 3');

      // (context)
      //     .read<MarkerProvider>()
      //     .createMarker(context: context, marker: marker);

      await MarkerServices.createMarker(context: context, marker: marker);

      print('step 4');

      await context.read<MarkerProvider>().loadMarkers();

      print('step 5');

      mapController.move(
        LatLng(
          latitude,
          longitude,
        ),
        18,
      );

      _coordinatesController.clear();
      _marketRateController.clear();
    } catch (e) {
      showAlert(context, e.toString());
      return;
    }

    setState(() {
      _isLoading = false;
    });
  }

  removeExistingMarker(int markerId) async {
    setState(() {
      _isLoading = true;
    });

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
    try {
      final marker = context.read<MarkerProvider>().markers!.firstWhere(
            (element) => element.id == markerId,
          );

      context.read<MarkerProvider>().markers!.remove(marker);

      await MarkerServices.deleteMarkers(markerId);
    } catch (e) {
      print(e);
      return;
    }
    setState(() {
      _isLoading = false;
    });
  }

  addPrice(int markerId) {
    return showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
            title: const Text(
              "Add Market Rate",
              style: TextStyle(fontSize: 16),
            ),
            content: SizedBox(
              width: 350,
              child: Row(
                children: [
                  Expanded(
                    child: CustomTextfield(
                      title: 'Market Rate (₹)',
                      controller: _marketRateController,
                      autoFocus: true,
                    ),
                  ),
                  const SizedBox(width: 10),
                  const Text('per'),
                  Padding(
                    padding: const EdgeInsets.only(left: 10, right: 10),
                    child: DropdownButton(
                      hint: Text(_selectedUnit),
                      items: const [
                        DropdownMenuItem(
                          value: 'ACRES',
                          child: Text('ACRES'),
                        ),
                        DropdownMenuItem(
                          value: 'SQFT',
                          child: Text('SQFT'),
                        ),
                        DropdownMenuItem(
                          value: 'SQM',
                          child: Text('SQM'),
                        ),
                        DropdownMenuItem(
                          value: 'BIGHA',
                          child: Text('BIGHA'),
                        ),
                      ],
                      onChanged: (value) {
                        _selectedUnit = value!;
                        setState(
                          () {},
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                child: const Text(
                  "Cancel",
                ),
                onPressed: () {
                  _marketRateController.clear();
                  Navigator.pop(context);
                },
              ),
              ElevatedButton(
                child: const Text(
                  "Ok",
                ),
                onPressed: () async {
                  updateRate(markerId);
                },
              )
            ],
          );
        });
      },
    );
  }

  void updateRate(int markerId) async {
    try {
      setState(() {
        _isLoading = true;
      });
      await MarkerServices.updateRateInMarker(
        id: markerId,
        marketRate: int.parse(_marketRateController.text.trim()),
        unit: _selectedUnit,
      );

      await context.read<MarkerProvider>().loadMarkers();

      _marketRateController.clear();
    } catch (e) {
      print(e);
    }
    setState(() {
      _isLoading = false;
    });
    Navigator.pop(context);
  }

  // void _showDuesDialog() {
  //   showDialog(
  //     context: context,
  //     builder: (context) {
  //       return AlertDialog(
  //         title: const Row(
  //           children: [
  //             Text('Dues'),
  //           ],
  //         ),
  //         content: StreamBuilder(
  //           stream:
  //               FirebaseFirestore.instance.collection('billing').snapshots(),
  //           builder: (context, snapshot) {
  //             if (snapshot.connectionState == ConnectionState.waiting) {
  //               return const Center(
  //                 child: CircularProgressIndicator(
  //                   color: CustomColors.mainColor,
  //                 ),
  //               );
  //             } else if (snapshot.hasError) {
  //               return Center(child: Text(snapshot.error.toString()));
  //             } else if (!snapshot.hasData) {
  //               return Center(
  //                 child: noDataIcon(),
  //               );
  //             }

  //             snapshot.data!.docs;

  //             return SizedBox(
  //               height: 400,
  //               width: 400,
  //               child: Column(
  //                 children: [
  //                   ListView.builder(
  //                     shrinkWrap: true,
  //                     itemCount: snapshot.data!.docs.length,
  //                     itemBuilder: (BuildContext context, int index) {
  //                       return snapshot.data!.docs[index]['isBillPaid'] == false
  //                           ? Card(
  //                               elevation: 6,
  //                               child: ListTile(
  //                                 title: Column(
  //                                   mainAxisAlignment: MainAxisAlignment.start,
  //                                   crossAxisAlignment:
  //                                       CrossAxisAlignment.start,
  //                                   children: [
  //                                     Text(
  //                                       snapshot.data!.docs[index]['partyName']
  //                                           .toString(),
  //                                       style: GoogleFonts.poppins(
  //                                         textStyle: const TextStyle(
  //                                           fontWeight: FontWeight.bold,
  //                                           fontSize: 16,
  //                                         ),
  //                                       ),
  //                                     ),
  //                                     Text(
  //                                       '(${snapshot.data!.docs[index]['partyAddress'].toString()})',
  //                                       style: GoogleFonts.poppins(
  //                                         textStyle: const TextStyle(
  //                                           fontWeight: FontWeight.bold,
  //                                           fontSize: 14,
  //                                         ),
  //                                       ),
  //                                     ),
  //                                     Text(
  //                                       snapshot.data!.docs[index]['bankName']
  //                                           .toString(),
  //                                       style: GoogleFonts.poppins(
  //                                         textStyle: const TextStyle(
  //                                           fontWeight: FontWeight.bold,
  //                                           color: Colors.red,
  //                                           fontSize: 14,
  //                                         ),
  //                                       ),
  //                                     ),
  //                                   ],
  //                                 ),
  //                                 subtitle: Text(
  //                                   'Due Date: ${DateFormat('yyyy-MM-dd').format(snapshot.data!.docs[index]['dueDate'].toDate()).toString()}',
  //                                   style: GoogleFonts.poppins(
  //                                     textStyle: const TextStyle(
  //                                       fontWeight: FontWeight.bold,
  //                                       fontSize: 13,
  //                                     ),
  //                                   ),
  //                                 ),
  //                                 trailing: Text(
  //                                   '₹${snapshot.data!.docs[index]['grossTotal']}',
  //                                   style: GoogleFonts.poppins(
  //                                     textStyle: const TextStyle(
  //                                         fontWeight: FontWeight.bold,
  //                                         fontSize: 18,
  //                                         color: Colors.green),
  //                                   ),
  //                                 ),
  //                               ),
  //                             )
  //                           : const SizedBox();
  //                     },
  //                   ),
  //                 ],
  //               ),
  //             );
  //           },
  //         ),
  //         actions: [
  //           ElevatedButton(
  //             child: const Text("Ok"),
  //             onPressed: () {
  //               setState(() {
  //                 isAdmin = false;
  //               });
  //               Navigator.of(context).pop();
  //             },
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }

  // void viewDues() {
  //   if (isAdmin == false) {
  //     _showAdminDialog();
  //   } else {
  //     _showDuesDialog();
  //   }
  // }

  // void _showAdminDialog() {
  //   showDialog(
  //     context: context,
  //     builder: (context) {
  //       return AlertDialog(
  //         title: const Text('Admin Access'),
  //         content: CustomTextfield(
  //           title: 'Phrase',
  //           controller: _passPhraseController,
  //         ),
  //         actions: [
  //           TextButton(
  //             onPressed: () {
  //               Navigator.of(context).pop();
  //             },
  //             child: const Text('Cancel'),
  //           ),
  //           ElevatedButton(
  //             child: const Text("Ok"),
  //             onPressed: () {
  //               if (_passPhraseController.text == 'AdminNavigator08') {
  //                 setState(() {
  //                   isAdmin = true;
  //                   _passPhraseController.clear();
  //                 });
  //                 Navigator.of(context).pop();
  //                 _showDuesDialog(); // Show dues dialog
  //               }
  //             },
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }
}

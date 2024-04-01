import 'package:flutter/material.dart';
import 'package:geoestate/constants/apis.dart';

import '../Models/my_marker.dart';
import '../services/marker_services.dart';

class MarkerProvider extends ChangeNotifier {
  List<Marker>? _markers;
  Exception? _connectionException;

  List<Marker>? get markers => _markers;

  void _connectionFailed(dynamic exception) {
    _markers = null;
    _connectionException = exception;
    notifyListeners();
  }

  Future<void> loadMarkers() async {
    try {
      final markers = await MarkerServices.getAllMarkers();
      _markers = markers;
      notifyListeners();
    } catch (e) {
      _connectionFailed(e);
    }
  }

  Future<void> createMarker({
    required BuildContext context,
    required Marker marker,
  }) async {
    try {
      await MarkerServices.createMarker(marker);
      await loadMarkers();
    } catch (e) {
      _connectionFailed(e);
    }
  }

  Future<void> deleteMarker(int id) async {
    try {
      await MarkerApi.deleteMarkers(id);
      await loadMarkers();
    } catch (e) {
      _connectionFailed(e);
    }
  }

  Future<void> updateRateInMarker(int id, int rate, String unit) async {
    try {
      await MarkerApi.updateRateInMarker(id, rate, unit);
      // await loadMarkers();
    } catch (e) {
      _connectionFailed(e);
    }
  }
}

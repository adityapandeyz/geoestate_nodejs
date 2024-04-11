import 'package:flutter/material.dart';
import 'package:geoestate/services/dataset_services.dart';

import '../Models/dataset.dart';

class DatasetProvider extends ChangeNotifier {
  List<Dataset>? _datasets;
  Exception? _connectionException;

  List<Dataset>? get datasets => _datasets;
  Exception? get connectionException => _connectionException;

  Future<void> loadDatasets() async {
    try {
      final datasets = await DatasetServices.getAllDatasets();
      _datasets = datasets;
      notifyListeners();
    } catch (e) {
      _connectionFailed(e);
    }
  }

  void _connectionFailed(dynamic exception) {
    _datasets = null;
    _connectionException = exception;
    notifyListeners();
  }

  // Future<void> createDataset(Dataset dataset) async {
  //   try {
  //     await DatasetApi.createDataset(dataset);
  //     await loadDatasets();
  //   } catch (e) {
  //     _connectionFailed(e);
  //   }
  // }

  // Future<void> updateDataset(Dataset datasetToUpdate) async {
  //   try {
  //     // await client.datasets.updateDataset(datasetToUpdate);

  //     // await loadDatasets();
  //   } catch (e) {
  //     _connectionFailed(e);
  //   }
  // }

  // Future<void> deleteDataset(Dataset dataset) async {
  //   try {
  //     // await client.datasets.deleteDataset(dataset);
  //     // await loadDatasets();
  //   } catch (e) {
  //     _connectionFailed(e);
  //   }
  // }
}

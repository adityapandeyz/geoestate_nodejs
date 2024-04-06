import 'package:flutter/material.dart';
import 'package:geoestate/constants/apis.dart';
import 'package:geoestate/services/bank_services.dart';

import '../Models/bank.dart';

class BankProvider extends ChangeNotifier {
  List<Bank>? _banks;
  Exception? _connectionException;

  List<Bank>? get banks => _banks;
  Exception? get connectionException => _connectionException;

  Future<void> loadBanks() async {
    try {
      final banks = await BankServices.getAllBanks();
      _banks = banks;
      notifyListeners();
    } catch (e) {
      _connectionFailed(e);
    }
  }

  void _connectionFailed(dynamic exception) {
    _banks = null;
    _connectionException = exception;
    notifyListeners();
  }

  // Future<void> createBank(Bank bank) async {
  //   try {
  //     await BankApi.createBank(bank);
  //     await loadBanks();
  //   } catch (e) {
  //     _connectionFailed(e);
  //   }
  // }

  // Future<void> deleteBank(int id) async {
  //   try {
  //     await BankApi.deleteBank(id);
  //     // await loadBanks();
  //   } catch (e) {
  //     _connectionFailed(e);
  //   }
  // }
}

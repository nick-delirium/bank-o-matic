import 'mock_denominations.dart';
import 'dart:async';

class DenominationsService {
  List<int> denoms;
  
  Future<List> getAll() async => mockDenominations;
  Future<List> get() async => denoms = mockDenominations;
  Future<List> getDenominations() async {
    if (denoms == null) denoms = mockDenominations;
    return denoms;
  }

  void saveDenoms(List<int> array) => denoms = array;
}
import 'mock_denominations.dart';
import 'dart:async';

class DenominationsService {
  List<int> denoms;
  
  Future<List> getAll() async => mockDenominations;

  void saveDenoms(List<int> array) => denoms = array;
}
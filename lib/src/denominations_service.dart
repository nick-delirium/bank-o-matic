import 'mock_denominations.dart';
import 'dart:async';

class DenominationsService {
  Future<List> getDenominations() async => mockDenominations;
}
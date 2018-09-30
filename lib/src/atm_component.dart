import 'dart:async';
import 'denominations_service.dart';
import 'package:angular/angular.dart';
import 'package:angular_forms/angular_forms.dart';

@Component(
  selector: 'atm',
  templateUrl: 'atm_component.html',
  directives: [coreDirectives, formDirectives]
)

class AtmComponent implements OnInit {
  final DenominationsService _denominationsService;
  List denominations;
  Map output;
  String givenNum;
  AtmComponent(this._denominationsService);

  Future<void> _getDenomArray() async {
    denominations = await _denominationsService.getDenominations();
  }
  void ngOnInit() => _getDenomArray();
  void onGiveCash() => output = calculateAndGive(int.parse(givenNum), denominations);
  void onGiveCashFix() => output = calculateFixed(int.parse(givenNum), denominations);
  void onSetDenominations() => null;


  Map calculateAndGive(int given, List<int> denoms) {
    int start = given;
    Map<int, int> used = {};
    for (var key in denoms) {
      used[key] = 0;
    }

    int i = used.length - 1;
    while (start > 0 && i > 0) {
      if (start - denoms[i] >= 0) {
        while(start/denoms[i] > 1) {
          start = start - denoms[i];
          used[denoms[i]] += 1;
        }
        if ((start / denoms[i] == 1 && denoms[i] == denoms[0])|| denoms[i] == start / denoms[i-1]) {
          start = start - denoms[i];
          used[denoms[i]] += 1;
        }
        if (i != 1) i -= 1;
      } else i -= 1;
      if (i < 0) return null;
    }
    return used;
  }

  Map calculateFixed(int given, List<int> denoms) {
    int start = given;
    Map<int, int> used = {};
    for (var key in denoms) {
      used[key] = 0;
    }

    int i = used.length - 1;
    while (start > 0 && i > 0) {
      if (start - denoms[i] >= 0) {
        double delimeter = start/denoms[i];
        while(delimeter > 1) {
          start = start - denoms[i];
          used[denoms[i]] += 1;
        }
        if (start / denoms[i] == 1 && denoms[i] == denoms[0]) {
          start = start - denoms[i];
          used[denoms[i]] += 1;
        }
        if (i != 1) i -= 1;
      } else i -= 1;
      if (i < 0) return null;
    }
    return used;
  }
}
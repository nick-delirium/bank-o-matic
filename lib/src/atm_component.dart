import 'dart:async';
import 'dart:math';
import 'package:angular/angular.dart';
import 'package:angular_forms/angular_forms.dart';
import 'denominations_service.dart';
import 'custom_exception.dart';

@Component(
  selector: 'atm-comp',
  templateUrl: 'atm_component.html',
  directives: [coreDirectives, formDirectives],
  providers: [ClassProvider(DenominationsService)],
)

class AtmComponent implements OnInit {
  final DenominationsService _denominationsService;
  List denominations;
  Map output;
  String errorText;
  String givenNum;
  AtmComponent(this._denominationsService);
  
  @Input()
  List<int> denoms;

  Future<void> _getAllDenoms() async {
    denominations = await _denominationsService.getAll();
  }
  
  void ngOnInit() => _getAllDenoms();
  
  void onGiveCash() { 
    try {
      output = calculateToLowest(int.parse(givenNum), denoms);
    } on UnreachebleNumberExc {
      output = null;
      errorText = 'Error: cant give this number with such a denoms: $denominations';
    }
  }
  void onGiveCashFix() {
    try{
      output = calculateFixed(int.parse(givenNum), denominations);
    } on UnreachebleNumberExc {
      output = null;
      errorText = 'Error: cant give this number with such a denoms: $denominations';
    }
  }
  void onSetDenominations() => null;

 // [2, 5, 10, 50] => 20
  Map calculateFixed(int given, List<int> denoms) {
    int start = given;
    bool lastEl = false;
    Map<int, int> used = {};
    for (var key in denoms) {
      used[key] = 0;
    }

    int i = used.length - 1;
    while (start > 0 && i >= 0) {
      if (start - denoms[i] >= 0) {
        double delimeter = start/denoms[i];
        while(delimeter > 1) {
          start = start - denoms[i];
          used[denoms[i]] += 1;
          delimeter = start/denoms[i];
        }
        print(i);
        if ((start / denoms[i] == 1 && denoms[i] == denoms[0]) || denoms[i] == start / denoms[i-1] || restUnavailable(denoms, i, start)) {
          start = start - denoms[i];
          used[denoms[i]] += 1;
          lastEl = true;
        }
        if (!lastEl && i > 0) i -= 1; // here must be if (denoms[i]) impl on dart but I found that (denoms[i] is int) not working
        if (start == 0) return used;
      } else i -= 1;
      if (i < 0 || start < denoms.reduce(min)) throw new UnreachebleNumberExc('Cant give this sum');
    }
    return used;
  }
  // 16 => 10, 5 остается 1 и ошибка
  Map calculateToLowest(int given, List<int> denoms) {
    int start = given;
    bool lastEl = false;
    Map<int, int> used = {};
    for (var key in denoms) {
      used[key] = 0;
    }

    int i = used.length - 1;
    while (start > 0 && i >= 0) {
      if (start - denoms[i] >= 0) {
        int delimeter = (start ~/denoms[i]);
        while(delimeter > 1) {
          start = start - denoms[i];
          used[denoms[i]] += 1;
          delimeter = (start ~/ denoms[i]);
        }
        if (start / denoms[i] == 1 && denoms[i] == denoms[0] || restUnavailable(denoms, i, start)) {
          start = start - denoms[i];
          used[denoms[i]] += 1;
          lastEl = true;
        }
        if (!lastEl && i > 0) i -= 1; // here must be if (denoms[i]) impl on dart but I found that (denoms[i] is int) not working
        if (start == 0) return used;
      } else i -= 1;
      if (i < 0 || start < denoms.reduce(min)) throw new UnreachebleNumberExc('Cant give this sum');
    }
    return used;
  }


  bool restUnavailable(List<int> arr, int pointer, int sum) {
    bool status = false;

    if (pointer == 1) if (sum % arr[0] != 0) return true;
    else { 
      arr.sublist(0, pointer-1).forEach((el) {
        if (sum % el != 0) status = true;
      });
    }

    return status;
  }
  
}
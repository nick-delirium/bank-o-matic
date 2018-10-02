import 'dart:math';
import 'package:angular/angular.dart';
import 'package:angular_forms/angular_forms.dart';
import 'denominations_service.dart';

@Component(
  selector: 'atm-comp',
  templateUrl: 'atm_component.html',
  directives: [coreDirectives, formDirectives],
  providers: [ClassProvider(DenominationsService)],
)

class AtmComponent {
  List denominations;
  Map output;
  String outputText = 'Result:';
  String errorText;
  String givenNum;
  String givenDenoms;
  String usedDenoms;
  @Input()
  List<int> denoms;

  
  void onGiveCash() { 
    try {
      outputText = 'Result: ';
      usedDenoms = null;
      errorText = null;
      output = calculateToLowest(int.parse(givenNum), denoms);
      givenDenoms = denoms.join(', ');
      for (var key in denoms) {
        outputText = outputText + '${key}x${output[key]}; ';
      }
    } catch(e) {
      output = null;
      errorText = 'ERROR: $e';
    }
    finally {
      usedDenoms =  'used denominals: $denoms';
    }
  }

  Map calculateToLowest(int given, List<int> denoms) {
    if (given < 0) throw new FormatException('Cant give negative sum');
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
      if (i < 0 || start < denoms.reduce(min)) throw new FormatException('Cant give this sum');
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


// this can work better in some situations
//  // [1, 5, 10, 50] => 20 => 10, 5, 1,1,1,1,1; BUT 21 => 10, 10, 1.
//   Map calculateFixed(int given, List<int> denoms) {
//     int start = given;
//     bool lastEl = false;
//     Map<int, int> used = {};
//     for (var key in denoms) {
//       used[key] = 0;
//     }

//     int i = used.length - 1;
//     while (start > 0 && i >= 0) {
//       if (start - denoms[i] >= 0) {
//         double delimeter = start/denoms[i];
//         while(delimeter > 1) {
//           start = start - denoms[i];
//           used[denoms[i]] += 1;
//           delimeter = start/denoms[i];
//         }
//         print(i);
//         if ((start / denoms[i] == 1 && denoms[i] == denoms[0]) || denoms[i] == start / denoms[i-1] || restUnavailable(denoms, i, start)) {
//           start = start - denoms[i];
//           used[denoms[i]] += 1;
//           lastEl = true;
//         }
//         if (!lastEl && i > 0) i -= 1; // here must be if (denoms[i]) impl on dart but I found that (denoms[i] is int) not working
//         if (start == 0) return used;
//       } else i -= 1;
//       if (i < 0 || start < denoms.reduce(min)) throw new UnreachebleNumberExc('Cant give this sum');
//     }
//     return used;
//   }
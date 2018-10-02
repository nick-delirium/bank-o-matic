import 'dart:async';
import 'package:angular/angular.dart';
import 'package:angular_forms/angular_forms.dart';

import 'denominations_service.dart';

@Component(
  selector: 'edit-denoms',
  templateUrl: 'edit_denoms_component.html',
  directives: [coreDirectives, formDirectives]
)

class EditDenomsComponent implements OnInit {
  final DenominationsService _denominationsSerice;
  List denominations;
  String denominationsStr;

  @Input()
  List<int> denoms;
  String error;
  EditDenomsComponent(this._denominationsSerice);

  final _open = StreamController<List<int>>();

  @Output()
  Stream get changeDenoms => _open.stream;
  void change() => _open.add(denoms);

  Future<void> _getDenomArray() async {
    denominations = await _denominationsSerice.getAll();
    denominationsStr = denominations.join(', ');
  }
  List<int> saveArray() {
    error = null;
    if (denominationsStr.contains('-') 
        || denominationsStr.contains(new RegExp(r'[A-Za-z]')) ) {
      error = "Incorrent values given";
      return [0,0,0];
    }
    List<int> array = denominationsStr.split(',').map((i) => int.parse(i)).toList();
    return array;
  }
  void ngOnInit() => _getDenomArray();
  void save() { 
    denoms = saveArray();
    change();
  }
}
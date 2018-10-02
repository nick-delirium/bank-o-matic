import 'dart:async';
import 'package:angular/angular.dart';


import 'src/atm_component.dart';
import 'src/edit_denoms_component.dart';
import 'src/denominations_service.dart';

@Component(
  selector: 'my-app',
  styleUrls: ['app_component.css'],
  templateUrl: 'app_component.html',
  directives: [coreDirectives, AtmComponent, EditDenomsComponent],
  providers: [ClassProvider(DenominationsService)]
)
class AppComponent implements OnInit {
  bool editing = false;
  List<int> denoms;

  final DenominationsService _denominationsService;
  AppComponent(this._denominationsService);

  Future<void> getAllDenoms() async => denoms = await _denominationsService.getAll();

  void ngOnInit() => getAllDenoms();

  void editDenoms() => editing = !editing;
  // Nothing here yet. All logic is in TodoListComponent.
}

import 'package:angular/angular.dart';
import 'src/atm_component.dart';
import 'src/denominations_service.dart';

@Component(
  selector: 'my-app',
  styleUrls: ['app_component.css'],
  templateUrl: 'app_component.html',
  directives: [coreDirectives, AtmComponent],
  providers: [ClassProvider(DenominationsService)]
)
class AppComponent {
  // Nothing here yet. All logic is in TodoListComponent.
}

@TestOn('browser')
import 'package:angular_test/angular_test.dart';
import 'package:test/test.dart';
import 'package:bank_o_matic/app_component.dart';
import 'package:bank_o_matic/app_component.template.dart' as ng;
import 'package:bank_o_matic/src/atm_component.dart';
import 'package:bank_o_matic/src/edit_denoms_component.dart';
import 'package:bank_o_matic/src/denominations_service.dart';
import 'package:bank_o_matic/src/mock_denominations.dart';

void main() {
  final testBed =
      NgTestBed.forComponent<AppComponent>(ng.AppComponentNgFactory);
  NgTestFixture<AppComponent> fixture;

  setUp(() async {
    fixture = await testBed.create();
  });

  tearDown(disposeAnyRunningTest);

  test('page rendering test', () {
    expect(fixture.text, contains('ATM algorythm'));
  });
  test('algo testing: 20 => 1x5, 5x1, 10x1', () {
    AtmComponent component = new AtmComponent();
    expect(component.calculateToLowest(20, [1, 5, 10]), equals( {1: 5, 5: 1, 10: 1} ));
  });
  test('denominals getting test', () async {
    DenominationsService component = new DenominationsService();
    List<int> resut = await component.getAll();
    expect(resut, equals( mockDenominations ));
  });

  test('denominals editing test', () async {
    EditDenomsComponent component = new EditDenomsComponent(null);
    List<int> result = await component.saveArray('1, 5, 10');
    expect(result, equals( [1, 5, 10] ));
  });
  // Testing info: https://webdev.dartlang.org/angular/guide/testing
}

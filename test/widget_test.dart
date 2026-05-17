import 'package:flutter_test/flutter_test.dart';
import 'package:panier_de_saison/app.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  testWidgets('App starts', (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({});
    await tester.pumpWidget(const PanierDeSaisonApp());
    await tester.pumpAndSettle();
    expect(find.text('Panier de Saison'), findsWidgets);
  });
}

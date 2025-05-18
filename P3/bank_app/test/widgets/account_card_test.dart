import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bank_app/models/account.dart';
import 'package:bank_app/widgets/account_card.dart';

void main() {
  testWidgets('AccountCard muestra correctamente ID y saldo', (
    WidgetTester tester,
  ) async {
    // Crear una cuenta de prueba
    final account = Account('TEST123');
    account.deposit(150.0);
    bool tapCalled = false;

    // Construir nuestro widget y desencadenar un frame
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: AccountCard(
            account: account,
            onTap: () {
              tapCalled = true;
            },
          ),
        ),
      ),
    );

    // Verificar que el ID de la cuenta se muestra
    expect(find.text('Cuenta: TEST123'), findsOneWidget);

    // Verificar que el saldo se muestra correctamente
    expect(find.text('Saldo: \$150.00'), findsOneWidget);

    // Simular un tap en la tarjeta
    await tester.tap(find.byType(InkWell));
    await tester.pump();

    // Verificar que se llamó al callback
    expect(tapCalled, true);
  });
}

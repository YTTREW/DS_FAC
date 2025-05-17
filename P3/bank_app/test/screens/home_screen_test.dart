import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bank_app/screens/home_screen.dart';
import 'package:bank_app/services/bank_service.dart';

void main() {
  testWidgets('HomeScreen muestra mensaje cuando no hay cuentas', (
    WidgetTester tester,
  ) async {
    // Crear el servicio bancario
    final bankService = BankService();

    // Construir nuestra pantalla y desencadenar un frame
    await tester.pumpWidget(
      MaterialApp(home: HomeScreen(bankService: bankService)),
    );

    // Verificar que muestra el mensaje de "no hay cuentas"
    expect(
      find.text('No tienes cuentas. Crea una para empezar.'),
      findsOneWidget,
    );

    // Verificar que el botón flotante existe
    expect(find.byType(FloatingActionButton), findsOneWidget);
  });
}

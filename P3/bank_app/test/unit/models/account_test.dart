import 'package:bank_app/models/account.dart';
import 'package:flutter_test/flutter_test.dart';

/// Tests unitarios para la clase [Account].
///
/// Este archivo contiene las pruebas que verifican el comportamiento
/// del modelo de cuenta bancaria, incluyendo su inicialización y
/// validaciones para operaciones de depósito y retiro.
void main() {
  /// Grupo de pruebas que verifica el comportamiento básico de la clase [Account].
  group('Account', () {
    /// Verifica que una cuenta recién creada tenga un saldo inicial de cero.
    ///
    /// Este test asegura que cuando se instancia una nueva cuenta,
    /// su saldo disponible sea exactamente 0.0.
    test('El balance inicial de una cuenta debe ser cero', () {
      final account = Account('TEST1');
      expect(account.saldoCuenta, 0.0);
    });

    /// Verifica que no se puedan hacer depósitos con valores inválidos.
    ///
    /// Este test comprueba que el método [deposit] lance un [ArgumentError]
    /// cuando se intenta depositar:
    /// - Una cantidad igual a cero
    /// - Una cantidad negativa
    test('No se permite depositar cantidades negativas o cero', () {
      final account = Account('TEST2');
      expect(() => account.deposit(0), throwsArgumentError);
      expect(() => account.deposit(-10), throwsArgumentError);
    });

    /// Verifica que no se puedan hacer retiros con valores inválidos.
    ///
    /// Este test comprueba que el método [withdraw] lance un [ArgumentError]
    /// cuando se intenta retirar:
    /// - Una cantidad igual a cero
    /// - Una cantidad negativa
    test('No se permite retirar cantidades negativas o cero', () {
      final account = Account('TEST3');
      expect(() => account.withdraw(0), throwsArgumentError);
      expect(() => account.withdraw(-5), throwsArgumentError);
    });
  });
}

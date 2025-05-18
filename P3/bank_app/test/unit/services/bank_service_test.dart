import 'package:bank_app/services/bank_service.dart';
import 'package:flutter_test/flutter_test.dart';

/// Tests unitarios para la clase [BankService].
///
/// Este archivo contiene las pruebas que verifican el comportamiento
/// del servicio bancario, incluyendo la creación de cuentas,
/// operaciones financieras y gestión de transacciones.
void main() {
  /// Grupo de pruebas que verifica el comportamiento del servicio bancario.
  group('BankService', () {
    /// Verifica que un servicio bancario recién creado no tenga cuentas.
    ///
    /// Este test asegura que la lista de cuentas esté vacía al inicializar
    /// un nuevo [BankService].
    test('La lista inicial de cuentas está vacía', () {
      final bank = BankService();
      expect(bank.listAccounts(), isEmpty);
    });

    /// Verifica que el método deposit aumente correctamente el saldo de una cuenta.
    ///
    /// Este test comprueba que al realizar un depósito en una cuenta,
    /// el saldo se actualice con la cantidad especificada.
    test('deposit aumenta el saldo de la cuenta', () {
      final bank = BankService();
      final acc = bank.createAccount();
      bank.deposit(acc.accountId, 100);
      expect(acc.saldoCuenta, 100);
    });

    /// Verifica que el método withdraw lance error cuando no hay saldo suficiente.
    ///
    /// Este test comprueba que al intentar retirar de una cuenta sin fondos,
    /// se lance un [StateError] apropiadamente.
    test('withdraw lanza StateError cuando el saldo es insuficiente', () {
      final bank = BankService();
      final acc = bank.createAccount();
      expect(() => bank.withdraw(acc.accountId, 50), throwsStateError);
    });

    /// Verifica que la transferencia entre cuentas funcione correctamente.
    ///
    /// Este test comprueba que:
    /// - El saldo de la cuenta origen se reduzca por la cantidad transferida
    /// - El saldo de la cuenta destino aumente por la cantidad transferida
    test('transfer mueve fondos correctamente', () {
      final bank = BankService();
      final a1 = bank.createAccount();
      final a2 = bank.createAccount();
      bank.deposit(a1.accountId, 200);
      bank.transfer(a1.accountId, a2.accountId, 100);
      expect(a1.saldoCuenta, 100);
      expect(a2.saldoCuenta, 100);
    });

    /// Verifica que la transferencia falle cuando la cuenta origen no tiene fondos.
    ///
    /// Este test comprueba que al intentar transferir desde una cuenta sin saldo suficiente,
    /// se lance un [StateError] apropiadamente.
    test('transfer lanza StateError cuando los fondos son insuficientes', () {
      final bank = BankService();
      final a1 = bank.createAccount();
      final a2 = bank.createAccount();
      expect(
        () => bank.transfer(a1.accountId, a2.accountId, 100),
        throwsStateError,
      );
    });

    /// Verifica que los identificadores de transacción sean únicos.
    ///
    /// Este test comprueba que cada transacción reciba un ID único
    /// al ser procesada por el servicio bancario.
    test('txId genera identificadores únicos', () {
      final bank = BankService();
      final acc = bank.createAccount();

      bank.deposit(acc.accountId, 100);
      bank.withdraw(acc.accountId, 50);

      final listaTransacciones = bank.listTransactions();

      expect(listaTransacciones.length, 2);
      expect(
        listaTransacciones[0].transactionId,
        isNot(equals(listaTransacciones[1].transactionId)),
      );
    });
  });
}

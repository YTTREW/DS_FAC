import 'package:bank_app/models/account.dart';
import 'package:bank_app/models/transactions/deposit_transaction.dart';
import 'package:bank_app/models/transactions/transfer_transaction.dart';
import 'package:bank_app/models/transactions/withdrawal_transaction.dart';
import 'package:flutter_test/flutter_test.dart';

/// Tests unitarios para las clases de transacciones.
///
/// Este archivo contiene las pruebas que verifican el comportamiento
/// de las diferentes implementaciones de transacciones bancarias:
/// [DepositTransaction], [WithdrawalTransaction] y [TransferTransaction].
void main() {
  /// Grupo de pruebas que verifica el comportamiento de las transacciones bancarias.
  group('Transaction', () {
    /// Verifica que una transacción de depósito aumente correctamente el saldo.
    ///
    /// Este test comprueba que el método [apply] de [DepositTransaction]
    /// incremente el saldo de la cuenta con el monto especificado.
    test('DepositTransaction.apply aumenta el saldo correctamente', () {
      final account = Account('T1');
      final tr1 = DepositTransaction('TR1', 100.0);
      tr1.apply(account);
      expect(account.saldoCuenta, 100.0);
    });

    /// Verifica que una transacción de retiro falle apropiadamente cuando no hay fondos.
    ///
    /// Este test comprueba que el método [apply] de [WithdrawalTransaction]
    /// lance un [StateError] cuando se intenta retirar de una cuenta sin saldo suficiente.
    test(
      'WithdrawalTransaction.apply lanza StateError cuando no hay fondos suficientes',
      () {
        final account = Account('T2');
        final tr2 = WithdrawalTransaction('TR2', 50.0);
        expect(() => tr2.apply(account), throwsStateError);
      },
    );

    /// Verifica que una transacción de transferencia mueva correctamente los fondos.
    ///
    /// Este test comprueba que el método [apply] de [TransferTransaction]:
    /// - Reduzca el saldo de la cuenta origen
    /// - Incremente el saldo de la cuenta destino
    /// - Los montos estén correctamente ajustados en ambas cuentas
    test(
      'TransferTransaction.apply mueve fondos entre cuentas de forma correcta',
      () {
        final cuentaOrigen = Account('T3');
        cuentaOrigen.deposit(200);
        final cuentaDestino = Account('Destino');
        final tr = TransferTransaction('TR3', 150.0, cuentaDestino);
        tr.apply(cuentaOrigen);
        expect(cuentaOrigen.saldoCuenta, 50.0);
        expect(cuentaDestino.saldoCuenta, 150.0);
      },
    );
  });
}

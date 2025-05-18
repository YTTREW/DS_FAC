import 'package:bank_app/models/account.dart';
import 'transaction.dart';

/// Representa una transacción de depósito en una cuenta bancaria.
///
/// Esta clase extiende de [Transaction] y especifica el comportamiento
/// para depositar dinero en una cuenta. Cuando se aplica esta transacción,
/// se incrementa el saldo de la cuenta por la cantidad especificada.
///
/// Ejemplo:
/// ```dart
/// final deposit = DepositTransaction('DEP123', 100.0);
/// deposit.apply(account); // Incrementa el saldo de la cuenta en 100.0
/// ```
class DepositTransaction extends Transaction {
  /// Crea una nueva transacción de depósito.
  ///
  /// Parámetros:
  ///   [transactionId] - El identificador único para esta transacción.
  ///   [amount] - La cantidad a depositar. Debe ser un valor positivo.
  DepositTransaction(super.transactionId, super.amount);

  /// Aplica esta transacción de depósito a la cuenta especificada.
  ///
  /// Llama al método [deposit] de la cuenta con la cantidad
  /// asociada a esta transacción.
  ///
  /// Parámetros:
  ///   [account] - La cuenta en la que se depositará el dinero.
  @override
  void apply(Account account) {
    account.deposit(amount);
  }
}

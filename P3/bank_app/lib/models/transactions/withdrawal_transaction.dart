import 'package:bank_app/models/account.dart';
import 'transaction.dart';

/// Representa una transacción de retiro de una cuenta bancaria.
///
/// Esta clase extiende de [Transaction] y especifica el comportamiento
/// para retirar dinero de una cuenta. Cuando se aplica esta transacción,
/// se reduce el saldo de la cuenta por la cantidad especificada.
///
/// Ejemplo:
/// ```dart
/// final withdrawal = WithdrawalTransaction('WIT123', 50.0);
/// withdrawal.apply(account); // Reduce el saldo de la cuenta en 50.0
/// ```
class WithdrawalTransaction extends Transaction {
  /// Crea una nueva transacción de retiro.
  ///
  /// Parámetros:
  ///   [id] - El identificador único para esta transacción.
  ///   [amount] - La cantidad a retirar. Debe ser un valor positivo.
  WithdrawalTransaction(super.id, super.amount);

  /// Aplica esta transacción de retiro a la cuenta especificada.
  ///
  /// Llama al método [withdraw] de la cuenta con la cantidad
  /// asociada a esta transacción.
  ///
  /// Parámetros:
  ///   [account] - La cuenta de la que se retirará el dinero.
  ///
  /// Puede lanzar [StateError] si la cuenta no tiene saldo suficiente.
  @override
  void apply(Account account) {
    account.withdraw(amount);
  }
}

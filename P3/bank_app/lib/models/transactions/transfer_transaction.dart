import 'package:bank_app/models/account.dart';
import 'transaction.dart';

/// Representa una transacción de transferencia entre dos cuentas bancarias.
///
/// Esta clase extiende de [Transaction] y especifica el comportamiento
/// para transferir dinero desde una cuenta (origen) a otra cuenta (destino).
/// Cuando se aplica esta transacción, se retira dinero de la cuenta origen
/// y se deposita la misma cantidad en la cuenta destino.
///
/// Ejemplo:
/// ```dart
/// final destinationAccount = Account('AC789012');
/// final transfer = TransferTransaction('TRF123', 75.0, destinationAccount);
/// transfer.apply(sourceAccount); // Transfiere 75.0 de sourceAccount a destinationAccount
/// ```
class TransferTransaction extends Transaction {
  /// La cuenta de destino donde se depositará el dinero.
  ///
  /// Este objeto [Account] recibe el monto transferido cuando
  /// se ejecuta la transacción.
  final Account toAccount;

  /// Crea una nueva transacción de transferencia.
  ///
  /// Parámetros:
  ///   [id] - El identificador único para esta transacción.
  ///   [amount] - La cantidad a transferir. Debe ser un valor positivo.
  ///   [toAccount] - La cuenta de destino que recibirá el dinero.
  TransferTransaction(super.id, super.amount, this.toAccount);

  /// Aplica esta transacción de transferencia entre las cuentas especificadas.
  ///
  /// Retira [amount] de la cuenta [fromAccount] y deposita la misma cantidad
  /// en la cuenta [toAccount] definida durante la creación de esta transacción.
  ///
  /// Parámetros:
  ///   [fromAccount] - La cuenta origen de la que se retirará el dinero.
  ///
  /// Puede lanzar:
  ///   [StateError] si la cuenta origen no tiene saldo suficiente.
  @override
  void apply(Account fromAccount) {
    fromAccount.withdraw(amount);
    toAccount.deposit(amount);
  }
}

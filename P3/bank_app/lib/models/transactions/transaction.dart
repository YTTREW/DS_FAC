import 'package:bank_app/models/account.dart';

/// Clase abstracta que representa una transacción bancaria.
///
/// Define la estructura base para todos los tipos de transacciones
/// que se pueden realizar sobre una cuenta, como depósitos,
/// retiros y transferencias.
///
/// Cada transacción tiene un identificador único y una cantidad asociada,
/// y debe implementar un método [apply] que define cómo se ejecuta
/// la transacción sobre una [Account] específica.
abstract class Transaction {
  /// Identificador único de la transacción.
  ///
  /// Este valor se establece durante la creación de la transacción
  /// y no puede modificarse posteriormente.
  final String transactionId;

  /// Cantidad monetaria asociada a la transacción.
  ///
  /// Este valor debe ser positivo y representa el monto
  /// involucrado en la operación.
  final double amount;

  /// Crea una nueva instancia de [Transaction].
  ///
  /// Parámetros:
  ///   [transactionId] - El identificador único para esta transacción.
  ///   [amount] - La cantidad monetaria de la transacción. Debe ser positiva.
  ///
  /// Lanza:
  ///   [ArgumentError] si el monto es menor o igual a cero.
  Transaction(this.transactionId, this.amount) {
    if (amount <= 0) {
      throw ArgumentError('La cantidad debe ser positivo.');
    }
  }

  /// Aplica la transacción a una cuenta específica.
  ///
  /// Este método debe ser implementado por las clases derivadas para
  /// definir el comportamiento específico de cada tipo de transacción.
  ///
  /// Parámetros:
  ///   [account] - La cuenta sobre la que se aplicará la transacción.
  void apply(Account account);
}

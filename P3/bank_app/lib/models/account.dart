/// Representa una cuenta bancaria en el sistema.
///
/// La clase [Account] encapsula la información y el comportamiento de una cuenta bancaria,
/// incluyendo su identificador único y saldo, así como las operaciones que se pueden
/// realizar sobre ella, como depósitos y retiros.
class Account {
  /// El identificador único de la cuenta bancaria.
  ///
  /// Este valor se establece durante la creación de la cuenta
  /// y no puede ser modificado posteriormente.
  final String accountId;

  /// El saldo actual de la cuenta, inicializado en 0.
  ///
  /// Este campo es privado y solo debe modificarse a través
  /// de los métodos [deposit] y [withdraw].
  double _saldoCuenta = 0.0;

  /// Crea una nueva instancia de [Account] con el identificador especificado.
  ///
  /// Parámetros:
  ///   [accountId] - El identificador único para esta cuenta.
  Account(this.accountId);

  /// Obtiene el saldo actual de la cuenta.
  ///
  /// Este valor de solo lectura refleja el saldo disponible
  /// después de todas las transacciones realizadas.
  ///
  /// Retorna:
  ///   El saldo actual de la cuenta.
  double get saldoCuenta => _saldoCuenta;

  /// Deposita la cantidad especificada en la cuenta.
  ///
  /// Incrementa el saldo de la cuenta por el [amount] especificado.
  ///
  /// Parámetros:
  ///   [amount] - La cantidad a depositar. Debe ser un valor positivo.
  ///
  /// Lanza:
  ///   [ArgumentError] si el monto es menor o igual a cero.
  ///
  /// Ejemplo:
  ///   ```dart
  ///   account.deposit(100.0); // Incrementa el saldo en 100
  ///   ```
  void deposit(double amount) {
    if (amount <= 0) {
      throw ArgumentError('La cantidad de dinero debe ser mayor que cero');
    }
    _saldoCuenta += amount;
  }

  /// Retira la cantidad especificada de la cuenta.
  ///
  /// Decrementa el saldo de la cuenta por el [amount] especificado.
  ///
  /// Parámetros:
  ///   [amount] - La cantidad a retirar. Debe ser un valor positivo.
  ///
  /// Lanza:
  ///   [ArgumentError] si el monto es menor o igual a cero.
  ///   [StateError] si el saldo de la cuenta es insuficiente para la operación.
  ///
  /// Ejemplo:
  ///   ```dart
  ///   account.withdraw(50.0); // Reduce el saldo en 50
  ///   ```
  void withdraw(double amount) {
    if (amount <= 0) {
      throw ArgumentError('La cantidad a retirar debe ser mayor que cero');
    }
    if (amount > _saldoCuenta) {
      throw StateError('Saldo insuficiente');
    }
    _saldoCuenta -= amount;
  }

  /// Proporciona una representación en cadena de texto de la cuenta.
  ///
  /// Sobreescribe el método [toString] para mostrar el número de cuenta
  /// y el saldo actual en un formato legible.
  ///
  /// Retorna:
  ///   Una cadena con el formato 'Numero de Cuenta: [accountId] - Saldo: [saldoCuenta]'
  @override
  String toString() {
    return 'Numero de Cuenta: $accountId - Saldo: $saldoCuenta';
  }
}

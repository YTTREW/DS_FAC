class Account {
    final String accountId; // Id de la cuenta
    double _saldoCuenta = 0.0; // Cantidad de dinero en la cuenta

    // Constructor de la clase
    Account(this.accountId);

    // Método para obtener el saldo de la cuenta
    double get saldoCuenta => _saldoCuenta;

    // Método para obtener depositar dinero en la cuenta
    void deposit(double amount) {
        if (amount <= 0) {
        throw ArgumentError('La cantidad de dinero debe ser mayor que cero');
        }
        _saldoCuenta += amount;
    }

    // Método para retirar dinero de la cuenta
    void withdraw(double amount) {
        if (amount <= 0) {
        throw ArgumentError('La cantidad a retirar debe ser mayor que cero');
        }
        if (amount > _saldoCuenta) {
        throw StateError('Saldo insuficiente');
        }
        _saldoCuenta -= amount;
    }

    // Sobreescritura del método toString para mostrar info de la cuenta
    @override
    String toString() {
        return 'Numero de Cuenta: $accountId - Saldo: $saldoCuenta';
    }
}
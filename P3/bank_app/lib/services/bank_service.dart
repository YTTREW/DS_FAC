import 'package:bank_app/models/account.dart';
import 'package:bank_app/models/transactions/deposit_transaction.dart';
import 'package:bank_app/models/transactions/transaction.dart';
import 'package:bank_app/models/transactions/transfer_transaction.dart';
import 'package:bank_app/models/transactions/withdrawal_transaction.dart';

/// Servicio principal para gestionar operaciones bancarias.
///
/// Esta clase proporciona funcionalidades para crear y administrar cuentas bancarias,
/// así como realizar diferentes tipos de transacciones entre ellas (depósitos, retiros
/// y transferencias). También mantiene un historial de todas las transacciones realizadas.
///
/// Ejemplo de uso:
/// ```dart
/// final bank = BankService();
/// final account1 = bank.createAccount();
/// final account2 = bank.createAccount();
///
/// bank.deposit(account1.accountId, 100.0);
/// bank.transfer(account1.accountId, account2.accountId, 50.0);
/// ```
class BankService {
  /// Mapa interno de cuentas bancarias.
  ///
  /// La clave es el ID de la cuenta y el valor es la instancia de [Account].
  final Map<String, Account> _accounts = {};

  /// Contador para generar números de cuenta únicos.
  ///
  /// Se incrementa cada vez que se crea una nueva cuenta.
  int _nextAccountNumber = 100;

  /// Contador para generar IDs de transacción únicos.
  ///
  /// Se incrementa cada vez que se crea una nueva transacción.
  int _nextTransactionId = 1;

  /// Historial de todas las transacciones realizadas en el banco.
  final List<Transaction> _transactions = [];

  /// Crea una nueva cuenta bancaria.
  ///
  /// Genera un ID único para la cuenta con formato 'ES' seguido de un número
  /// secuencial, crea la instancia de [Account] y la almacena en el sistema.
  ///
  /// Retorna:
  ///   La [Account] recién creada.
  Account createAccount() {
    final accountNumber = 'ES${_nextAccountNumber++}';
    final account = Account(accountNumber);
    _accounts[account.accountId] = account;
    return account;
  }

  /// Deposita una cantidad especificada en una cuenta.
  ///
  /// Crea una transacción de depósito, la aplica a la cuenta indicada
  /// y registra la transacción en el historial del banco.
  ///
  /// Parámetros:
  ///   [accountNumber] - El ID de la cuenta donde depositar el dinero.
  ///   [amount] - La cantidad a depositar. Debe ser un valor positivo.
  ///
  /// Lanza:
  ///   [ArgumentError] si la cuenta no existe.
  void deposit(String accountNumber, double amount) {
    final account = _getAccount(accountNumber);
    final transaction = DepositTransaction('T${_nextTransactionId++}', amount);
    transaction.apply(account);
    _transactions.add(transaction);
  }

  /// Retira una cantidad especificada de una cuenta.
  ///
  /// Crea una transacción de retiro, la aplica a la cuenta indicada
  /// y registra la transacción en el historial del banco.
  ///
  /// Parámetros:
  ///   [accountNumber] - El ID de la cuenta de la que retirar el dinero.
  ///   [amount] - La cantidad a retirar. Debe ser un valor positivo.
  ///
  /// Lanza:
  ///   [ArgumentError] si la cuenta no existe.
  ///   [StateError] si la cuenta no tiene saldo suficiente.
  void withdraw(String accountNumber, double amount) {
    final account = _getAccount(accountNumber);
    final transaction = WithdrawalTransaction(
      'T${_nextTransactionId++}',
      amount,
    );
    transaction.apply(account);
    _transactions.add(transaction);
  }

  /// Transfiere una cantidad entre dos cuentas.
  ///
  /// Crea una transacción de transferencia, la aplica entre las cuentas indicadas
  /// y registra la transacción en el historial del banco.
  ///
  /// Parámetros:
  ///   [fromAccount] - El ID de la cuenta origen.
  ///   [toAccount] - El ID de la cuenta destino.
  ///   [amount] - La cantidad a transferir. Debe ser un valor positivo.
  ///
  /// Lanza:
  ///   [ArgumentError] si alguna de las cuentas no existe.
  ///   [StateError] si la cuenta origen no tiene saldo suficiente.
  void transfer(String fromAccount, String toAccount, double amount) {
    final fromAccountId = _getAccount(fromAccount);
    final toAccountId = _getAccount(toAccount);
    final transaction = TransferTransaction(
      'T${_nextTransactionId++}',
      amount,
      toAccountId,
    );
    transaction.apply(fromAccountId);
    _transactions.add(transaction);
  }

  /// Busca y retorna una cuenta por su número.
  ///
  /// Método interno utilizado por otras operaciones para obtener una cuenta
  /// a partir de su ID.
  ///
  /// Parámetros:
  ///   [accountNumber] - El ID de la cuenta a buscar.
  ///
  /// Retorna:
  ///   La instancia de [Account] correspondiente al ID proporcionado.
  ///
  /// Lanza:
  ///   [ArgumentError] si la cuenta no existe.
  Account _getAccount(String accountNumber) {
    final account = _accounts[accountNumber];
    if (account == null) {
      throw ArgumentError('Cuenta no encontrada: $accountNumber');
    }
    return account;
  }

  /// Obtiene una lista inmutable de todas las cuentas del banco.
  ///
  /// Retorna:
  ///   Una [List] no modificable con todas las instancias de [Account].
  List<Account> listAccounts() {
    return List.unmodifiable(_accounts.values);
  }

  /// Obtiene una lista inmutable del historial de transacciones.
  ///
  /// Retorna:
  ///   Una [List] no modificable con todas las [Transaction] realizadas.
  List<Transaction> listTransactions() {
    return List.unmodifiable(_transactions);
  }
}

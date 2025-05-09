import 'account.dart';
import 'deposit_transaction.dart';
import 'withdrawal_transaction.dart';
import 'transfer_transaction.dart';
import 'transaction.dart';

class BankService {
  final Map<String, Account> _accounts = {}; // Map de cuentas - clave : Accountid / valor : Account
  int _nextAccountNumber = 100;
  int _nextTransactionId = 1;
  final List<Transaction> _transactions = []; // Lista de todas las transacciones

  // Método para crear una cuenta
  Account createAccount(){
    final accountNumber = 'ES${_nextAccountNumber++}'; // Asignar un número de cuenta
    final account = Account(accountNumber);
    _accounts[account.accountId] = account;
    return account;
  }

  // Método para añadir dinero a una cuenta
  void deposit(String accountNumber, double amount) {
    final account = _getAccount(accountNumber);
    final transaction = DepositTransaction('T${_nextTransactionId++}', amount); // Asignar ID a la transacción
    transaction.apply(account);
    _transactions.add(transaction);
  }

  // Método para retirar dinero de una cuenta
  void withdraw(String accountNumber, double amount) {
    final account = _getAccount(accountNumber);
    final transaction = WithdrawalTransaction('T${_nextTransactionId++}', amount); // Asignar ID a la transacción
    transaction.apply(account);
    _transactions.add(transaction);
  }

  // Método para transferir dinero de una cuenta a otra
  void transfer(String fromAccount, String toAccount, double amount){
    final fromAccountId = _getAccount(fromAccount);
    final toAccountId = _getAccount(toAccount);
    final transaction = TransferTransaction('T${_nextTransactionId++}', amount, toAccountId); // Asignar ID a la transacción
    transaction.apply(fromAccountId);
    _transactions.add(transaction);
  }

  // Método para obtener una cuenta 
  Account _getAccount(String accountNumber) {
    final account = _accounts[accountNumber];
    if (account == null) {
      throw ArgumentError('Cuenta no encontrada: $accountNumber');
    }
    return account;
  }

  // Método para listar las cuentas
  List<Account> listAccounts() {
    return List.unmodifiable(_accounts.values);
  }

  // Método para listar las transacciones
  List<Transaction> listTransactions() {
    return List.unmodifiable(_transactions);
  }
}
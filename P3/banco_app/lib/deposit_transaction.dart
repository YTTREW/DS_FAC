import 'transaction.dart';
import 'account.dart';

class DepositTransaction extends Transaction {
  // Constructor de la clase
  DepositTransaction(String transactionId, double amount) : super(transactionId, amount);
  
  // Metodo abstracto: suma una cantidad de dinero a la cuenta
  @override
  void apply(Account account) {
    account.deposit(amount);
  }
}
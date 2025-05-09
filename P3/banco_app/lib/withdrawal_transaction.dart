import 'transaction.dart';
import 'account.dart';

class WithdrawalTransaction extends Transaction {
  // Constructor de la clase
  WithdrawalTransaction(String id, double amount) : super(id, amount);

  // Método abstracto: retira una cantidad de dinero de la cuenta
  @override
  void apply(Account account) {
    account.withdraw(amount);
  }
}
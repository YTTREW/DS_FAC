import 'transaction.dart';
import 'account.dart';

class TransferTransaction extends Transaction{

  final Account toAccount; // Cuenta de destino para transferir

  // Constructor de la clase
  TransferTransaction(String id, double amount, this.toAccount)
      : super(id, amount);

  // Método abstracto: transfiere una cantidad de dinero de una cuenta a otra
  @override
  void apply(Account fromAccount){
    fromAccount.withdraw(amount);
    toAccount.deposit(amount);
  }
}
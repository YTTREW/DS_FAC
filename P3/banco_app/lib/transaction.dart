import 'account.dart';

abstract class Transaction{
  final String transactionId; // Id de la transacción
  final double amount; // Cantidad de dinero a transferir

  // Constructor de la clase
  Transaction(this.transactionId, this.amount){
      if (amount <= 0) {
        throw ArgumentError('La cantidad debe ser positivo.');
      }
  }

  // Método abstracto
  void apply(Account account);
}
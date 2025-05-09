import 'package:banco_app/bank_service.dart';
import 'package:banco_app/deposit_transaction.dart';
import 'package:banco_app/withdrawal_transaction.dart';

void main() {
  final bank = BankService();

  final acc1 = bank.createAccount();
  final acc2 = bank.createAccount();

  // Realizamos dos depósitos en cada cuenta
  bank.deposit(acc1.accountId, 500);
  bank.deposit(acc2.accountId, 200);

  // Listamos resultados de las cuentas
  print('\nDespués de añadir dinero:');
  bank.listAccounts().forEach(print);

  // Realizamos un retiro en la primera cuenta
  bank.withdraw(acc1.accountId, 100);

  // Listamos resultados de las cuentas
  print('\nDespués de retirar dinero:');
  bank.listAccounts().forEach(print);

  // Realizamos una transferencia entre cuentas
  bank.transfer(acc1.accountId, acc2.accountId, 150);

  // Listamos resultados de las cuentas
  print('\nDespués de transferencia:');
  bank.listAccounts().forEach(print);

  // Listamos todas las transacciones realizadas
  print('\nTransacciones realizadas:');
  bank.listTransactions().forEach((t) {
    String tipoTransaccion;
    if (t is DepositTransaction) {
      tipoTransaccion = 'Depósito';
    } else if (t is WithdrawalTransaction) {
      tipoTransaccion = 'Retirada';
    } else  {
      tipoTransaccion = 'Transferencia';
    } 
    print('Tipo de transacción: $tipoTransaccion | ID: ${t.transactionId} | Cantidad: \$${t.amount}');
  });
}


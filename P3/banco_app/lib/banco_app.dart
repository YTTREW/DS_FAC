import 'bank_service.dart';

void main() {
  final bank = BankService();

  final acc1 = bank.createAccount();
  final acc2 = bank.createAccount();


  bank.deposit(acc1.accountId, 500);
  bank.deposit(acc2.accountId, 200);

  print('\nDespués de depósitos:');
  bank.listAccounts().forEach(print);

 /*  bank.withdraw(acc1.number, 100);

  print('\nDespués de retirada:');
  bank.listAccounts().forEach(print);

  bank.transfer(acc1.number, acc2.number, 150);

  print('\nDespués de transferencia:');
  bank.listAccounts().forEach(print); */

  print('\nTransacciones realizadas:');
  bank.listTransactions().forEach((t) {
    print('${t.runtimeType} | ID: ${t.transactionId} | Importe: \$${t.amount}');
  });
}


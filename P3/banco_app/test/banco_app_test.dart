import 'package:test/test.dart';
import '../lib/account.dart';
import '../lib/bank_service.dart';
import '../lib/deposit_transaction.dart';
import '../lib/withdrawal_transaction.dart';
import '../lib/transfer_transaction.dart';
void main() {
  group('Account', () {
    test('El balance inicial de una cuenta debe ser cero', () {
      final account = Account('TEST1');
      expect(account.saldoCuenta, 0.0);
    });

    test('No se permite depositar cantidades negativas o cero', () {
      final account = Account('TEST2');
      expect(() => account.deposit(0), throwsArgumentError);
      expect(() => account.deposit(-10), throwsArgumentError);
    });

    test('No se permite retirar cantidades negativas o cero', () {
      final account = Account('TEST3');
      expect(() => account.withdraw(0), throwsArgumentError);
      expect(() => account.withdraw(-5), throwsArgumentError);
    });
  });

  group('Transaction', () {
    test('DepositTransaction.apply aumenta el saldo correctamente', () {
      final account = Account('T1');
      final tx = DepositTransaction('TX1', 100.0);
      tx.apply(account);
      expect(account.saldoCuenta, 100.0);
    });

    test('WithdrawalTransaction.apply lanza StateError cuando no hay fondos suficientes', () {
      final account = Account('T2');
      final tx = WithdrawalTransaction('TX2', 50.0);
      expect(() => tx.apply(account), throwsStateError);
    });

    test('TransferTransaction.apply mueve fondos entre cuentas de forma correcta', () {
      final from = Account('T3A')..deposit(200);
      final to = Account('T3B');
      final tx = TransferTransaction('TX3', 150.0, to);
      tx.apply(from);
      expect(from.saldoCuenta, 50.0);
      expect(to.saldoCuenta, 150.0);
    });
  });

  group('BankService', () {
    test('La lista inicial de cuentas está vacía', () {
      final bank = BankService();
      expect(bank.listAccounts(), isEmpty);
    });

    test('deposit aumenta el saldo de la cuenta', () {
      final bank = BankService();
      final acc = bank.createAccount();
      bank.deposit(acc.accountId, 100);
      expect(acc.saldoCuenta, 100);
    });

    test('withdraw lanza StateError cuando el saldo es insuficiente', () {
      final bank = BankService();
      final acc = bank.createAccount();
      expect(() => bank.withdraw(acc.accountId, 50), throwsStateError);
    });

    test('transfer mueve fondos correctamente', () {
      final bank = BankService();
      final a1 = bank.createAccount();
      final a2 = bank.createAccount();
      bank.deposit(a1.accountId, 200);
      bank.transfer(a1.accountId, a2.accountId, 100);
      expect(a1.saldoCuenta, 100);
      expect(a2.saldoCuenta, 100);
    });

    test('transfer lanza StateError cuando los fondos son insuficientes', () {
      final bank = BankService();
      final a1 = bank.createAccount();
      final a2 = bank.createAccount();
      expect(() => bank.transfer(a1.accountId, a2.accountId, 100), throwsStateError);
    });

    test('txId genera identificadores únicos', () {
      final bank = BankService();
      final acc = bank.createAccount();

      bank.deposit(acc.accountId, 100);
      bank.withdraw(acc.accountId, 50);

      final txs = bank.listTransactions();

      expect(txs.length, 2);
      expect(txs[0].transactionId, isNot(equals(txs[1].transactionId)));
    });
  });
}

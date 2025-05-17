import 'package:flutter/material.dart';
import 'package:bank_app/models/transactions/transaction.dart';
import 'package:bank_app/models/transactions/deposit_transaction.dart';
import 'package:bank_app/models/transactions/withdrawal_transaction.dart';
import 'package:bank_app/models/transactions/transfer_transaction.dart';

class TransactionItem extends StatelessWidget {
  final Transaction transaction;

  const TransactionItem({super.key, required this.transaction});

  @override
  Widget build(BuildContext context) {
    IconData icon;
    Color color;
    String title;
    String subtitle;

    if (transaction is DepositTransaction) {
      icon = Icons.arrow_circle_down;
      color = Colors.green;
      title = 'Depósito';
      subtitle = 'ID: ${transaction.transactionId}';
    } else if (transaction is WithdrawalTransaction) {
      icon = Icons.arrow_circle_up;
      color = Colors.red;
      title = 'Retiro';
      subtitle = 'ID: ${transaction.transactionId}';
    } else if (transaction is TransferTransaction) {
      icon = Icons.swap_horiz;
      color = Colors.blue;
      title = 'Transferencia';
      subtitle = 'ID: ${transaction.transactionId}';
    } else {
      icon = Icons.monetization_on;
      color = Colors.grey;
      title = 'Transacción';
      subtitle = 'ID: ${transaction.transactionId}';
    }

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color.withValues(alpha: 50),
          child: Icon(icon, color: color),
        ),
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: Text(
          '\$${transaction.amount.toStringAsFixed(2)}',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color:
                transaction is DepositTransaction ? Colors.green : Colors.black,
          ),
        ),
      ),
    );
  }
}

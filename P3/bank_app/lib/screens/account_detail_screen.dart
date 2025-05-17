import 'package:bank_app/models/transactions/deposit_transaction.dart';
import 'package:bank_app/models/transactions/transfer_transaction.dart';
import 'package:bank_app/models/transactions/withdrawal_transaction.dart';
import 'package:flutter/material.dart';
import 'package:bank_app/models/account.dart';
import 'package:bank_app/models/transactions/transaction.dart';
import 'package:bank_app/services/bank_service.dart';
import 'package:bank_app/widgets/transaction_item.dart';
import 'package:bank_app/screens/transaction_form_screen.dart';

class AccountDetailScreen extends StatefulWidget {
  final Account account;
  final BankService bankService;

  const AccountDetailScreen({
    super.key,
    required this.account,
    required this.bankService,
  });

  @override
  State<AccountDetailScreen> createState() => _AccountDetailScreenState();
}

class _AccountDetailScreenState extends State<AccountDetailScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<Transaction> transactions = [];
  List<Account> otherAccounts = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadTransactions();
    _loadOtherAccounts();
  }

  void _loadTransactions() {
    final allTransactions = widget.bankService.listTransactions();
    final String currentAccountId = widget.account.accountId;

    setState(() {
      // Filtrar solo las transacciones relacionadas con esta cuenta
      transactions =
          allTransactions.where((transaction) {
            // Para depósitos y retiros, comprobamos si la transacción se aplicó a esta cuenta
            // Para transferencias, comprobamos si esta cuenta es origen o destino
            if (transaction is DepositTransaction ||
                transaction is WithdrawalTransaction) {
              // Comparamos el ID de la cuenta en el historial de transacciones
              // Esto es una aproximación ya que no tenemos una manera directa de verificar
              return transaction.transactionId.contains(currentAccountId);
            } else if (transaction is TransferTransaction) {
              // Para transferencias, verificamos si esta cuenta es origen o destino
              final transfer = transaction;
              return transfer.toAccount.accountId == currentAccountId ||
                  transfer.transactionId.contains(currentAccountId);
            }
            return false;
          }).toList();
    });
  }

  void _loadOtherAccounts() {
    setState(() {
      otherAccounts =
          widget.bankService
              .listAccounts()
              .where((acc) => acc.accountId != widget.account.accountId)
              .toList();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cuenta ${widget.account.accountId}'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Resumen'),
            Tab(text: 'Depositar'),
            Tab(text: 'Retirar'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [_buildSummaryTab(), _buildDepositTab(), _buildWithdrawTab()],
      ),
      floatingActionButton:
          otherAccounts.isNotEmpty
              ? FloatingActionButton(
                onPressed: _showTransferDialog,
                tooltip: 'Transferir',
                child: const Icon(Icons.swap_horiz),
              )
              : null,
    );
  }

  Widget _buildSummaryTab() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
            elevation: 4,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Saldo Actual',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '\$${widget.account.saldoCuenta.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color:
                          widget.account.saldoCuenta > 0
                              ? Colors.green
                              : Colors.red,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'Transacciones Recientes',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Expanded(
            child:
                transactions.isEmpty
                    ? const Center(child: Text('No hay transacciones'))
                    : ListView.builder(
                      itemCount: transactions.length,
                      itemBuilder: (context, index) {
                        final transaction = transactions[index];
                        return TransactionItem(transaction: transaction);
                      },
                    ),
          ),
        ],
      ),
    );
  }

  Widget _buildDepositTab() {
    return TransactionFormScreen(
      title: 'Depositar Dinero',
      buttonText: 'Depositar',
      onSubmit: (amount) {
        try {
          widget.bankService.deposit(widget.account.accountId, amount);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Depósito de \$$amount realizado correctamente'),
            ),
          );
          setState(() {});
          _loadTransactions();
        } catch (e) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Error: ${e.toString()}')));
        }
      },
    );
  }

  Widget _buildWithdrawTab() {
    return TransactionFormScreen(
      title: 'Retirar Dinero',
      buttonText: 'Retirar',
      onSubmit: (amount) {
        try {
          widget.bankService.withdraw(widget.account.accountId, amount);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Retiro de \$$amount realizado correctamente'),
            ),
          );
          setState(() {});
          _loadTransactions();
        } catch (e) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Error: ${e.toString()}')));
        }
      },
    );
  }

  void _showTransferDialog() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return _TransferForm(
          sourceAccount: widget.account,
          availableAccounts: otherAccounts,
          bankService: widget.bankService,
          onTransferComplete: () {
            setState(() {});
            _loadTransactions();
          },
        );
      },
    );
  }
}

class _TransferForm extends StatefulWidget {
  final Account sourceAccount;
  final List<Account> availableAccounts;
  final BankService bankService;
  final VoidCallback onTransferComplete;

  const _TransferForm({
    required this.sourceAccount,
    required this.availableAccounts,
    required this.bankService,
    required this.onTransferComplete,
  });

  @override
  __TransferFormState createState() => __TransferFormState();
}

class __TransferFormState extends State<_TransferForm> {
  final _amountController = TextEditingController();
  late Account _selectedAccount;

  @override
  void initState() {
    super.initState();
    _selectedAccount = widget.availableAccounts.first;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 16,
        right: 16,
        top: 16,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'Transferir Dinero',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<Account>(
            value: _selectedAccount,
            decoration: const InputDecoration(
              labelText: 'Cuenta Destino',
              border: OutlineInputBorder(),
            ),
            items:
                widget.availableAccounts.map((Account account) {
                  return DropdownMenuItem<Account>(
                    value: account,
                    child: Text(account.accountId),
                  );
                }).toList(),
            onChanged: (Account? newValue) {
              if (newValue != null) {
                setState(() {
                  _selectedAccount = newValue;
                });
              }
            },
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _amountController,
            decoration: const InputDecoration(
              labelText: 'Cantidad',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.attach_money),
            ),
            keyboardType: TextInputType.numberWithOptions(decimal: true),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              if (_amountController.text.isEmpty) return;

              try {
                final amount = double.parse(_amountController.text);
                widget.bankService.transfer(
                  widget.sourceAccount.accountId,
                  _selectedAccount.accountId,
                  amount,
                );

                Navigator.pop(context);
                widget.onTransferComplete();

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Transferencia de \$$amount realizada correctamente',
                    ),
                  ),
                );
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Error: ${e.toString()}')),
                );
              }
            },
            child: const Padding(
              padding: EdgeInsets.symmetric(vertical: 12),
              child: Text('Transferir'),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

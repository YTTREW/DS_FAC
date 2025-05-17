import 'package:flutter/material.dart';
import 'package:bank_app/services/bank_service.dart';
import 'package:bank_app/models/account.dart';
import 'package:bank_app/screens/account_detail_screen.dart';
import 'package:bank_app/widgets/account_card.dart';

class HomeScreen extends StatefulWidget {
  final BankService bankService;

  const HomeScreen({super.key, required this.bankService});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late List<Account> accounts;

  @override
  void initState() {
    super.initState();
    accounts = widget.bankService.listAccounts();
  }

  void _refreshAccounts() {
    setState(() {
      accounts = widget.bankService.listAccounts();
    });
  }

  void _createNewAccount() {
    setState(() {
      widget.bankService.createAccount();
      accounts = widget.bankService.listAccounts();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Bank App')),
      body:
          accounts.isEmpty
              ? Center(child: Text('No tienes cuentas. Crea una para empezar.'))
              : ListView.builder(
                padding: const EdgeInsets.all(16.0),
                itemCount: accounts.length,
                itemBuilder: (context, index) {
                  final account = accounts[index];
                  return AccountCard(
                    account: account,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) => AccountDetailScreen(
                                account: account,
                                bankService: widget.bankService,
                              ),
                        ),
                      ).then((_) => _refreshAccounts());
                    },
                  );
                },
              ),
      floatingActionButton: FloatingActionButton(
        onPressed: _createNewAccount,
        tooltip: 'Nueva Cuenta',
        child: const Icon(Icons.add),
      ),
    );
  }
}

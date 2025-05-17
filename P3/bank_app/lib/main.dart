import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:bank_app/services/bank_service.dart';
import 'package:bank_app/screens/home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Provider<BankService>(
      create: (_) => BankService(),
      child: MaterialApp(
        title: 'Bank App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: Consumer<BankService>(
          builder:
              (context, bankService, _) => HomeScreen(bankService: bankService),
        ),
      ),
    );
  }
}

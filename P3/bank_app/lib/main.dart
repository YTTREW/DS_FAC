import 'package:flutter/material.dart';
import 'package:bank_app/services/bank_service.dart';
import 'package:bank_app/screens/home_screen.dart';

void main() {
  runApp(BankApp());
}

class BankApp extends StatelessWidget {
  // Instancia compartida del servicio bancario para toda la app
  final BankService bankService = BankService();

  BankApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bank App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: HomeScreen(bankService: bankService),
    );
  }
}

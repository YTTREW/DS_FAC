import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:bank_app/providers/theme_provider.dart';
import 'package:bank_app/services/bank_service.dart';
import 'package:bank_app/screens/home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        Provider<BankService>(create: (_) => BankService()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            title: 'Bank App',
            theme: themeProvider.getTheme(),
            home: Consumer<BankService>(
              builder:
                  (context, bankService, _) =>
                      HomeScreen(bankService: bankService),
            ),
          );
        },
      ),
    );
  }
}

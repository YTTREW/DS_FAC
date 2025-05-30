import 'package:email_filter_app/auth_target.dart';
import 'package:email_filter_app/credentials.dart';
import 'package:email_filter_app/filter_manager.dart';
import 'package:email_filter_app/filters/email_already_used_filter.dart';
import 'package:email_filter_app/filters/email_valid_domain_filter.dart';
import 'package:email_filter_app/filters/filter.dart';
import 'package:email_filter_app/filters/email_format_filter.dart';
import 'package:email_filter_app/filters/password_length_filter.dart';
import 'package:email_filter_app/filters/password_special_character_filter.dart';
import 'package:email_filter_app/filters/password_upper_case_filter.dart';
import 'package:flutter/material.dart';

class EmailFilterScreen extends StatefulWidget {
  const EmailFilterScreen({super.key});

  @override
  State<EmailFilterScreen> createState() => _EmailFilterScreenState();
}

class _EmailFilterScreenState extends State<EmailFilterScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final List<Filter> _allFilters = [
    EmailFormatFilter(),
    EmailValidDomainFilter(),
    PasswordLengthFilter(),
    PasswordUpperCaseFilter(),
    PasswordSpecialCharacterFilter(),
    EmailAlreadyUsedFilter(),
  ];
  final Set<Filter> _selectedFilters = {};

  bool _allSelected = false;

  final String _result = '';

  void _authenticate() {
    final credentials = Credentials(
      email: _emailController.text.trim(),
      password: _passwordController.text,
    );

    final manager = FilterManager(PrintAuthTarget());

    for (var filter in _selectedFilters) {
      manager.addFilter(filter);
    }

    try {
      manager.authenticate(credentials);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('✅ Autenticación exitosa'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('❌ ${e.toString()}'),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  Widget _buildFilterCheckbox(Filter filter) {
    return CheckboxListTile(
      title: Text(filter.name),
      value: _selectedFilters.contains(filter),
      onChanged: (bool? selected) {
        setState(() {
          if (selected == true) {
            _selectedFilters.add(filter);
          } else {
            _selectedFilters.remove(filter);
          }
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Center(child: Text('Email Filter App'))),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'Correo electrónico',
              ),
            ),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(labelText: 'Contraseña'),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            const Text(
              'Filtros disponibles:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            ..._allFilters.map(_buildFilterCheckbox),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(_allSelected ? 'Quitar todos' : 'Seleccionar todos'),
                Switch(
                  value: _allSelected,
                  onChanged: (value) {
                    setState(() {
                      _allSelected = value;
                      if (_allSelected) {
                        _selectedFilters.addAll(_allFilters);
                      } else {
                        _selectedFilters.clear();
                      }
                    });
                  },
                ),
              ],
            ),

            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _authenticate,
              child: const Text('Autenticar'),
            ),
            const SizedBox(height: 16),
            Text(_result, style: const TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}

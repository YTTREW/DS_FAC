import 'package:email_filter_app/credentials.dart';
import 'package:flutter/material.dart';

abstract class AuthTarget {
  void authenticate(Credentials credentials);
}

class PrintAuthTarget implements AuthTarget {
  @override
  void authenticate(Credentials credentials) {
    debugPrint(
      'Autenticado con: ${credentials.email} / ${credentials.password}',
    );
  }
}

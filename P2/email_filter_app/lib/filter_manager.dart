import 'package:email_filter_app/credentials.dart';
import 'package:email_filter_app/auth_target.dart';
import 'package:email_filter_app/filters/filter.dart';
import 'package:email_filter_app/filters/filter_chain.dart';

class FilterManager {
  final FilterChain _filterChain;

  FilterManager(AuthTarget target) : _filterChain = FilterChain() {
    _filterChain.setTarget(target);
  }

  void addFilter(Filter filter) {
    _filterChain.addFilter(filter);
  }

  void authenticate(Credentials credentials) {
    _filterChain.execute(credentials);
  }
}

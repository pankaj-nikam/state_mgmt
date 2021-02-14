import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class Auth with ChangeNotifier {
  String _token;
  DateTime _expiryDate;
  String _userId;

  Future<void> _authenticate(
      String email, String password, String urlSegment) async {
    final url =
        "https://identitytoolkit.googleapis.com/v1/accounts:$urlSegment?key=AIzaSyDwF04SZt-8yOU2ABgEK9okjiU_j8tRXNQ";
    final response = await http.post(url,
        body: json.encode({
          'email': email,
          'password': password,
          'returnSecuredToken': true,
        }));
    print(jsonDecode(response.body));
  }

  Future<void> signup(String email, String password) async {
    await _authenticate(email, password, "signUp");
  }

  Future<void> signin(String email, String password) async {
    _authenticate(email, password, "signInWithPassword");
  }
}

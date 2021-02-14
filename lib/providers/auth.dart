import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class Auth with ChangeNotifier {
  String _token;
  DateTime _expiryDate;
  String _userId;

  Future<void> signup(String email, String password) async {
    const url =
        "https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=AIzaSyDwF04SZt-8yOU2ABgEK9okjiU_j8tRXNQ";
    final response = await http.post(url,
        body: json.encode({
          'email': email,
          'password': password,
          'returnSecuredToken': true,
        }));
    print(jsonDecode(response.body));
  }

  Future<void> signin(String email, String password) async {
    const url =
        "https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=AIzaSyDwF04SZt-8yOU2ABgEK9okjiU_j8tRXNQ";
    final response = await http.post(url,
        body: json.encode({
          'email': email,
          'password': password,
          'returnSecuredToken': true,
        }));
    print(jsonDecode(response.body));
  }
}

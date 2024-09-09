import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:jwt_decode/jwt_decode.dart';
import 'package:my_app/model/http_exception.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider with ChangeNotifier {
  String _token = '';
  DateTime _expiryDate = DateTime.now();

  String get token {
    if (_token.isNotEmpty && !Jwt.isExpired(_token)) {
      return _token;
    }

    return '';
  }

  bool get isAuth {
    return token.isNotEmpty;
  }

  Future<void> signup(String email, String password) async {
    final url = Uri.parse('http://10.0.2.2:8080/api/user/register');
    Map<String, String> headers = {
      'Content-type': 'application/json',
      'Accept': '*/*',
    };

    try {
      final response = await http.post(url,
          headers: headers,
          body: json.encode({'email': email, 'password': password}));
      final res = json.decode(response.body);
      log(res.toString());
      notifyListeners();
    } catch (err) {
      log(err.toString());
      rethrow;
    }
  }

  Future<void> login(String email, String password) async {
    final url = Uri.parse('http://10.0.2.2:8080/api/user/login');
    Map<String, String> headers = {
      'Content-type': 'application/json',
      'Accept': '*/*',
    };

    try {
      final response = await http.post(url,
          headers: headers,
          body: json.encode({'email': email, 'password': password}));

      if (response.statusCode != 200) {
        throw HttpException(json.decode(response.body)['message']);
      }
      final res = json.decode(response.body);
      _token = res['token'];
      _expiryDate = Jwt.getExpiryDate(_token)!;
      _autoLogout();

      final prefs = await SharedPreferences.getInstance();
      final userData = json.encode({
        'token': _token,
        'expiryDate': _expiryDate.toIso8601String(),
      });
      prefs.setString('userData', userData);

      notifyListeners();
    } catch (err) {
      log(err.toString());
      rethrow;
    }
  }

  Future<void> logout() async {
    _token = '';
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('userData');
    notifyListeners();
  }

  void _autoLogout() {
    final timeToExpiry = _expiryDate.difference(DateTime.now()).inSeconds;
    Future.delayed(Duration(seconds: timeToExpiry), logout);
  }

  Future<void> tryAutoLogin() async {
    if (token.isNotEmpty) {
      return;
    }

    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('userData')) {
      return;
    }

    final userData =
        json.decode(prefs.getString('userData')!) as Map<String, Object>;
    final expiryDate = DateTime.parse(userData['expiryDate'].toString());

    if (expiryDate.isBefore(DateTime.now())) {
      return;
    }

    _token = userData['token'].toString();
    _expiryDate = expiryDate;
    notifyListeners();
    _autoLogout();
  }
}

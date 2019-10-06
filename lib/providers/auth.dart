import 'dart:convert';
import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../models/http_exception.dart';

class Auth with ChangeNotifier {
  String _accessToken;
  String _refreshToken;

  bool get isAuthenticated {
    return _accessToken != null;
  }

  Future<void> _setAuthTokens(Map<String, dynamic> tokens) async {
    _accessToken = tokens['accessToken'];
    _refreshToken = tokens['refreshToken'];

    notifyListeners();

    final sharedPrefs = await SharedPreferences.getInstance();
    final authTokens = json.encode({
      'accessToken': _accessToken,
      'refreshToken': _refreshToken,
    });
    sharedPrefs.setString('authTokens', authTokens);
  }

  Future<void> signup(Map<String, String> authData) async {
    try {
      final response = await http.post(
        'http://10.0.2.2:5002/api/signup',
        body: json.encode({"user": authData}),
        headers: {"Content-Type": "application/json"},
      );

      if (response.statusCode != 201) {
        throw HttpException("Erro ao cadastrar.");
      }

      final responseJson = json.decode(response.body);

      _setAuthTokens(responseJson['authTokens']);
    } catch (error) {
      throw error;
    }
  }

  Future<void> login(Map<String, String> authData) async {
    try {
      final response = await http.post(
        'http://10.0.2.2:5002/api/login',
        body: json.encode(authData),
        headers: {"Content-Type": "application/json"},
      );

      if (response.statusCode == 401) {
        throw HttpException("Usuário ou senha inválidos.");
      }

      final responseJson = json.decode(response.body);
      await _setAuthTokens(responseJson['authTokens']);
    } catch (error) {
      throw error;
    }
  }

  Future<bool> tryAutoLogin() async {
    final sharedPrefs = await SharedPreferences.getInstance();
    if (!sharedPrefs.containsKey('authTokens')) {
      return false;
    }

    final authTokens =
        json.decode(sharedPrefs.get('authTokens')) as Map<String, Object>;

    _accessToken = authTokens['accessToken'];
    _refreshToken = authTokens['refreshToken'];

    notifyListeners();
    return true;
  }
}

import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:svg_app/screens/signup.dart';

import './screens/login.dart';
import './screens/home.dart';
import './screens/pairing.dart';
import './providers/auth.dart';
import './screens/loading.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _fcm = FirebaseMessaging();

  @override
  void initState() {
    super.initState();
    SharedPreferences.getInstance().then((instance) {
      if (instance.containsKey('authTokens')) {
        final authTokens =
            json.decode(instance.get('authTokens')) as Map<String, Object>;

        var accessToken = authTokens['accessToken'];
        _fcm.getToken().then((value) {
          http.post(
            'http://localhost:5002/api/device_id',
            body: json.encode({"deviceId": value}),
            headers: {
              "Content-Type": "application/json",
              "Authorization": "Bearer $accessToken"
            },
          );
        });
      }
    });
  }

  Widget _buildHome(Auth auth) {
    if (auth.isAuthenticated && auth.hasMachine) {
      return HomeScreen();
    } else if (auth.isAuthenticated && !auth.hasMachine) {
      return PairingScreen(); // adicionar tela de pareamento aqui.
    }
    return FutureBuilder(
      future: auth.tryAutoLogin(),
      builder: (ctx, authResult) =>
          authResult.connectionState == ConnectionState.waiting
              ? LoadingScreen()
              : LoginScreen(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: Auth(),
        )
      ],
      child: Consumer<Auth>(builder: (ctx, auth, _) {
        print(auth.isAuthenticated);
        return MaterialApp(
          title: 'SVG',
          theme: ThemeData(
            primaryColor: Color.fromRGBO(144, 201, 82, 1),
          ),
          home: _buildHome(auth),
          routes: {
            SignupScreen.routeName: (ctx) => SignupScreen(),
          },
        );
      }),
    );
  }
}

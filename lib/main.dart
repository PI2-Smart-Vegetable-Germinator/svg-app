import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:svg_app/screens/signup.dart';

import './screens/login.dart';
import './screens/home.dart';
import './providers/auth.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
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
          home: auth.isAuthenticated
              ? HomeScreen()
              : FutureBuilder(
                  future: auth.tryAutoLogin(),
                  builder: (ctx, authResult) =>
                      authResult.connectionState == ConnectionState.waiting
                          ? CircularProgressIndicator()
                          : LoginScreen(),
                ),
          routes: {
            SignupScreen.routeName: (ctx) => SignupScreen(),
          },
        );
      }),
    );
  }
}

import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/logo.dart';

import '../providers/auth.dart';
import '../models/http_exception.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey();

  Map<String, String> _authData = {
    'email': '',
    'password': '',
  };

  Future<void> submit() async {
    if (!_formKey.currentState.validate()) {
      return;
    }

    _formKey.currentState.save();

    print(_authData);

    try {
      await Provider.of<Auth>(context, listen: false).login(_authData);
    } on HttpException catch (error) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Erro"),
            content: Text(error.message),
          );
        },
      );
    } catch (error) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Erro"),
            content: Text(
              "Falha ao se comunicar com o servidor. Por favor, tente novamente.",
            ),
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final emailField = TextFormField(
      onSaved: (value) {
        _authData['email'] = value;
      },
      style: TextStyle(color: Colors.white),
      decoration: InputDecoration(
        prefixIcon: Icon(
          Icons.email,
          color: Colors.white,
        ),
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        hintText: "Email",
        hintStyle: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(32.0),
          borderSide: BorderSide(color: Colors.grey, width: 0.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(32.0),
          borderSide: BorderSide(color: Colors.grey, width: 0.0),
        ),
        fillColor: Color.fromRGBO(67, 100, 54, 1),
        filled: true,
      ),
    );

    final passwordField = TextFormField(
      onSaved: (value) {
        _authData['password'] = value;
      },
      obscureText: true,
      style: TextStyle(color: Colors.white),
      decoration: InputDecoration(
        prefixIcon: Icon(
          Icons.lock,
          color: Colors.white,
        ),
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        hintText: "Senha",
        hintStyle: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(32.0),
          borderSide: BorderSide(color: Colors.grey, width: 0.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(32.0),
          borderSide: BorderSide(color: Colors.grey, width: 0.0),
        ),
        fillColor: Color.fromRGBO(67, 100, 54, 1),
        filled: true,
      ),
    );

    final loginButton = RaisedButton(
      onPressed: () {
        submit();
      },
      color: Colors.white,
      textColor: Color.fromRGBO(67, 100, 54, 1),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(32),
      ),
      padding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
      child: Container(
        child: const Text(
          'Login',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ),
    );

    final loginForm = Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            LogoWidget(),
            SizedBox(height: 45),
            emailField,
            SizedBox(height: 15),
            passwordField,
            SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: loginButton,
            ),
            FlatButton(
              onPressed: () {
                Navigator.of(context).pushNamed('/signup');
              },
              textColor: Color.fromRGBO(67, 100, 54, 1),
              child: Text("Não possui uma conta? Cadastrar agora!"),
            )
          ],
        ),
      ),
    );

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color.fromRGBO(144, 201, 82, 1),
              Color.fromRGBO(135, 185, 80, 1),
            ],
          ),
        ),
        height: MediaQuery.of(context).size.height,
        child: Padding(
          padding: EdgeInsets.all(36.0),
          child: loginForm,
        ),
      ),
    );
  }
}

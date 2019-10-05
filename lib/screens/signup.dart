import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/auth.dart';

class SignupScreen extends StatefulWidget {
  static const routeName = '/signup';

  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey();

  final _passwordController = TextEditingController();

  Map<String, String> _authData = {
    'email': '',
    'password': '',
  };

  Future<void> _submit() async {
    if (!_formKey.currentState.validate()) {
      return;
    }

    _formKey.currentState.save();

    try {
      await Provider.of<Auth>(context, listen: false).signup(_authData);
      Navigator.of(context).pop();
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
      validator: (value) {
        print(value.isEmpty);
        print(value.length);
        if (value.isEmpty || value.length < 5) {
          print('oi?');
          return 'A senha deve conter no mínimo 6 caracteres!';
        }
      },
      controller: _passwordController,
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
        errorBorder: UnderlineInputBorder(
          borderRadius: BorderRadius.circular(32.0),
          borderSide: BorderSide(color: Colors.grey, width: 0.0),
        ),
        focusedErrorBorder: UnderlineInputBorder(
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

    final passwordConfirmField = TextFormField(
      validator: (value) {
        if (value != _passwordController.text) {
          return 'As senhas não conferem!';
        }
      },
      obscureText: true,
      style: TextStyle(color: Colors.white),
      decoration: InputDecoration(
        prefixIcon: Icon(
          Icons.lock,
          color: Colors.white,
        ),
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        hintText: "Confirmação da Senha",
        hintStyle: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(32.0),
          borderSide: BorderSide(color: Colors.grey, width: 0.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(32.0),
          borderSide: BorderSide(color: Colors.grey, width: 0.0),
        ),
        errorBorder: UnderlineInputBorder(
          borderRadius: BorderRadius.circular(32.0),
          borderSide: BorderSide(color: Colors.grey, width: 0.0),
        ),
        focusedErrorBorder: UnderlineInputBorder(
          borderRadius: BorderRadius.circular(32.0),
          borderSide: BorderSide(color: Colors.grey, width: 0.0),
        ),
        fillColor: Color.fromRGBO(67, 100, 54, 1),
        filled: true,
      ),
    );

    final signupButton = RaisedButton(
      onPressed: () {
        _submit();
      },
      color: Colors.white,
      textColor: Color.fromRGBO(67, 100, 54, 1),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(32),
      ),
      padding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
      child: Container(
        child: const Text(
          'Cadastrar',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ),
    );

    final signupForm = Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          SizedBox(
            height: 20,
          ),
          Center(
            child: Text(
              "Cadastre-se agora e comece a usar o SVG!",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 36.0,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(height: 45),
          emailField,
          SizedBox(height: 15),
          passwordField,
          SizedBox(height: 15),
          passwordConfirmField,
          SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: signupButton,
          ),
          Expanded(
            child: Align(
              alignment: FractionalOffset.bottomLeft,
              child: IconButton(
                icon: Icon(
                  Icons.arrow_back,
                  size: 40.0,
                ),
                color: Colors.white,
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
          )
        ],
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
          child: signupForm,
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import '../widgets/logo.dart';

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final emailField = TextField(
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

    final passwordField = TextField(
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
      onPressed: () {},
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
        child: Padding(
          padding: EdgeInsets.all(36.0),
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
                onPressed: () {},
                textColor: Color.fromRGBO(67, 100, 54, 1),
                child: Text("Não possui uma conta? Cadastrar agora!"),
              )
            ],
          ),
        ),
      ),
    );
  }
}

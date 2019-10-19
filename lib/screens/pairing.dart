import 'package:flutter/material.dart';
import 'dart:async';
import 'package:provider/provider.dart';
import '../providers/auth.dart';
import '../models/http_exception.dart';

import 'package:pin_code_text_field/pin_code_text_field.dart';

class PairingScreen extends StatefulWidget {
  @override
  _PairingScreenState createState() => _PairingScreenState();
}

class _PairingScreenState extends State<PairingScreen> {
  bool _pincodeMode = false;
  bool _showLoading = false;

  Future<void> _sendPincode(String pincode) async {
    _showLoading = true;
    try {
      await Provider.of<Auth>(context, listen: false).sendPincode(pincode);
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
    } finally {
      _showLoading = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final tutorial = Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        SizedBox(height: 18),
        Text(
          "Pareie o aplicativo com sua SVG",
          style: TextStyle(
            color: Colors.white,
            fontSize: 36,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 50),
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            "1. Na SVG, toque em iniciar sistema",
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            "2. Digite o código PIN da SVG no aplicativo",
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            "3. Pronto, é só começar a usar!",
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SizedBox(height: 50),
        SizedBox(
          width: double.infinity,
          child: OutlineButton(
            borderSide: BorderSide(color: Colors.white),
            onPressed: () {
              setState(() {
                _pincodeMode = true;
              });
            },
            padding: EdgeInsets.all(15.0),
            child: Text(
              "Vamos lá".toUpperCase(),
              style: TextStyle(
                fontSize: 20,
                color: Colors.white,
              ),
            ),
          ),
        )
      ],
    );

    final sendPincode = SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          SizedBox(height: 18),
          Text(
            "Digite o código PIN que você vê na tela da SVG",
            style: TextStyle(
              color: Colors.white,
              fontSize: 36,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 50),
          _showLoading ? CircularProgressIndicator() : Container(),
          PinCodeTextField(
            maxLength: 4,
            defaultBorderColor: Colors.white,
            hasTextBorderColor: Colors.white,
            onDone: (value) {
              _sendPincode(value);
            },
            pinTextStyle: TextStyle(
              fontSize: 28,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
            pinBoxWidth: 60,
            pinBoxDecoration:
                ProvidedPinBoxDecoration.underlinedPinBoxDecoration,
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
        padding: EdgeInsets.all(36.0),
        constraints: BoxConstraints.expand(),
        child: ListView(children: [_pincodeMode ? sendPincode : tutorial]),
      ),
    );
  }
}

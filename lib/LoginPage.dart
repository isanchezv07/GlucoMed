// ignore_for_file: unnecessary_new, unused_local_variable, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _LoginPageState();
}

enum FormType {
  login,
  register
}

class _LoginPageState extends State<LoginPage> {
  final formKey = GlobalKey<FormState>();

  String _email = '';
  String _password = '';
  FormType _formType = FormType.login;

  bool validateAndSave() {
    final form = formKey.currentState;
    if (form!.validate()) {
      form.save();
      return true;
    } 
    return false;
  }

  Future<void> validateAndSubmit() async {
    if (validateAndSave()) {
      try {
        if (_formType == FormType.login) {
          await FirebaseAuth.instance.signInWithEmailAndPassword(email: _email, password: _password);
          print('Signed in');
        } else {
          await FirebaseAuth.instance.createUserWithEmailAndPassword(email: _email, password: _password);
          print('Registered user');
        }
      } catch(e) {
        print('Error: $e');
      }
    }
  }

  void moveToRegister() {
    formKey.currentState?.reset();
    setState(() {
      _formType = FormType.register;
    });
  }

  void moveToLogin() {
    formKey.currentState?.reset();
    setState(() {
      _formType = FormType.login;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Gluco Med APP'),
      ),
      body: Container(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: buildInputs() + buildSubmitButtons(),
          ),
        ),
      ),
    );
  }
  
  List<Widget> buildInputs() {
    return [
      TextFormField(
        decoration: InputDecoration(labelText: 'Email'),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Email can\'t be empty';
          }
          return null;
        },
        onSaved: (value) => _email = value!,
      ),
      TextFormField(
        decoration: InputDecoration(labelText: 'Password'),
        obscureText: true,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Password can\'t be empty';
          }
          return null;
        },
        onSaved: (value) => _password = value!,
      ),
    ];
  }
  
  List<Widget> buildSubmitButtons() {
    if (_formType == FormType.login) {
      return [
        ElevatedButton(
          child: Text('Login', style: TextStyle(fontSize: 20.0)),
          onPressed: validateAndSubmit,
        ),
        TextButton(
          child: Text('Create an account', style: TextStyle(fontSize: 20.0)),
          onPressed: moveToRegister,
        ),
      ];
    } else {
      return [
        ElevatedButton(
          child: Text('Create account', style: TextStyle(fontSize: 20.0)),
          onPressed: validateAndSubmit,
        ),
        TextButton(
          child: Text('Have an account? Login', style: TextStyle(fontSize: 20.0)),
          onPressed: moveToLogin,
        ),
      ];
    }
  }
}
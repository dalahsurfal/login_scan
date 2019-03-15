import 'package:flutter/material.dart';
import 'package:login_scan/auth.dart';
import 'package:login_scan/auth_provider.dart';

class LoginPage extends StatefulWidget {

  @override
  State<StatefulWidget> createState() => _LoginPageState();
}

enum FormType { login, register }

class _LoginPageState extends State<LoginPage> {
  final formKey = GlobalKey<FormState>();

  String _email;
  String _password;
  FormType _formType = FormType.login;

  bool validateAndSave() {
    final form = formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    } else {
      return false;
    }
  }

  void validateAndSubmit() async {
    if (validateAndSave()) {
      try {
        final BaseAuth auth = AuthProvider.of(context).auth;
        if(_formType == FormType.login){
          final String userId = await auth.signInWithEmailAndPassword(_email, _password);
          print('========================= Signed in: $userId =========================');
        }else{
          String userId = await auth.createUserWithEmailAndPassword(_email, _password);
          print('========================= Registered user: $userId =========================');
        }
      } catch (e) {
        print('ERROR: $e');
      }
    }
  }

  void moveToRegister() {
    formKey.currentState.reset();
    setState(() {
      _formType = FormType.register;
    });
  }

  void moveToLogin(){
    formKey.currentState.reset();
    setState(() {
      _formType = FormType.login;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Login demo"),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 64),
        child: Form(
          key: formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
//            crossAxisAlignment: CrossAxisAlignment.stretch,
            children:  buildTitle() + buildInputs() + buildSubmitButtons(),
          ),
        ),
      ),
    );
  }

  List<Widget> buildTitle(){
    return[
      Text('Welcome', style: Theme.of(context)
          .textTheme
          .display4
          .copyWith(color: Colors.black, fontSize: 48)),
    ];
  }

  List<Widget> buildInputs() {
    return [
      TextFormField(
        decoration: InputDecoration(labelText: 'Email'),
        validator: (value) => value.isEmpty ? 'Email can\'t be empty' : null,
        onSaved: (value) => _email = value,
      ),
      TextFormField(
        decoration: InputDecoration(labelText: 'Password'),
        validator: (value) => value.isEmpty ? 'Password can\'t be empty' : null,
        obscureText: true,
        onSaved: (value) => _password = value,
      ),
    ];
  }

  List<Widget> buildSubmitButtons() {
    if(_formType == FormType.login){
      return [
        RaisedButton(
          child: Text('Login', style: TextStyle(fontSize: 20.0),),
          onPressed: validateAndSubmit,
        ),
        FlatButton(
          child: Text('Create account', style: TextStyle(fontSize: 20.0, color: Colors.deepPurple),),
          onPressed: moveToRegister,
        ),
      ];
    }else{
      return [
        RaisedButton(
          child: Text('Create account', style: TextStyle(fontSize: 20.0),),
          onPressed: validateAndSubmit,
        ),
        FlatButton(
          child: Text('Back to Login', style: TextStyle(fontSize: 20.0, color: Colors.deepPurple),),
          onPressed: moveToLogin,
        ),
      ];
    }
  }
}

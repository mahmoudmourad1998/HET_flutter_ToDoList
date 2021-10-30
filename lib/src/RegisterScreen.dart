import 'package:bot_toast/bot_toast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter03/src/HomeScreen.dart';

class RegisterPage extends StatefulWidget{
  final String title;

  RegisterPage({Key key, this.title}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _RegisterPageState();
  }
}

class _RegisterPageState extends State<RegisterPage>{
  FirebaseAuth firebase_auth_instance = FirebaseAuth.instance;
  FirebaseFirestore firebase_firestore_instance = FirebaseFirestore.instance;
  int _attemps = 0;
  String _email = "";
  String _password = "";
  bool _IsHidingPassword = true;

  void _increment_attemps () {
    //this._email = _EmailTextFieldController.text.toString();
    //this._password = _PasswordTextFieldController.text.toString();
    var email = _EmailTextFieldController.text.toString();
    var password = _PasswordTextFieldController.text.toString();
    setState(() {
      _EmailTextFieldController.clear();
      _PasswordTextFieldController.clear();
    });
    print("$_email - $_password");
    if (this._attemps >= 2){
      print("you reached maximum attemps");
      ShowDialog();
    }
    else{
      if(!(_check_email(email) &&  _check_password(password))) {
        this._attemps++;
        print("attemps = ${_attemps}");
      }
      else{
        print("you are logged in");
        Navigator.of(context).pushReplacement(
            MaterialPageRoute<void>(
              builder: (BuildContext context) {return HomeScreen();},
            )
        );
      }
    }
  }

  bool _check_email (String email) {
    //(condition) ? true => do something : false => do something else;
    print("checking email");
    if(email.isNotEmpty && email.contains(".com") && email.contains("@")){
      return true;
    }
    else {
      return false;
    }
  }

  bool _check_password (String password) {
    print("checking password");
    if(password.isNotEmpty && password.length >= 10){
      return true;
    }
    else {
      return false;
    }
  }

  void ShowDialog(){
    showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Ops!'),
          content: Text('you reached the maximum number of attempts'),
          actions: <Widget>[
            TextButton(
                onPressed: () {
                },
                child: Text('Close')),
          ],
        );
      },
      barrierDismissible: false,
    );
  }

  void ToggleShowPassword(){
    setState(() {
      this._IsHidingPassword = !(this._IsHidingPassword);
    });
    print("hiding password: ${this._IsHidingPassword}");
  }

  var _EmailTextFieldController = TextEditingController();
  var _PasswordTextFieldController = TextEditingController();
  var _FullNameTextFieldController = TextEditingController();
  var _PhoneNumberTextFieldController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: null,
      body: MyBody(),
    );
  }

  Widget MyBody() {
    return ListView(
      children: [
        Center(
          child: Padding(
            padding: const EdgeInsetsDirectional.only(start: 10.0, end: 10.0, top: 10.0, bottom: 10.0),
            child: Text("Register",
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsetsDirectional.only(start: 10.0, end: 10.0, top: 10.0, bottom: 10.0),
          child: TextFormField(
            keyboardType: TextInputType.name,
            decoration: const InputDecoration(
              labelText: 'Full Name',
            ),
            cursorHeight: 30,
            controller: _FullNameTextFieldController,
          ),
        ),
        Padding(
          padding: const EdgeInsetsDirectional.only(start: 10.0, end: 10.0, top: 10.0, bottom: 10.0),
          child: TextFormField(
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(
              labelText: 'Email',
            ),
            cursorHeight: 30,
            controller: _EmailTextFieldController,
          ),
        ),
        Padding(
          padding: const EdgeInsetsDirectional.only(start: 10.0, end: 10.0, top: 10.0, bottom: 10.0),
          child: TextFormField(
            keyboardType: TextInputType.text,
            obscureText: _IsHidingPassword,
            decoration: InputDecoration(
              labelText: 'Password',
              suffixIcon: IconButton(icon: Icon(Icons.visibility), onPressed: ToggleShowPassword),
            ),
            cursorHeight: 30,
            controller: _PasswordTextFieldController,
          ),
        ),
        Padding(
          padding: const EdgeInsetsDirectional.only(start: 10.0, end: 10.0, top: 10.0, bottom: 10.0),
          child: TextFormField(
            keyboardType: TextInputType.phone,
            decoration: const InputDecoration(
              labelText: 'Phone Number',
            ),
            cursorHeight: 30,
            controller: _PhoneNumberTextFieldController,
          ),
        ),
        Center(
          child: Padding(
              padding: const EdgeInsetsDirectional.only(start: 10.0, end: 10.0, top: 10.0, bottom: 10.0),
              child: Container(
                width: 160,
                height: 50,
                clipBehavior: Clip.antiAliasWithSaveLayer,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.0),
                    color: Color.fromRGBO(106, 117, 207, 1)
                ),
                child: RaisedButton(onPressed: _RegisterUser,
                    elevation: 0,
                    focusElevation: 1,
                    highlightElevation: 1,
                    hoverElevation: 1,
                    clipBehavior:  Clip.antiAliasWithSaveLayer,
                    color: Colors.transparent,
                    textColor: Colors.white,
                    child: Center(
                        child: Text("Register",textAlign: TextAlign.center, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold))
                    )
                ),
              )
          ),
        ),
        Center(
          child: Padding(
            padding: const EdgeInsetsDirectional.only(start: 10.0, end: 10.0, top: 10.0, bottom: 10.0),
            child: GestureDetector(
              child: Text("Get Back To Login",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              onTap: (){
                Navigator.pop(context);
              },
            ),
          ),
        ),
      ],

    );
  }

  _RegisterUser() async {
    String email = _EmailTextFieldController.text.toString();
    String password = _PasswordTextFieldController.text.toString();
    if(_check_email(email) && _check_password(password)){
      print("email and password are checked");
      print("registration in progress");
      try {
        await firebase_auth_instance.createUserWithEmailAndPassword(email: email, password: password);
        await firebase_firestore_instance.collection('users').doc(firebase_auth_instance.currentUser.uid.toString()).set(
            {
              'fullname': _FullNameTextFieldController.text.toString(),
              'email' : _EmailTextFieldController.text.toString(),
              'phone number' : _PhoneNumberTextFieldController.text.toString()
            }
        );
        firebase_auth_instance.signOut();
        setState(() {
          _EmailTextFieldController.clear();
          _PasswordTextFieldController.clear();
          _FullNameTextFieldController.clear();
          _PhoneNumberTextFieldController.clear();
        });
        String message = "Registration Was Successful";
        BotToast.showSimpleNotification(title: message, subTitle: "you can log in from the login page");
      }
      on FirebaseAuthException catch (exception) {
        if (exception.code == 'weak-password') {
          print('The password provided is too weak.');
          String message = "Registration Was Unsuccessful";
          BotToast.showSimpleNotification(title: message, subTitle: "please use a more strong password");
        }
        else if (exception.code == 'email-already-in-use') {
          print('The account already exists for that email.');
          String message = "Registration Was Unsuccessful";
          BotToast.showSimpleNotification(title: message, subTitle: "this user is already registered!");
        }
      }
    }
    else {
      print('password or email is invalid');
      String message = "Registration Was Unsuccessful";
      BotToast.showSimpleNotification(title: message, subTitle: "please check your email & password");
    }
  }

}
import 'package:bot_toast/bot_toast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter03/src/HomeScreen.dart';
import 'package:flutter03/src/RegisterScreen.dart';

class LoginPage extends StatefulWidget{
  final String title;

  LoginPage({Key key, this.title}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _LoginPageState();
  }
}

class _LoginPageState extends State<LoginPage>{
  FirebaseAuth _firebase_auth_instance = FirebaseAuth.instance;
  FirebaseFirestore _firebase_firestore_instance = FirebaseFirestore.instance;
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
    if(password.isNotEmpty && password.length >= 8){
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: null,
      body: MyBody(),
    );
  }

  Widget MyAppbar(){
    return AppBar(
      title: Text("Login Page"),
      centerTitle: true,
      backgroundColor: Colors.amber,
      actions: [
        IconButton(icon: Icon(Icons.settings), onPressed: (){})
      ],
    );
  }

  Widget MyBody() {
    return ListView(
      children: [
        Center(
          child: Padding(
            padding: const EdgeInsetsDirectional.only(start: 10.0, end: 10.0, top: 10.0, bottom: 10.0),
            child: Text("Login",
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsetsDirectional.only(start: 10.0, end: 10.0, top: 10.0, bottom: 10.0),
          child: TextFormField(
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
            obscureText: _IsHidingPassword,
            decoration: InputDecoration(
              labelText: 'Password',
              suffixIcon: IconButton(icon: Icon(Icons.visibility), onPressed: ToggleShowPassword),
            ),
            cursorHeight: 30,
            controller: _PasswordTextFieldController,
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
                child: RaisedButton(onPressed: _LoginUser,
                    elevation: 0,
                    focusElevation: 1,
                    highlightElevation: 1,
                    hoverElevation: 1,
                    clipBehavior:  Clip.antiAliasWithSaveLayer,
                    color: Colors.transparent,
                    textColor: Colors.white,
                    child: Center(
                        child: Text("Login",textAlign: TextAlign.center, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold))
                    )
                ),
              )
          ),
        ),
        Center(
          child: Padding(
            padding: const EdgeInsetsDirectional.only(start: 10.0, end: 10.0, top: 10.0, bottom: 10.0),
            child: Text("Forgot Password?",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
        ),
        Center(
          child: Padding(
            padding: const EdgeInsetsDirectional.only(start: 10.0, end: 10.0, top: 10.0, bottom: 10.0),
            child: GestureDetector(
              child: Text("Want To Register?",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              onTap: (){
                Navigator.push(context, MaterialPageRoute(
                    builder: (context) => RegisterPage()
                ));
              },
            ),
          ),
        ),
      ],

    );
  }

  void _LoginUser() async {
    var current_user_id = null;
    await _firebase_auth_instance.signInWithEmailAndPassword(
        email: _EmailTextFieldController.text.toString(),
        password: _PasswordTextFieldController.text.toString());
    await _firebase_firestore_instance.collection('users').doc(_firebase_auth_instance.currentUser.uid).get()
        .then((firestore_data) {
          print(firestore_data.data().toString());
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => HomeScreen())
          );
          BotToast.showSimpleNotification(title: "Login is Succesful", subTitle: "Welcome To Your Profile");
        }
    );
  }

}
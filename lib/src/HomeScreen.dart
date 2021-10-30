import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter03/src/LoginScreen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return MyScaffold();
  }

  Widget MyScaffold() {
    return Scaffold(appBar: AppBar(), drawer: MyDrawer(), body: MyBody());
  }

  Widget MyBody() {
    return ListView(
      children: [
        Container(
          height: MediaQuery.of(context).size.height / 2,
          width: MediaQuery.of(context).size.width,
          child: Center(
            child: Image.asset('assets/images/flutter5786.jpg'),
          ),
        ),
        Container(
          height: MediaQuery.of(context).size.height / 2,
          width: MediaQuery.of(context).size.width,
          child: Center(
            child: Image(
              image: NetworkImage(
                  'https://www.pngrepo.com/download/306062/flutter.png'),
              fit: BoxFit.fitWidth,
            ),
          ),
        ),
      ],
    );
  }

  Widget MyDrawer() {
    return Drawer(
      child: ListView(
        children: [
          ListTile(
            title: Text("Home"),
            onTap: () {},
          ),
          ListTile(
            title: Text("Setting"),
            onTap: () {},
          ),
          ListTile(
            title: Text("LogOut"),
            onTap: LogOut,
          ),
        ],
      ),
    );
  }

  LogOut() async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => LoginPage()));
  }
}

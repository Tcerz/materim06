import 'package:flutter/material.dart';
import 'package:materim06/M07/login_screen.dart';
import 'package:materim06/M07/signup_screen.dart';
import 'package:materim06/M07/auth.dart';
import 'package:materim06/M07/home.dart';

class LaunchScreen extends StatefulWidget {
  @override
  _LaunchScreenState createState() => _LaunchScreenState();
}

class _LaunchScreenState extends State<LaunchScreen> {
  @override
  void initState() {
    super.initState();
    Auth auth = Auth();
    auth
        .getUSer()
        .then((user) {
          MaterialPageRoute route;
          if (user != null) {
            route = MaterialPageRoute(
              builder: (context) => HomeScreen(user.uid),
            );
          } else {
            route = MaterialPageRoute(builder: (context) => LoginScreen());
          }
          Navigator.pushReplacement(context, route);
        })
        .catchError((err) => print(err));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}

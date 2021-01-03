import 'package:flutter/material.dart';
import 'package:new_project/view/login.dart';
import 'package:new_project/view/signin.dart';
import 'package:new_project/view/signup.dart';

class Authenticate extends StatefulWidget {
  @override
  _AuthenticateState createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {
  bool showSignIn = true;

  void toggleView(){
    setState(() {
      showSignIn = !showSignIn;
    });
  }
  @override
  Widget build(BuildContext context) {
    if(showSignIn){
      return Login(toggleView);
    }else{
      return SignUp(toggleView);
    }
  }
}





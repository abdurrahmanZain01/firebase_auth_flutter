import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:new_project/services/Auth.dart';
import 'package:new_project/services/Authenticate.dart';

Widget appBarMain(BuildContext context){
  return AppBar(
    backgroundColor: Color(0xff1b243b),
    title: Text("HiApps", style: TextStyle(color: Colors.white70, fontSize: 17),),
  );
}

Widget appBarChat(BuildContext context){
  AuthMethod authMethod = new AuthMethod(FirebaseAuth.instance);
  return AppBar(
    backgroundColor: Color(0xff1b243b),
    title: Text("HiApps", style: TextStyle(color: Colors.white70, fontSize: 17),
    ),
    actions: <Widget>[
      GestureDetector(
        onTap: (){
          authMethod.signOut();
          Navigator.pushReplacement(context, MaterialPageRoute(
            builder: (context) => Authenticate()
          ));
        },
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 15),
            child: Icon(Icons.exit_to_app)
        ),
      ),
    ],
  );
}

InputDecoration textFieldDecoration(String hintText){
  return InputDecoration(
      hintText: hintText,
      hintStyle: TextStyle(color: Colors.white70
      ),
      focusedBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.white70),
      ),
      enabledBorder: UnderlineInputBorder(
        borderSide: BorderSide(
            color: Colors.white70
        ),
      )
  );
}

TextStyle simpleTextFieldDecoration(){
  return TextStyle(
    color: Colors.white70,
        fontSize: 16
  );
}
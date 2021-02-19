import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:new_project/services/Auth.dart';
import 'package:new_project/services/Authenticate.dart';
import 'package:new_project/view/ProfilePage.dart';
import 'package:new_project/view/chatRoomPage.dart';
import 'package:new_project/view/searchPage.dart';

Widget appBarMain(BuildContext context, String a){
  return AppBar(
    backgroundColor: Color(0xff1b243b),
    title: Text(a, style: TextStyle(color: Colors.white70, fontSize: 17),
    ),
  );
}

Widget appBarProfile(BuildContext context){
  return AppBar(
    backgroundColor: Color(0x00000000),
    title: Text('profile', style: TextStyle(color: Colors.white70, fontSize: 17),
    ),
    actions: <Widget>[],
  );
}

Widget appBarChat(BuildContext context, String a){
  AuthMethod authMethod = new AuthMethod(FirebaseAuth.instance);
  return AppBar(
    backgroundColor: Color(0xff1b243b),
    title: Text(a, style: TextStyle(color: Colors.white70, fontSize: 17),
    ),
    actions: <Widget>[
      GestureDetector(
        onTap: (){
          Navigator.push(context, MaterialPageRoute(
              builder: (context) => Search()
          ));
        },
        child: Container(
            padding: EdgeInsets.symmetric(horizontal: 15),
            child: Icon(Icons.search)
        ),
      ),
      GestureDetector(
        onTap: (){},
        child: PopupMenuButton(
          offset: Offset(0, 100),
          color: Color(0xff0C2357),
          padding: EdgeInsets.symmetric(vertical: 50),
          itemBuilder: (context) =>[
            PopupMenuItem(
                child: Column(
              children: <Widget>[
                GestureDetector(
                  onTap: (){
                    Navigator.pushReplacement(context, MaterialPageRoute(
                        builder: (context) => ProfilePage()
                    ));
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 15),
                    child: Row(children: <Widget>[
                      Icon(Icons.person, color: Colors.white70,),
                      SizedBox(width: 2,),
                      Text("profile", style: TextStyle(color: Colors.white70, fontSize: 15),)
                    ],
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: (){
                    authMethod.signOut();
                    Navigator.pushReplacement(context, MaterialPageRoute(
                        builder: (context) => Authenticate()
                    ));
                  },
                  child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 15),
                      child: Row(children: <Widget>[
                        Icon(Icons.exit_to_app, color: Colors.white70,),
                        SizedBox(width: 2,),
                        Text("exit", style: TextStyle(color: Colors.white70, fontSize: 15),)
                      ],
                  ),
                ),
                ),

              ],
            )
            )
          ],
          child: Icon(Icons.more_vert,size: 28,),
        )
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

TextStyle messageTextStyle(){
  return TextStyle(
    fontSize: 20,
    foreground: Paint()
      ..shader = LinearGradient(colors: <Color>[
        Colors.red,
        Colors.yellow,
      ],).createShader(Rect.fromLTWH(35, 0, 25, 0))
  );
}

Widget appBarConversation(BuildContext context, String username){
  return AppBar(
    backgroundColor: Color(0xff1b243b),
    title: Text(username, style: TextStyle(color: Colors.white70, fontSize: 17),),
  );
}


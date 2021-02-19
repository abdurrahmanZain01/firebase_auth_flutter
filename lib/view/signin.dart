import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:new_project/services/Auth.dart';
import 'package:new_project/services/Helper.dart';
import 'package:new_project/services/database.dart';
import 'package:new_project/view/chatRoomPage.dart';
import 'package:new_project/view/searchPage.dart';
import 'package:new_project/view/signup.dart';
import 'package:new_project/widgets/widget.dart';
import 'package:fluttertoast/fluttertoast.dart';

class SignIn extends StatefulWidget {
  final Function toggle;
  SignIn(this.toggle);

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  bool isLoading = false;
  AuthMethod _authMethod = new AuthMethod(FirebaseAuth.instance);
  DatabaseMethods databaseMethods = new DatabaseMethods();
  QuerySnapshot snapshot;
  final formKey = GlobalKey<FormState>();

  TextEditingController emailController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();

  signMeIn(){
    if(formKey.currentState.validate()){
      HelperFunctions.saveUserEmailSharedpreferences(emailController.text);
      Fluttertoast.showToast(msg: 'data saved!' + emailController.text, toastLength: Toast.LENGTH_LONG);
      print("pertama"+emailController.text);

      setState(() {
        isLoading = true;
      });

      databaseMethods.getUserCredentials(emailController.text)
      .then((val){
        snapshot = val;
        /// saving email into the shared preferences
        HelperFunctions.saveUsernameSharedpreferences(snapshot.docs[0].data()['username']);
        print('username '+snapshot.docs[0].data()['username']);
      });
      _authMethod.loginWithEmailAndPassword(emailController.text,
          passwordController.text).then((val){
        HelperFunctions.saveUserLoggedInSharedpreferences(true);
        Navigator.pushReplacement(context, MaterialPageRoute(
            builder: (context) => ChatRoomPage()
        ));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarMain(context,"login"),
      resizeToAvoidBottomPadding: false,
      body: isLoading ? Container(
        child: Center(
          child: CircularProgressIndicator(),)):Container(
            alignment: Alignment.center,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                 Form(
                   key: formKey,
                     child: Column(
                   children: <Widget>[
                     TextFormField(
                       validator: (val){
                         return RegExp(r"^[a-zA-z0-9.a-zA-z0-9.!#$%&'*+-/=?^_'{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                             .hasMatch(val) ? null : "Please Enter Correct Email";
                         },
                         controller: emailController,
                         style: simpleTextFieldDecoration(),
                         decoration: textFieldDecoration("Email")
                     ),
                     TextFormField(
                         obscureText: true,
                         validator: (val){
                           return val.length > 6 ? null : "Please provide password more than 6 characters";
                         },
                         controller: passwordController,
                         style: simpleTextFieldDecoration(),
                         decoration: textFieldDecoration("Password")
                     ),
                   ],
                 )),
                    SizedBox(
                      height: 8 ,
                    ),
                    Container(
                      alignment: Alignment.bottomRight,
                      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: Text("forgot password", style: simpleTextFieldDecoration(),)
                    ),
                    SizedBox(
                      height: 8 ,
                    ),
                    GestureDetector(
                      onTap: (){
                        signMeIn();
                      },
                      child: Container(
                        alignment: Alignment.center,
                        width: MediaQuery.of(context).size.width,
                        padding: EdgeInsets.symmetric(vertical: 20),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(colors: [
                            const Color(0xff34346e),
                            const Color(0xff343479)
                          ]),
                          borderRadius: BorderRadius.circular(30)
                        ),
                        child: Text("Sign In", style: TextStyle(
                          color: Colors.white70,
                          fontSize: 17
                        ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20 ,
                    ),
                    Container(
                      alignment: Alignment.center,
                      width: MediaQuery.of(context).size.width,
                      padding: EdgeInsets.symmetric(vertical: 20),
                      decoration: BoxDecoration(
                          gradient: LinearGradient(colors: [
                            const Color(0xff34349a),
                            const Color(0xff3434b8)
                          ]),
                          borderRadius: BorderRadius.circular(30)
                      ),
                      child: Text("Sign In with Google", style: TextStyle(
                          color: Colors.white70,
                          fontSize: 17
                      ),
                      ),
                    ),
                    SizedBox(
                      height: 10 ,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        GestureDetector(
                          onTap: (){
                            // widget.toggle();
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(vertical: 17),
                            child: Text("Don't have account? ",style: TextStyle(
                              color: Colors.white70,
                              fontSize: 14
                            ),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: (){
                            // widget.toggle();
                            Navigator.push(context, new MaterialPageRoute(builder: (context) => SignUp(widget.toggle)));
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(vertical: 8),
                            child: new Text(" Register Now", style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                            ),
                            ),
                          ),

                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
    );
  }
}

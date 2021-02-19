import 'dart:async';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:new_project/services/Auth.dart';
import 'package:new_project/services/Helper.dart';
import 'package:new_project/services/database.dart';
import 'package:new_project/view/searchPage.dart';
import 'package:new_project/view/signin.dart';
import 'package:new_project/widgets/widget.dart';
import 'package:flutter/cupertino.dart';


class SignUp extends StatefulWidget {
  final Function toggle;
  SignUp(this.toggle);

  @override
  _SignUpState createState() => _SignUpState();

}

class _SignUpState extends State<SignUp> {
  String username, email, phone, nama;
  bool isLoading = false;
  User user;
  FirebaseAuth auth = FirebaseAuth.instance;
  AuthMethod _authMethod = new AuthMethod(FirebaseAuth.instance);
  DatabaseMethods database = new DatabaseMethods();
  QuerySnapshot querySnapshot;
  var queryResultSet = [];
  var tempSearchStore = [];
  DatabaseMethods databaseMethod = new DatabaseMethods();

  Stream chatRoomStream;

  final formKey = GlobalKey<FormState>();
  TextEditingController usernameController = new TextEditingController();
  TextEditingController phoneNumberController = new TextEditingController();
  TextEditingController emailController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();

  signMeUp() async{
    if(formKey.currentState.validate()){
      Map<String,String> mapUserInfo = {
        "username" : usernameController.text,
        "phoneNumber" : phoneNumberController.text,
        "email" : emailController.text
      };
      
      HelperFunctions.saveUsernameSharedpreferences(usernameController.text);
      HelperFunctions.saveUserEmailSharedpreferences(emailController.text);
      try{
        await auth.createUserWithEmailAndPassword(email: emailController.text, password: passwordController.text).then((value) => {
        HelperFunctions.saveUserLoggedInSharedpreferences(true),
        database.uploadUserInfo(mapUserInfo),
        setState(() {
          isLoading = true;
        }),
        Navigator.pushReplacement(context, MaterialPageRoute(
            builder: (context) => VerifyScreen())),
        });
      }on FirebaseAuthException catch(e){
        Fluttertoast.showToast(msg: "email has already taken", toastLength: Toast.LENGTH_LONG);
      }catch (e){
        print("this is your error" + e.toString());
      }
    }
  }

  getUserCredentials()async{
    databaseMethod.checkUsername(usernameController.text, emailController.text,
        phoneNumberController.text).then((value){
       setState(() {
         chatRoomStream = value;
         print("ini dia $value");
       });
    });
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      body: isLoading ? Container(
          child: Center(
            child: CircularProgressIndicator(),)) : Container(
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
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: Container(
                              child: TextFormField(
                                  validator: (val){
                                    return val.isEmpty || val.length < 2 ?
                                    "please provide a valid username" : null;
                                  },
                                  controller: usernameController,
                                  style: simpleTextFieldDecoration(),
                                  decoration: textFieldDecoration("Username")
                              ),
                            ),
                          ),
                          // GestureDetector(
                          //   onTap: initiateSearch(),
                          // )
                        ],

                      ),
                      TextFormField(
                        validator: (val){
                          return val.isEmpty || val.length < 10 ?
                              "please privide a correct phone number" : null;
                        },
                          controller: phoneNumberController,
                          style: simpleTextFieldDecoration(),
                          decoration: textFieldDecoration("Phone Number")
                      ),
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
              ),
                ),
                SizedBox(
                  height: 50 ,
                ),
                GestureDetector(
                  onTap: (){
                    getUserCredentials();
                    signMeUp();
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
                    child: Text("Sign Up", style: TextStyle(
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
                  child: Text("Sign Up with Google", style: TextStyle(
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
                    Text("Already have account? ",style: TextStyle(
                        color: Colors.white70,
                        fontSize: 14
                    ),
                    ),
                    GestureDetector(
                      onTap: (){

                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => SignIn(widget.toggle)));
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 8),
                        child: new Text("  SignIn Now", style: TextStyle(
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

class VerifyScreen extends StatefulWidget {
  @override
  _VerifyScreenState createState() => _VerifyScreenState();
}

class _VerifyScreenState extends State<VerifyScreen> {
  final auth = FirebaseAuth.instance;
  User user;
  Timer timer;

  @override
  void initState() {
    // TODO: implement initState
    user = auth.currentUser;
    user.sendEmailVerification();

    Timer.periodic(Duration(seconds: 5), (timer) {
      checkEmailVerify();
    });
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    timer.cancel();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text("An email has been sent to ${user.email}, please check your inbox or spam to verify your account"),
      ),
    );
  }

  Future<void> checkEmailVerify() async{
    user = auth.currentUser;
    await user.reload();
    if(user.emailVerified){
      timer.cancel();
      Navigator.pushReplacement(context, MaterialPageRoute(
          builder: (context) => Search()));
    }
  }
}



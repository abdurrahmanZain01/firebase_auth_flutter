import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:new_project/services/Auth.dart';
import 'package:new_project/view/chatRoomsPage.dart';
import 'package:new_project/view/conversationPage.dart';
import 'package:new_project/widgets/widget.dart';
import 'package:flutter/cupertino.dart';

class SignUp extends StatefulWidget {
  final Function toggle;
  SignUp(this.toggle);

  @override
  _SignUpState createState() => _SignUpState();

}

class _SignUpState extends State<SignUp> {
  bool isLoading = false;

  AuthMethod _authMethod = new AuthMethod(FirebaseAuth.instance);

  final formKey = GlobalKey<FormState>();
  TextEditingController UsernameController = new TextEditingController();
  TextEditingController PhoneNumberController = new TextEditingController();
  TextEditingController EmailController = new TextEditingController();
  TextEditingController PasswordController = new TextEditingController();

  signMeUp(){
    if(formKey.currentState.validate()){
        setState(() {
          isLoading = true;
        });
        _authMethod.RegsiterEmailAndPassword(EmailController.text, PasswordController.text).then((val){
            // print("${val.uid}");
            Navigator.pushReplacement(context, MaterialPageRoute(
                builder: (context) => ChatRoom()));
        });
    }
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
                      TextFormField(
                        validator: (val){
                          return val.isEmpty || val.length < 2 ?
                          "pleade provide a valid username" : null;
                        },
                          controller: UsernameController,
                          style: simpleTextFieldDecoration(),
                          decoration: textFieldDecoration("Username")
                      ),
                      TextFormField(
                        validator: (val){
                          return val.isEmpty || val.length < 10 ?
                              "please privide a correct phone number" : null;
                        },
                          controller: PhoneNumberController,
                          style: simpleTextFieldDecoration(),
                          decoration: textFieldDecoration("Phone Number")
                      ),
                      TextFormField(
                        validator: (val){
                          return RegExp(r"^[a-zA-z0-9.a-zA-z0-9.!#$%&'*+-/=?^_'{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                              .hasMatch(val) ? null : "Please Enter Correct Email";
                        },
                          controller: EmailController,
                          style: simpleTextFieldDecoration(),
                          decoration: textFieldDecoration("Email")
                      ),
                      TextFormField(
                        obscureText: true,
                          validator: (val){
                            return val.length > 6 ? null : "Please provide password more than 6 characters";
                          },
                          controller: PasswordController,
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
                        widget.toggle();
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

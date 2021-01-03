import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:new_project/services/Auth.dart';
import 'package:new_project/view/chatRoomsPage.dart';
import 'package:new_project/view/signup.dart';
import 'package:new_project/widgets/widget.dart';
import 'package:provider/provider.dart';

class Login extends StatelessWidget {
  final Function toggle;
  Login(this.toggle);
  bool isLoading = false;
  final formKey = GlobalKey<FormState>();

  AuthMethod _authMethod = new AuthMethod(FirebaseAuth.instance);

  TextEditingController EmailController = new TextEditingController();
  TextEditingController PasswordController = new TextEditingController();

// void _LoginState(BuildContext context) {
//     if (formKey.currentState.validate()) {
//       _authMethod.LoginWithEmailAndPassword(EmailController.text,
//           PasswordController.text).then((val) {
//         Navigator.pushReplacement(context, MaterialPageRoute(
//             builder: (context) => ChatRoom()
//         ));
//       });
//     }
// }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarMain(context),
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
                    context.read<AuthMethod>().loginWithEmailAndPassword(EmailController.text,  PasswordController.text);
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
                        // Navigator.push(context, new MaterialPageRoute(builder: (context) => SignUp()));
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



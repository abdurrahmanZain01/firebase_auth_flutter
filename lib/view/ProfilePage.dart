import 'package:flutter/material.dart';
import 'package:new_project/services/Helper.dart';
import 'package:new_project/widgets/widget.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarProfile(context),
      body: Column(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              gradient: LinearGradient(
                  end: Alignment.bottomCenter,
                  begin: Alignment.topCenter,
                  colors: [Color(0xff38a3a5),Color(0xff0091ad)]
              )
            ),
            child: Container(
              width: double.infinity,
              height: 350.0,
              child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    CircleAvatar(backgroundImage:  NetworkImage(
                      "https://www.rd.com/wp-content/uploads/2017/09/01-shutterstock_476340928-Irina-Bg.jpg",
                    ), radius: 50.0,),
                    SizedBox(height: 10,),
                    Text(HelperFunctions.myUsername,style: TextStyle(fontSize: 20,color: Colors.white70),),
                    SizedBox(height: 10.0,),
                    Text(HelperFunctions.myEmail,style: TextStyle(fontSize: 20,color: Colors.white70),),
                    SizedBox(height: 50,),
                    Card(
                      margin: EdgeInsets.symmetric(horizontal: 20,vertical: 5),
                      clipBehavior: Clip.antiAlias,
                      color: Colors.white,
                      elevation: 5,
                      child: Padding(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 22),
                      child: Row(
                        children: <Widget>[

                        ],
                      ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
          Container(),
        ],
      ),
    );
  }
}

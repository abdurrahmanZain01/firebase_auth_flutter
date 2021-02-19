import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:new_project/services/Auth.dart';
import 'package:new_project/services/Helper.dart';
import 'package:new_project/services/database.dart';
import 'package:new_project/view/ContactPage.dart';
import 'package:new_project/view/conversationPage.dart';
import 'package:new_project/view/searchPage.dart';
import 'package:new_project/widgets/widget.dart';

class ChatRoomPage extends StatefulWidget {
  @override
  _ChatRoomPageState createState() => _ChatRoomPageState();
}

class _ChatRoomPageState extends State<ChatRoomPage> {
  int page = 0;
  ///mendefinisikan halaman
  final Room _chatRoomPage = new Room();
  final Search _search = new Search();
  final ContactPage _contactPage = new ContactPage();

  Widget mainPage = new Room();

  Widget PageRoute(int page){
    switch(page){
      case 0:
        return _chatRoomPage;
        break;
      case 1:
        return _search;
        break;
      case 2:
        return _contactPage;
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CurvedNavigationBar(backgroundColor: Colors.indigo,
          items: <Widget>[
            Icon(Icons.chat, size: 30, color: Colors.white70,),
            Icon(Icons.search, size: 25,color: Colors.white70,),
            Icon(Icons.contacts, size: 30, color: Colors.white70,)
          ],
      height: 50,color: Color(0xff1b243b),
      onTap: (index){
        page = index;
        setState(() {
          mainPage = PageRoute(page);
        });
      },
      ),
      body: mainPage,
    );
  }
}

///the visual of list chatRoom
class ListChat extends StatelessWidget {
  final String myUsername;
  final String chatRoomId;
  ListChat(this.myUsername, this.chatRoomId);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Navigator.push(context,  PageRouteBuilder(transitionDuration: Duration(milliseconds: 300),
            transitionsBuilder: (context,animation,animationTime,child){
              animation = CurvedAnimation(parent: animation, curve: Curves.easeIn);
              return ScaleTransition(scale: animation,
                alignment: Alignment.center,
                child: child,
              );
            },
            pageBuilder: (context, animation,animationTime){
              return ConversationPage(
                  chatRoomId,HelperFunctions.myUsername,myUsername
              );
            }));
      },
      child: Container(
        height: 50,
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        decoration: BoxDecoration(
          border: Border.all(
            color: Color(0xff1b2450),
            width: 1
          )
        ),
        child: Row(
          children: [
            Container(
              alignment: Alignment.center,
              height: 40,
              width: 40,
              decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(40)
              ),
              child: Text("${myUsername.substring(0,1)}"),
            ),
            SizedBox(width: 8,),
            Text(myUsername, style: simpleTextFieldDecoration(),)
          ],
        ),
      ),
    );
  }
}

///create title of chatRoom in firestore
createChatRoomId(String username, String ownUsername){

  if(username.substring(0,1).codeUnitAt(0) >  ownUsername.substring(0,1).codeUnitAt(0)){
    return "$ownUsername\_$username";
  }else{
    return "$username\_$ownUsername";
  }
}

class Room extends StatefulWidget {
  @override
  _RoomState createState() => _RoomState();
}

class _RoomState extends State<Room> {
  Stream chatRoomsStream;
  String myUsername = '';
  AuthMethod authMethod = new AuthMethod(FirebaseAuth.instance);
  DatabaseMethods databaseMethods = new DatabaseMethods();

  ///load the chat and put in list
  Widget chatRoomsList(){
    return StreamBuilder(stream: chatRoomsStream,
      builder: (context, snapshot){
        return snapshot.hasData ? ListView.builder(
            itemCount: snapshot.data.documents.length,
            itemBuilder: (context, index){
              return ListChat(
                  snapshot.data.documents[index].data()["chatRoomId"]
                      .toString().replaceAll("_", "").replaceAll(myUsername, ""),
                  snapshot.data.documents[index].data()["chatRoomId"]
              );
            }) : Container();
      },);
  }

  @override
  void initState() {
    getUserCredentials();
    super.initState();
  }

  ///get myuser credentials from shared preferences
  ///and load all chatsRoom
  getUserCredentials() async{
    HelperFunctions.myUsername = await HelperFunctions.getUsernameKeySharedpreferences();
    HelperFunctions.myEmail = await HelperFunctions.getUserEmailSharedpreferences();
    myUsername = HelperFunctions.myUsername;
    databaseMethods.getChatRooms(HelperFunctions.myUsername).then((value){
      setState(() {
        chatRoomsStream = value;
      });
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarChat(context,HelperFunctions.myUsername),
      body: chatRoomsList(),
    );
  }
}




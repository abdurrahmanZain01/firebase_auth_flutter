import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:new_project/services/Helper.dart';
import 'package:new_project/view/conversationPage.dart';
import 'package:new_project/widgets/widget.dart';
import 'package:new_project/services/database.dart';


class Search extends StatefulWidget {
  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  //new method
  String email = '';
  String myusername = '';
  String frindName = '';
  var queryResultSet = [];
  var tempSearchStore = [];
  DatabaseMethods databaseMethod = new DatabaseMethods();
  final TextEditingController searchController = new TextEditingController();

  QuerySnapshot searchSnapshot;
  Stream chatRoomsStream;

  Widget chatRoomsList(){
    return StreamBuilder(stream: chatRoomsStream,
      builder: (context, snapshot){
        return snapshot.hasData ? ListView.builder(
            itemCount: snapshot.data.documents.length,
            itemBuilder: (context, index){
              return ListChat(
                  snapshot.data.documents[index].data()["chatRoomId"]
              );
            }) : Container();
      },);
  }

  Widget searchList(){
    return searchSnapshot != null ? ListView.builder(
        itemCount: searchSnapshot.docs.length,
        shrinkWrap: true,
        itemBuilder: (context, index){
          return searchValue(
            usrname: searchSnapshot.docs[index].data()['username'],
            email: searchSnapshot.docs[index].data()['email'],
            phoneNumber: searchSnapshot.docs[index].data()['phoneNumber'],
          );
        }) : Container();
  }




  initiateSearch(){
    databaseMethod.getUserByUsername(searchController.text).then((val){
      // print("search" + val);
      setState(() {
        searchSnapshot = val;
      });
    });
  }

  inisiasiSearch(value){
    if(value.length == 0){
      setState(() {
        queryResultSet = [];
        tempSearchStore = [];
      });
    }

    //to change the input to lowercase
    var loweredValue =
        value.subtString(0,1).toLowerCase() + value.subString(1);

    if(queryResultSet.length == 0 && value.length == 1){
      DatabaseMethods().searchByUsername(value).then((QuerySnapshot docs){
        for(int i = 0; i < docs.docs.length; i++){
          queryResultSet.add(docs.docs[i].data());
        }
      });
    }else{
      tempSearchStore = [];
      queryResultSet.forEach((element) {
        if(element['username'].startwith(loweredValue)){
          setState(() {
            tempSearchStore.add(element);
          });
        }
      });
    }
  }

  /// create room for chatting
  startConversation({String username}){
    if(username != myusername){
      String chatRoomId = createChatRoomId(username, myusername);
      List<String> users = [username, myusername];
      Map<String, dynamic> chatRoomMap = {
        "users" : users,
        "chatRoomId" : chatRoomId
      };
      DatabaseMethods().createChatRoom(chatRoomId,chatRoomMap,myusername);
      Navigator.push(context,  PageRouteBuilder(transitionDuration: Duration(milliseconds: 500),
          transitionsBuilder: (context,animation,animationTime,child){
              animation = CurvedAnimation(parent: animation, curve: Curves.easeIn);
              return ScaleTransition(scale: animation,
              alignment: Alignment.center,
              child: child,
              );
          },
          pageBuilder: (context, animation,animationTime){
            return ConversationPage(
                chatRoomId,myusername,username
            );
          }));
    }else{
      Fluttertoast.showToast(msg: 'you cannot massage your self', toastLength: Toast.LENGTH_LONG);

    }
  }

  Widget searchValue({String usrname, String phoneNumber, String email}){
    return GestureDetector(
      onTap: (){
        startConversation(
            username: usrname
        );
      },
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color:  Color(0xff1b2450),
            width: 1
          )
        ),
        child: Row(
          children: [
              Column(
                children:[
                  Text(usrname, style: simpleTextFieldDecoration(),),
                  Text(phoneNumber, style: simpleTextFieldDecoration(),),
                  Text(email, style: simpleTextFieldDecoration(),)
                ],
              ),
          ],
        ),
      ),
    );
  }

  getUserEmail() async{
    databaseMethod.getChatRooms(HelperFunctions.myUsername).then((value){
      setState(() {
        chatRoomsStream = value;
      });
    });
    email = await HelperFunctions.getUserEmailSharedpreferences();
    myusername = await HelperFunctions.getUsernameKeySharedpreferences();
    // Fluttertoast.showToast(msg: email, toastLength: Toast.LENGTH_LONG);
    print("this email "+email);
    return email;
  }

  @override
  void initState() {
    // TODO: implement initState
    initiateSearch();
    getUserEmail();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarChat(context,myusername),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          child: Stack(
            fit: StackFit.loose,
            children: <Widget>[
              Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Container(
                    alignment: Alignment.center,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                        gradient: LinearGradient(colors: [
                          const Color(0xff687184),
                          const Color(0xff687184)
                        ]),
                        borderRadius: BorderRadius.circular(20)
                    ),
                    child: Column(
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Expanded(
                              child: Container(
                                padding: EdgeInsets.only(left: 10),
                                alignment: Alignment.topCenter,
                                child: TextField(
                                  onChanged: (val){
                                    // inisiasiSearch(val);
                                  },
                                  controller: searchController,
                                  decoration: InputDecoration.collapsed(
                                      hintText: "Search and Start Chating",
                                      border: InputBorder.none),
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: initiateSearch(),
                              child: Container(
                                  height: 40,
                                  width: 40,
                                  decoration: BoxDecoration(
                                      gradient: LinearGradient(colors: [
                                        const Color(0x36ffffff),
                                        const Color(0x0fffffff)
                                      ]),
                                      borderRadius: BorderRadius.circular(40)
                                  ),
                                  padding: EdgeInsets.all(12),
                                  child: Icon(Icons.search)),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 10,),
                  // list()
                  searchList(),
                  // chatRoomsList(),
                ],
              ),
            ],
          ),
        ),
      ) ,
    );
  }

  Widget list(){
    return searchSnapshot != null ? GridView.count(
      crossAxisCount: 1,
            crossAxisSpacing: 5,
            padding: EdgeInsets.only(left: 8, right: 8),
            mainAxisSpacing: 5,
            primary: false,
            shrinkWrap: true,
            children: tempSearchStore.map((element){
              return buildResultCard(element);
            }).toList(),
    ): Container();
  }

  Widget buildResultCard(element) {
    return Container(
      child: Row(
        children: [
          Column(
            children:[
              Text(element['username'], style: simpleTextFieldDecoration(),),
              Text(element['email'], style: simpleTextFieldDecoration(),),
              Text(element['phoneNumber'], style: simpleTextFieldDecoration(),)
            ],
          )
        ],
      ),
    );
  }
}


///create chat room id for firebase
createChatRoomId(String username, String ownUsername){

  if(username.substring(0,1).codeUnitAt(0) >  ownUsername.substring(0,1).codeUnitAt(0)){
    return "$ownUsername\_$username";
  }else{
    return "$username\_$ownUsername";
  }
}

class ListChat extends StatelessWidget {
  final String myUsername;
  ListChat(this.myUsername);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: [
          Container(
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
    );
  }
}

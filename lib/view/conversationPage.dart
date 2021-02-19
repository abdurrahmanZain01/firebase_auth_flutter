import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:new_project/services/database.dart';
import 'package:new_project/widgets/widget.dart';

class ConversationPage extends StatefulWidget {
  final String chatRoomId;
  final String myusername;
  final String friendName;
  ConversationPage(this.chatRoomId, this.myusername,this.friendName);
  @override
  _ConversationPageState createState() => _ConversationPageState();
}

class _ConversationPageState extends State<ConversationPage> {
  final ScrollController _scrollController = new ScrollController();
  TextEditingController chatController = new TextEditingController();
  DatabaseMethods databaseMethods = new DatabaseMethods();

  ///stream for get realtime messages
  Stream chatMessagesStream;

  Widget sendMessage(){
    if(chatController.text.isNotEmpty){
      Map<String, dynamic> messageMap = {
        "message" : chatController.text,
        "sendBy" : widget.myusername,
        "time" : DateTime.now().millisecondsSinceEpoch
      };
      databaseMethods.sendMessage(widget.chatRoomId, messageMap);
      print("this is chatRoomId"+widget.chatRoomId);
    }
  }

  Widget chatMessageList(){
    return StreamBuilder(
      stream: chatMessagesStream,
      builder: (context, snapshot){
      return snapshot.hasData ? ListView.builder(
        controller: _scrollController,
        itemCount: snapshot.data.documents.length,
          itemBuilder: (context, index){
          return MessageList(snapshot.data.documents[index].data()['message'],
              snapshot.data.documents[index].data()['sendBy'] == widget.myusername);
          }) : Container();
    }, );
  }

  Widget toBottom(){
    setState(() {
      _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: Duration(milliseconds: 200),
          curve: Curves.easeInOut);
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    databaseMethods.getMessages(widget.chatRoomId).then((val){
      // toBottom();
      setState(() {
        chatMessagesStream = val;
      });
    });
    super.initState();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarConversation(context, widget.friendName),
      body: Container(
        child: Column(
          children: [
            Expanded(
              child: Container(
              child: Stack(
                children: <Widget>[
                  chatMessageList(),
                  ///this for text field
                ],
              ),
          ),
            ),
            Container(
              alignment: Alignment.bottomCenter,
              child: Container(
                padding: EdgeInsets.all(8),
                height: 70,
                color: Colors.black87,
                child: Column(
                  mainAxisSize:  MainAxisSize.min,
                  children: <Widget>[
                    Stack(
                      children: [
                        Container(
                            alignment: Alignment.center,
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                                gradient: LinearGradient(colors : [
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
                                        alignment: Alignment.bottomCenter,
                                        child: TextField(
                                          controller: chatController,
                                          decoration: InputDecoration.collapsed(hintText: "Messages...",
                                              border: InputBorder.none),
                                        ),
                                      ),
                                    ),
                                    GestureDetector(
                                      ///send button
                                      onTap: (){
                                        sendMessage();
                                        toBottom();
                                        chatController.clear();

                                        FocusScopeNode currentFocus = FocusScope.of(context);
                                        if(!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null){
                                          currentFocus.focusedChild.unfocus();
                                        }
                                      },
                                      child: Container(
                                        height: 40,
                                        width: 40,
                                        decoration: BoxDecoration(
                                            gradient: LinearGradient(colors : [
                                              const Color(0xff687184),
                                              const Color(0xff687184)
                                            ]),
                                            borderRadius: BorderRadius.circular(40)
                                        ),
                                        padding: EdgeInsets.all(12),
                                        child: Icon(Icons.send),
                                      ),
                                    )
                                  ],
                                )
                              ],
                            )
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
        ],
        ),
      ),
    );
  }
}

class MessageList extends StatelessWidget {
  final String messageTile;
  final bool isSendByMe;
  MessageList(this.messageTile, this.isSendByMe);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(10),
      padding: EdgeInsets.only(left: isSendByMe ? 0 : 24, right: isSendByMe ? 24 : 0),
      width: MediaQuery.of(context).size.width,
      alignment: isSendByMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 24),
        decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: isSendByMe ? [
                const Color(0xff007EF4),
                const Color(0xff2A75BC)]
                  : [
                const Color(0x1AFFFFFF),
                const Color(0x1AFFFFFF)
              ]),
            borderRadius: isSendByMe ?
              BorderRadius.only(
                topRight: Radius.circular(20),
                topLeft: Radius.circular(20),
                  bottomLeft: Radius.circular(20)
              ):
                BorderRadius.only(
                  topRight: Radius.circular(20),
                  topLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20)
                ),
        ),
        child: Text(messageTile, style: messageTextStyle(),
        ),

      ),
    );
  }
}

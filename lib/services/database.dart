import 'package:cloud_firestore/cloud_firestore.dart';


class DatabaseMethods{
  getUserByUsername(String username)async{
    return await FirebaseFirestore.instance.collection("Users")
        .where("username", isEqualTo: username).get();
  }

  uploadUserInfo(usermap){
    FirebaseFirestore.instance.collection("Users")
        .add(usermap);
  }

  searchByUsername(String username){
    return FirebaseFirestore.instance.collection('Users')
        .where('searchKey', isEqualTo: username.substring(0,1).toLowerCase()).get();
  }

  //create chatRoom
  createChatRoom(String chatRoomId, chatRoomMap, myusername){
    FirebaseFirestore.instance.collection("chatRoom")
        .doc(chatRoomId).set(chatRoomMap).catchError((e){
          print(e.toString());
    });
  }

  //get user credentials
  getUserCredentials(String userEmail)async{
    return await FirebaseFirestore.instance.collection("Users")
        .where("email", isEqualTo: userEmail).get();
  }

  sendMessage(String chatRoomId, messageMap){
    FirebaseFirestore.instance.collection("chatRoom")
        .doc(chatRoomId)
        .collection("chats")
        .add(messageMap).catchError((e){print(e.toString());});
  }

  getMessages(String chatRoomId)async{
    return await FirebaseFirestore.instance.collection("chatRoom")
        .doc(chatRoomId)
        .collection("chats")
        .orderBy("time", descending: false)
        .snapshots();
  }

  getChatRooms(String username)async{
    return await FirebaseFirestore.instance.collection("chatRoom")
        .where("users", arrayContains: username)
        .snapshots();
  }

  checkUsername(String username, email, phoneNumber) async{
    return await FirebaseFirestore.instance.collection("Users")
        .where("username", isEqualTo: username).where("email", isEqualTo: email)
        .where("phoneNumber", isEqualTo: phoneNumber);

  }

  getUsername(String username) async{
    return await FirebaseFirestore.instance.collection("Users")
        .where("username", isEqualTo: username).get();
  }
}
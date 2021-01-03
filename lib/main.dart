import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:new_project/services/Auth.dart';
import 'package:new_project/services/Authenticate.dart';
import 'package:new_project/view/chatRoomsPage.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<AuthMethod>(
          create: (_) => AuthMethod(FirebaseAuth.instance),
        ),
        StreamProvider(
          create: (context) => context.read<AuthMethod>().authStateChanges,)
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
          scaffoldBackgroundColor: Color(0xff1b2430),
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: Cek(),

      ),
    );
  }
}

class Cek extends StatelessWidget {
  const Cek({
    Key key,
}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final firebaseUser = context.watch<User>();
    if(firebaseUser != null){
      return ChatRoom();
    }else{
      return Authenticate();
    }
  }
}




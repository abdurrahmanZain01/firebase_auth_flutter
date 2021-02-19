import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:new_project/services/Auth.dart';
import 'package:new_project/services/Authenticate.dart';
import 'package:new_project/view/chatRoomPage.dart';
import 'package:provider/provider.dart';
import 'package:splashscreen/splashscreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

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
        home: SplashScreenPage(),

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
      return ChatRoomPage();
    }else{
      return Authenticate();
    }
  }
}

class SplashScreenPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    AssetImage assetImage = AssetImage('Assets/Image/logo_transparent.png');
    Image image = Image(image: assetImage);
    return Scaffold(
      body: SplashScreen(
        seconds: 5,
        navigateAfterSeconds: new Cek(),
        backgroundColor:  Color(0xff1b2430),
        title: new Text('by Zain', style: TextStyle(fontSize: 20, color: Color(0xff341199)),),
        image: image,
        photoSize: 100.0,
      ),
    );
  }
}


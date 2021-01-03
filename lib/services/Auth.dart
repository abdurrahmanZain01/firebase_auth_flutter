
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';


class AuthMethod{
  final FirebaseAuth _auth;

  //condition of user exist or not. true : false
  // User _userFromFirebaseUser(FirebaseUser user){
  //   return user!=null ? User(userId: user.uid) : null;
  // }

  // Future signInWithEmailAndPassword(String email, String password) async{
  //   try{
  //     AuthResult result = await _auth.signInWithEmailAndPassword
  //       (email: email, password: password);
  //     FirebaseUser firebaseUser = result.user;
  //     return _userFromFirebaseUser(firebaseUser);
  //   }catch(e){
  //     print(e);
  //   }
  // }

  // Future signUpWithEmailAndPassword(String email, String password) async{
  //   try{
  //     AuthResult result = await _auth.createUserWithEmailAndPassword
  //       (email: email, password: password);
  //     FirebaseUser firebaseUser = result.user;
  //     return _userFromFirebaseUser(firebaseUser);
  //   }catch(e){
  //     print(e.toString());
  //   }
  // }
  AuthMethod(this._auth);

  Stream<User> get authStateChanges => _auth.authStateChanges();

  Future<String> loginWithEmailAndPassword(String email, String password) async{
    try {
      UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email,
          password: password
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      }
    }
  }

Future<String> RegsiterEmailAndPassword(String email, String password) async{
  try {
    UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password
    );
  } on FirebaseAuthException catch (e) {
    if (e.code == 'weak-password') {
      print('The password provided is too weak.');
    } else if (e.code == 'email-already-in-use') {
      print('The account already exists for that email.');
    }
  } catch (e) {
    print(e);
  }
}

  Future resetPass(String email) async{
    try{
      return await _auth.sendPasswordResetEmail(email: email);
    }catch(e){
      print(e.toString());
    }
  }

  Future signOut() async{
    try{
      return await _auth.signOut();
    }catch(e){
      print(e.toString());
    }
  }

  Future<void> initializeDefault() async {
    FirebaseApp app = await Firebase.initializeApp();
    assert(app != null);
    print('Initialized default app $app');
  }
}
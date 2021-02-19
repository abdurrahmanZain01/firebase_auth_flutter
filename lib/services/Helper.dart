import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';

class HelperFunctions{
  static String myUsername = "";
  static String myEmail = "";
  static String sharedPreferencesUserLoggedIn = "ISLOGGEDIN";
  static String sharedPreferencesUsernameKey = "USERNAMEKEY";
  static String sharedPreferencesUserEmailKey = "EMAILKEY";

  //saving data to sharedpreferences
static Future<bool> saveUserLoggedInSharedpreferences(bool isUserLoggedIn) async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return await preferences.setBool(sharedPreferencesUserLoggedIn, isUserLoggedIn);
  }

  static Future<bool> saveUsernameSharedpreferences(String usernameKey) async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return await preferences.setString(sharedPreferencesUsernameKey, usernameKey);
  }

  static Future<bool> saveUserEmailSharedpreferences(String userEmail) async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return await preferences.setString(sharedPreferencesUserEmailKey, userEmail);

  }

  //get data from sharedpreferences
  static Future<bool> getUserLoggedInSharedpreferences() async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return await preferences.getBool(sharedPreferencesUserLoggedIn);
  }

  static Future<String> getUsernameKeySharedpreferences() async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return await preferences.getString(sharedPreferencesUsernameKey);
  }

  static Future<String> getUserEmailSharedpreferences() async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return await preferences.getString(sharedPreferencesUserEmailKey);
  }


}
import 'package:flutter/material.dart';
import 'package:new_project/widgets/widget.dart';

class ContactPage extends StatefulWidget {
  @override
  _ContactPageState createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarMain(context, "contact"),
      body: Container(
        color: Colors.greenAccent,
      ),
    );
  }
}

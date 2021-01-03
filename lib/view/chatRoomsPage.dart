import 'package:flutter/material.dart';
import 'package:new_project/widgets/widget.dart';

class ChatRoom extends StatelessWidget {
  final TextEditingController searchController = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarChat(context),
      body: Container(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(
                alignment: Alignment.center,
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.symmetric(vertical: 20),
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
                          child: TextField(),
                        ),
                        Icon(Icons.search)
                      ],
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ) ,
    );
  }
}

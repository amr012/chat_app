import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _auth = FirebaseAuth.instance;
  final _fireStore = FirebaseFirestore.instance;
  User loggedUser;
  String message;


 void getCurrentUser() async {
    try{
  User user = await _auth.currentUser;
  if(user != null){
    loggedUser = user ;
    print(loggedUser.email);
  }}catch(e){
      print(e);
    }
  }
  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Chat"),
        actions: [
          IconButton(
              icon: Icon(Icons.close),
              onPressed: () {
                _auth.signOut();

                Navigator.pop(context);
              })
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 6),
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(color: Colors.blue)),
              child: Row(
                children: [
                  Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 3),
                        child: TextField(
                    onChanged: (v) {
                      message = v ;
                        print(v);
                    },
                    decoration: InputDecoration(
                          border: InputBorder.none, hintText: "Enter Your Message"),
                  ),
                      )),
                  IconButton(
                    icon: Icon(
                      Icons.send,
                      color: Colors.blue,
                    ),
                    onPressed: () async {
                     await _fireStore.collection("messages").add(
                       {"message" : message , "sender" : loggedUser.email}
                     );
                     print("send");
                    },
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

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
                // _auth.signOut();
                // Navigator.pop(context);
                getStream();
                print(">>>>>>>>>>>"); 

              })
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,

        children: [
          StreamBuilder<QuerySnapshot>(stream: _fireStore.collection("messages").snapshots(),
            builder: (context , snapshot){
               if(snapshot.hasData){
                 final messages = snapshot.data.docs;
                 List<Text> messageWidgets = [];
                 for(var message in messages ){
                   final messageText = message.data();
                   // final messageSender = message.data();
                   final sender = messageText["sender"];
                   final msg    =messageText["message"];

                   final messageWidget = Text("$msg from $sender");
                   messageWidgets.add(messageWidget);
                 }
                 return ListView(children: messageWidgets,);
               }
            },
          ),
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

  Future<void> getMessages() async {
    final messages = await _fireStore.collection("messages").get();
    for(var message in messages.docs){
      print(message.data());
    }
  }

  Future<void> getStream() async {
   await  for (var snapshot in _fireStore.collection("messages").snapshots()){
     for (var message in snapshot.docs){
       print(message.data());
     }
    }
  }
}

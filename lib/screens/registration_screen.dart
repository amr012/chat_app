import 'package:chatapp/screens/chat_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class RegistrationScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<RegistrationScreen> {
  final _auth = FirebaseAuth.instance;
  TextEditingController _userNameController;
  TextEditingController _passwordController;
 String userName;
 String password;
 bool showSpinner = false ;

 @override
  void initState() {
    super.initState();
    _userNameController = TextEditingController();
    _passwordController = TextEditingController();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title:Text( "Registiration"),),
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _userNameController,
                onChanged: (value) {
                  print(value);
                  userName = value;
                },
                decoration: InputDecoration(
                    labelText: "UserName",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide(color: Colors.black54)),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide(color: Colors.blue))),
                keyboardType: TextInputType.emailAddress,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _passwordController,
                obscureText: true,
                onChanged: (value) {
                  print(value);
                  password =value;
                },
                decoration: InputDecoration(
                    labelText: "Password",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide(color: Colors.black54)),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide(color: Colors.blue))),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 7.5),
              child: SizedBox(
                height: 40,
                width: 250,
                child: RaisedButton(
                  color: Colors.blue,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                      side: BorderSide(color: Colors.black)),
                  onPressed: ()  async {
                    setState(() {
                      showSpinner = true ;
                    });
                 try{
                  final newUser = await _auth.createUserWithEmailAndPassword(email: userName, password: password);
                  if(newUser != null){
                   Navigator.push(context, MaterialPageRoute(builder: (BuildContext context)=>ChatScreen()));
                   _userNameController.clear();
                   _passwordController.clear();
                  }}
                  catch(e){
                   print(e);
                  }
                   setState(() {
                     showSpinner = false;
                   });
                  },
                  child: Text(
                    "Registiration",
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

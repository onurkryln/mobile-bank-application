import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class Resetpassword extends StatefulWidget {
  const Resetpassword({Key? key}) : super(key: key);

  @override
  State<Resetpassword> createState() => _ResetpasswordState();
}

class _ResetpasswordState extends State<Resetpassword> {
 TextEditingController mail=TextEditingController();
 @override
  void dispose(){
   mail.dispose();
   super.dispose();
 }
 Future reset()async{
   try{
     await FirebaseAuth.instance.sendPasswordResetEmail(email: mail.text.trim());
     showDialog(context: context, builder: (context) {
       return AlertDialog(
         content: Text("reset send password please check mail"),
       );
   });}
   on FirebaseAuthException  catch(e){
     showDialog(context: context, builder: (context) {
       return AlertDialog(
         content: Text(e.message.toString()),
       );
     },);
   }

 }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(centerTitle: true,title: Text("ŞİFRE YENİLEME EKRANI")),
       body:Column(children: [
         TextFormField(
           controller: mail,
           decoration: InputDecoration(border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),hintText: "mail"),
         ),
         MaterialButton(onPressed: reset,child: Text("gönder"),)
       ]) ,
    );
  }
}


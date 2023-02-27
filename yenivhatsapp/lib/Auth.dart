
import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService{
  final FirebaseAuth _auth=FirebaseAuth.instance;
  final FirebaseFirestore _firestore=FirebaseFirestore.instance;
  Future<User?>signIn(String email,String password)async{
    var user=await _auth.signInWithEmailAndPassword(email: email, password: password);
    return user.user
    ;

  }
  signOut()async{
    return await _auth.signOut();

  }
  Future<User?>createPerson(String uid,String name,String email,String password,List<String> tarih,List<String> miktar)async{
    var
    user=await _auth.createUserWithEmailAndPassword(email: email, password: password);
    await _firestore.collection("onur").doc(user.user?.uid).set({"ID":uid,"userName":name,"email":email,"Bakiye":10,"hesap":miktar,"tarih":tarih,});
    return user.user;

  }
  String?uId(){
    var user= _auth.currentUser?.uid;

    return user;
  }

}
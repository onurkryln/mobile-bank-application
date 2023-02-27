import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:yenivhatsapp/Account.dart';
import 'package:yenivhatsapp/Auth.dart';
import 'package:yenivhatsapp/differentAccount.dart';
import 'package:yenivhatsapp/paracek.dart';
import 'package:yenivhatsapp/parayat%C4%B1r.dart';

import '../hesap_hareketleri.dart';

class AnaSayfa extends StatefulWidget {
  String name="";
  AnaSayfa(String name){this.name=name;}
  @override
  State<AnaSayfa> createState() => _AnaSayfaState();
}

class _AnaSayfaState extends State<AnaSayfa> {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();
  AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _initialization,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text("Hata");
          } else if (snapshot.hasData) {
            return LogIn();
          } else {
            return CircularProgressIndicator();
          }
        });
  }

  LogIn() {
    var email = "";
    var ad = "";
    bool passlook = true;
    AuthService _authService = AuthService();
    TextEditingController name = TextEditingController();
    TextEditingController pass = TextEditingController();
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    CollectionReference ana = firestore.collection("onur");
    DocumentReference ref =
        firestore.collection("onur").doc((_authService.uId().toString()));
    return StreamBuilder<QuerySnapshot>(
        stream: ana.snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text("hata");
          } else if (snapshot.hasData) {
            List<DocumentSnapshot> list = snapshot.data!.docs;
            List<dynamic> listt = list;
            return Scaffold(backgroundColor: Colors.black,
                appBar: AppBar(
                    title: Text(
                  widget.name,
                  style: TextStyle(fontSize: 25),
                )),
                body: Column(mainAxisSize: MainAxisSize.max, children: [
               Expanded(child: Image.asset("assets/images/onur00.jpg")),
                  Expanded(
                    child: Row(
                mainAxisSize: MainAxisSize.max,
                      children: [
                        Expanded(
                          child: Container(
                              padding: EdgeInsets.all(10),

                              margin: EdgeInsets.all(10),
                              color: Colors.cyanAccent,
                              child: GestureDetector(
                                child: Text("=>başka hesaba para yatır=>",
                                style: TextStyle(color: Colors.red,fontSize: 17)),
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => different()));
                                },
                              )),
                        ),
                        Expanded(
                          child: Container(
                              padding: EdgeInsets.all(10),

                              margin: EdgeInsets.all(10),

                              color: Colors.cyanAccent,
                              child: GestureDetector(
                                  child: Text(
                                    "=>para çek=>",
                                    style: TextStyle(
                                        fontSize: 20, color: Colors.red),
                                  ),
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => paraCek(),
                                        ));
                                  })),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Row(mainAxisSize: MainAxisSize.min,
                       children: [
                        Expanded(
                          child: Container(
                            padding: EdgeInsets.all(10),
                            margin: EdgeInsets.all(10),

                            color: Colors.cyanAccent,
                            child: GestureDetector(
                              child: Text(
                                "=>para yatır=>",
                                style: TextStyle(fontSize: 20, color: Colors.red),
                              ),
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => paraYatir(),
                                    ));
                              },
                            ),
                          ),
                        ),
                         Expanded(
                           child: Container(
                             padding: EdgeInsets.all(10),
                             margin: EdgeInsets.all(10),

                             color: Colors.cyanAccent,
                             child: GestureDetector(
                               child: Text(
                                 "=>Hesap Hareketleri=>",
                                 style: TextStyle(fontSize: 20, color: Colors.red),
                               ),
                               onTap: () {
                                 Navigator.push(
                                     context,
                                     MaterialPageRoute(
                                       builder: (context) => HesapHareketleri(),
                                     ));
                               },
                             ),
                           ),
                         ),

                      ],
                    ),
                  ),

                 ElevatedButton(onPressed: (){
Navigator.push(context, MaterialPageRoute(builder: (context) => Account(),));
                 }, child:Text("Hesap Bilgilerim") ),
                  ElevatedButton(
                      onPressed: () {
                        _authService.signOut();
                        Navigator.pop(context);
                      },
                      child: Text("çıkış"))
                ]));
          } else {
            return CircularProgressIndicator();
          }
        });
  }
}

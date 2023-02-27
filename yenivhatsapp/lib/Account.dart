import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'Auth.dart';

class Account extends StatefulWidget {
  const Account({Key? key}) : super(key: key);

  @override
  State<Account> createState() => _AccountState();
}

class _AccountState extends State<Account> {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();
  AuthService _authService = AuthService();
  TextEditingController paracek = TextEditingController();

  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _initialization,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text("Hata");
          } else if (snapshot.hasData) {
            return bilgi();
          } else {
            return CircularProgressIndicator();
          }
        });
  }

  Widget bilgi() {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    CollectionReference ana = firestore.collection("onur");
    DocumentReference ref =
        firestore.collection("onur").doc((_authService.uId().toString()));
    return StreamBuilder<QuerySnapshot>(
        stream: ana.snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text("bağlantı hatası");
          } else if (snapshot.hasData) {
            List<DocumentSnapshot> list = snapshot.data!.docs;
            List<dynamic> list1 = list;
            int t = 0;

            return Scaffold(backgroundColor: Colors.grey,
              appBar: AppBar(
                title: Text("Hesap Bilgileri",
                    style: TextStyle(color: Colors.amberAccent, fontSize: 20)),
              ),
              body: islem(ref, list1),
            );
          } else {
            return CircularProgressIndicator();
          }
        });
  }

  islem(DocumentReference ref, List list) {
    List<Container> liste =[];

    for (int i = 0; i < list.length; i++) {
      liste.add(  Container(
        margin: EdgeInsets.all(10),
        padding: EdgeInsets.all(20),
        color: Colors.yellowAccent,
        child:

        Column(
          children: [ ListTile(
            title: Text("adı:" + list[i].data()["userName"],
                style: TextStyle(fontSize: 15)),
          ),
            ListTile(
              title: Text(
                  "bakiye:" + list[i].data()["Bakiye"].toString() + " TL",
                  style: TextStyle(fontSize: 15)),

            ),
            ListTile(title: Text(
                "mail:" + list[i].data()["email"].toString(),
                style: TextStyle(fontSize: 15)),)
        ]),
      ),);}
    for (int i = 0; i < list.length; i++) {
      if (list[i].data()["ID"] == _authService.uId()) {
        print(list[i].data()["ID"]);
        return Column(mainAxisSize: MainAxisSize.min, children: [
          (liste[i]),
          Container(
            width: 70,
            height: 50,
            margin: EdgeInsets.all(30),
            child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    Navigator.pop(context);
                  });
                },
                child: Text("geri dön")),
          ),
        ]);
      }
    }
    ;
  }
}

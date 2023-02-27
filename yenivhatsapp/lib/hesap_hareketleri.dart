import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'Auth.dart';

class HesapHareketleri extends StatefulWidget {
  const HesapHareketleri({Key? key}) : super(key: key);

  @override
  State<HesapHareketleri> createState() => _HesapHareketleriState();
}

class _HesapHareketleriState extends State<HesapHareketleri> {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();
  AuthService _authService = AuthService();
  TextEditingController paracek = TextEditingController();
  List<dynamic>tarih=[];
  List<dynamic>hesap=[];




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


int ii=0
    ;
    for (int i = 0; i < list.length; i++) {
      if (list[i].data()["ID"] == _authService.uId()) {
        hesapla(i,list);
        print(list[i].data()["ID"]);
        return Column(mainAxisSize: MainAxisSize.min, children: [
         // (liste[i]),
          Expanded(
            child: ListView.builder(itemBuilder: (context, index) {
              Characters k=hesap[index].toString().characters;
              return Container(color: Colors.white,child:
              ListTile(
          trailing:k.characterAt(0).toString()=="+"?Container(color: Colors.black,child: Text(hesap[index].toString(),style: TextStyle(color: Colors.greenAccent,fontSize: 20),)):Container(color: Colors.black,child:
              Text(hesap[index].toString(),style: TextStyle(color: Colors.red,fontSize: 20), )),title: Text(style: TextStyle(color: Colors.black),tarih[index].toString()),));
            },itemCount: hesap.length),
          ),
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

  void hesapla(int i,List list) {
    hesap=list[i].data()["hesap"];
tarih=list[i].data()["tarih"];

for(int i=0;i<hesap.length;i++){
  print(hesap[i]);
  print(tarih[i].toString());
}

  }
}

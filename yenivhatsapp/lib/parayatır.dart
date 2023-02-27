import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:yenivhatsapp/Auth.dart';

class paraYatir extends StatefulWidget {
  @override
  State<paraYatir> createState() => _paraYatirState();
}

class _paraYatirState extends State<paraYatir> {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();
  AuthService _authService = AuthService();
  TextEditingController parayat = TextEditingController();
bool basma=false;
int sayac=2;
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _initialization,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text("Hata");
          } else if (snapshot.hasData) {
            return parayatr();
          } else {
            return CircularProgressIndicator();
          }
        });
  }

  Widget parayatr() {

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
            return Scaffold(
                appBar: AppBar(
                  title: Text("Para yatırma ekranı",
                      style:
                      TextStyle(color: Colors.amberAccent, fontSize: 20)),
                ),
                body: Column(children: [
                  Card(
                    margin: EdgeInsets.all(20),
                    color: Colors.cyanAccent,
                    child: TextFormField(
                      decoration: InputDecoration(hintText: "yatırılacak para"),
                      style: TextStyle(fontSize: 20),
                      controller: parayat,
                    ),
                  ),
                  Card(
                    child: Text(_authService.uId().toString()),
                  ),
                  ElevatedButton(
                      child: Text("İşlemi Tamamla"),
                      onPressed: () {
                        for (int i = 0; i < list.length; i++) {
                          String ba = parayat.text.toString();
                          int a = int.parse(ba);
                          if (a <= list1[i].data()["Bakiye"]) {
                            showDialog(
                              barrierDismissible: false,
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: Text("para yatırılıyor"),
                                  content: Text("eminmisiniz?"),
                                  actions: [
                                    ElevatedButton(
                                        onPressed: () {
                                          setState(() {
                                            sayac=2;
                                            basma=true;
                                            int aa = int.parse(list1[i]
                                                .data()["Bakiye"]
                                                .toString());
                                            int bb = int.parse(
                                                parayat.text.toString());
                                            int cc = aa + bb;
                                            String zaman =
                                            DateTime.now().toString();
                                            List<dynamic> liste = [];
                                            liste.add(zaman);
                                            String para = "+" + bb.toString();

                                            List<dynamic> liste2 = [];
                                            sayac--;
                                            liste2.add(para);
                                            ref.update({
                                              "Bakiye": cc,
                                              "tarih":
                                              FieldValue.arrayUnion(liste),
                                              "hesap":
                                              FieldValue.arrayUnion(liste2),
                                            });
                                            Navigator.pop(context);
                                            print("evet tuşuna basıldı");
                                            showDialog(context: context, builder: (context) {
                                              return AlertDialog(

                                                actions: [
                                                  Container(child: Text("işlem başarılı çıkış yapmak için ${sayac.toString()}  kez hayır tuşuna basınız"),),

                                                  ElevatedButton(onPressed: () {
                                                    Navigator.pop(context);
                                                  }, child: Text("Tamam"))
                                                ],
                                              );
                                            },);

                                          });
                                        },
                                        child: Text("evet")),
                                    ElevatedButton(
                                        onPressed: () {
                                          setState(() {
                                            sayac--;
                                          });
                                          Navigator.pop(context);
                                          print("hayır tuşuna basıldı");
                                          if(basma==false){
                                            showDialog(context: context, builder: (context) {
                                              return AlertDialog(

                                                actions: [
                                                  Container(child: Text(" çıkış yapmak için ${sayac.toString()} kez hayır tuşuna basınız"),),

                                                  ElevatedButton(onPressed: () {
                                                    Navigator.pop(context);
                                                  }, child: Text("Tamam"))
                                                ],
                                              );
                                            },);}
                                          else{setState(() {
                                            basma=false;
                                            sayac=2;
                                          });}


                                        },
                                        child: Text("Hayır"))
                                  ],
                                );
                              },
                            );
                          } else {}
                        }
                      }),
                  ElevatedButton(
                      onPressed: () {
                        setState(() {
                          Navigator.pop(context);

                        });
                      },
                      child: Text("çıkış"))
                ]));
          } else {
            return CircularProgressIndicator();
          }
        });
  }
}

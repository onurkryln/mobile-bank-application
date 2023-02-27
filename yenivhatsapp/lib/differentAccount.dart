import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:yenivhatsapp/Auth.dart';
import 'package:yenivhatsapp/Entityy/hesap.dart';

class different extends StatefulWidget {
  @override
  State<different> createState() => _different();
}

class _different extends State<different> {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();
  Color color = Colors.white;
  String messages="kontol et";
  String messages2="işlemi tamamla";
  Color color2 = Colors.white;


  AuthService _authService = AuthService();
  TextEditingController mail = TextEditingController();
  TextEditingController money = TextEditingController();
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _initialization,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text("Hata");
          } else if (snapshot.hasData) {
            return paracekr();
          } else {
            return CircularProgressIndicator();
          }
        });
  }

  Widget paracekr() {
    bool kont = false;
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
                  title: Text("Farklı Hesap Para Yatırma",
                      style:
                      TextStyle(color: Colors.amberAccent, fontSize: 20)),
                ),
                body: Column(children: [
                  Card(
                    margin: EdgeInsets.all(12),
                    color: Colors.cyanAccent,
                    child: TextFormField(
                        decoration: InputDecoration(hintText: "para yatırılacak email"),
                        controller: mail),
                  ),
                  SizedBox(height: 8,),
                  Card(
                    color: Colors.cyanAccent,
margin: EdgeInsets.all(12),
                    child: TextFormField(
                        decoration: InputDecoration(hintText: "ücret"),
                        controller: money),
                  ),
                  Card(
                    color: Colors.cyanAccent,

                    child: Text(_authService.uId().toString()),
                  ),
                  Container(
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          this.color = Colors.greenAccent;
                          ref = firestore
                              .collection("onur")
                              .doc((_authService.uId().toString()));
                          for (int i = 0; i <= list.length - 1; i++) {
                            print(list1[i].data()["Bakiye"].toString());
                            if (int.parse(money.text.toString()) <=
                                list1[i].data()["Bakiye"]) {

                              int aaa = int.parse(
                                  list1[i].data()["Bakiye"].toString());
                              print("aa" + aaa.toString());

                              int bbb = int.parse(money.text.toString());
                              print("bbb" + bbb.toString());

                              int ccc = aaa - bbb;
                              String zaman =
                              DateTime.now().toString();
                              List<dynamic> liste = [];
                              liste.add(zaman);
                              String para = "-" + bbb.toString();

                              List<dynamic> liste2 = [];
                              liste2.add(para);
                              print("ccc" + ccc.toString());

                              ref.update({
                                "Bakiye": ccc,
                                "tarih":
                                FieldValue.arrayUnion(liste),
                                "hesap":
                                FieldValue.arrayUnion(liste2),
                              });
                              color = Colors.lightGreenAccent;
                              this.messages="kontrol edildi";
                              break;
                            } else {
                              print("yetersiz");
                              color = Colors.black;
                            }
                          }
                        });
                      },
                      child: Text(messages, style: TextStyle(color: color)),
                    ),
                  ),
                  Container(
                    child: ElevatedButton(
                        child: Text(messages2,style: TextStyle(color: color2)),
                        onPressed: () {
                          setState(() {
                            for (int i = 0; i <= list.length - 1; i++) {
                              if (list1[i].data()["email"] ==
                                  mail.text.toString().trim()) {
                                ref = firestore
                                    .collection("onur")
                                    .doc((list1[i].data()["ID"].toString()));
                                print(list1[i].data()["email"].toString());
                                String ba = money.text.toString();
                                int a = int.parse(ba);

                                showDialog(context: context, builder: (context) {
                                  return AlertDialog(
                                    content: Text("başka işlem yapmak istermisiniz?"),
                                    actions: [
                                      ElevatedButton(onPressed: () {
                                        setState(() {
                                          color2=Colors.white;
                                          color=Colors.white;
                                          messages="kontrol et";
                                          messages2="işlemi tamamla";
                                          Navigator.pop(context);
                                        });
                                      }, child: Text("EVET")),
                                      ElevatedButton(onPressed: () {
                                        setState(() {
                                          color2=Colors.white;
                                          color=Colors.white;
                                          messages="kontrol et";
                                          messages2="işlemi tamamla";
                                          _authService.signOut();
                                          Navigator.push(context, MaterialPageRoute(builder: (context) => Hesap(),));
                                        });

                                      }, child: Text("HAYIR")),

                                    ],
                                  );
                                },);
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      title: Text("para yatırılıyor"),
                                      content: Text("  istermisiniz?"),
                                      actions: [
                                        TextButton(
                                            onPressed: () {
                                              setState(() {
                                                this.messages="Kontrol et";
                                                this.messages2="işlem tamamlandı";
                                                this.color2=Colors.lightGreenAccent;
                                              });
                                              int aa = int.parse(list1[i]
                                                  .data()["Bakiye"]
                                                  .toString());
                                              print("aa" + aa.toString());
                                              int bb = int.parse(
                                                  money.text.toString());
                                              print("bb" + bb.toString());
                                              int cc = aa + bb;
                                              print("cc" + cc.toString());
                                              String zaman =
                                              DateTime.now().toString();
                                              List<dynamic> liste = [];
                                              liste.add(zaman);
                                              String para = "+" + bb.toString();

                                              List<dynamic> liste2 = [];
                                              liste2.add(para);
                                              print("ccc" + cc.toString());

                                              ref.update({
                                                "Bakiye": cc,
                                                "tarih":
                                                FieldValue.arrayUnion(liste),
                                                "hesap":
                                                FieldValue.arrayUnion(liste2),
                                              });

                                              Navigator.pop(context);
                                            },
                                            child: Text("evet")),
                                        TextButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            child: Text("Hayır"))
                                      ],
                                    );
                                  },
                                );





                                break;
                              }
                            }

                          });
                        }),
                  ),
                  ElevatedButton(
                      onPressed: () {
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
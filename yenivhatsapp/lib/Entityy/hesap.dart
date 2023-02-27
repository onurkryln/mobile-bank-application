import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yenivhatsapp/Auth.dart';
import 'package:yenivhatsapp/Y%C3%B6n/Y%C3%B6nlendir.dart';
import 'package:yenivhatsapp/help.dart';
import 'package:yenivhatsapp/resetpass.dart';

class Hesap extends StatefulWidget {
  @override
  State<Hesap> createState() => _HesapState();
}

class _HesapState extends State<Hesap> with SingleTickerProviderStateMixin {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();
  TabController? _tabController;
  AuthService _authService = AuthService();
  double sayi = 1;
  double t = 1;
  int t2 = 1;
  int t3 = 1;
  String txt1="";
  String txt2="";
  String txt="";
  bool ask=true;
  bool ask1=true;
Icon icon=Icon(Icons.mood_outlined,color: Colors.greenAccent,size: 50,);
  Icon icon2=Icon(Icons.mood_bad,color: Colors.red,size: 50,);

  int counter = 0;
  Color color = Colors.black;
  Color color2 = Colors.black;
  Color color3= Colors.black;
  Color color4= Colors.black;  Color color5= Colors.black;
  Color colors = Colors.blue;
  bool showmessage = true;
  String Time=DateTime.now().toString();
List<String>time=[];
List<String>tutar=[];
  @override
  void initState() {
    // TODO: implement initState
    _tabController = TabController(length: 4, vsync: this, initialIndex: 1);
    _tabController!.addListener(() {
      showmessage = _tabController!.index != 0;
      setState(() {});
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _initialization,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text("Hataa");
          } else if (snapshot.hasData) {
            return MyHome();
          } else {
            return CircularProgressIndicator();
          }
        });
  }

  Widget MyHome() {
    return Scaffold(
      backgroundColor: Colors.grey,
      appBar: AppBar(
        title: Text("ONUR BANK", style: TextStyle(fontSize: 25)),
        bottom: TabBar(controller: _tabController, tabs: [
          Tab(
            icon: Icon(Icons.camera),
            text: ("giriş yap"),
          ),
          Tab(
            text: ("kayıt ol"),
          ),
          Tab(
            text: ("Vade hesabı"),
          ),
          Tab(
            text: ("Değerlendirme ve yardım"),
          )
        ]),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [LogIn(), SignIn(), help(), Myimage()],
      ),
    );
  }

  SignIn() {
    bool passlook = true;
    TextEditingController mail = TextEditingController();
    TextEditingController name = TextEditingController();
    TextEditingController pass = TextEditingController();
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Card(
          child: TextFormField(
              controller: name,
              style: TextStyle(
                fontSize: 24,
              ),
              decoration: InputDecoration(
                hintText: "KULLANICI ADINIZ",
                icon: Icon(Icons.drive_file_rename_outline),
              )),
        ),
        Card(
          child: TextFormField(
              controller: pass,

              obscureText: ask1,
              style: TextStyle(
                fontSize: 24,
              ),
              decoration: InputDecoration(
                suffixIcon: GestureDetector(
                    onTap: () {
                      setState(() {
                        if(ask1==true){ask1=false;}
                        else
                        {ask1=true;}
                      });


                    },
                    child: Icon(ask1==true?Icons.visibility:Icons.visibility_off)),
                hintText: "şifreniz",
                icon: Icon(Icons.password),
              )),
        ),
        Card(
          child: TextFormField(
              controller: mail,
              style: TextStyle(
                fontSize: 24,
              ),
              decoration: InputDecoration(
                hintText: "email",
                icon: Icon(Icons.mail),
              )),
        ),

        Container(
          color: colors,
          child: ElevatedButton(
              onPressed: () {
                setState(() {
                  counter++;
                  time.add(Time);
                  print(DateTime.now());
                  tutar.add("+"+"10");
                });
                _authService.createPerson(
                    _authService.uId().toString().trim(),
                    name.text.toString().trim(),
                    mail.text.toString().trim(),
                    pass.text.toString().trim(),
                   time,tutar).catchError((dynamic error)
                {
                  showDialog(context:context, builder: (context) {

                    return AlertDialog(
                      content: Text(error.message.toString()),
                      actions: [
                        ElevatedButton(onPressed: () {
                          setState(() {
                            counter=0;
                          });
                          Navigator.pop(context);

                          }, child: Text("TAMAM"))
                      ],
                    );
                  },);

                }
                );
                update();



                if (counter % 2 == 0) {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        backgroundColor: Colors.black,
                        content: Text("işlem başarılı",
                            style: TextStyle(
                                color: Colors.white,
                                backgroundColor: Colors.black,
                                fontSize: 20)),
                        actions: [
                          ElevatedButton(
                              onPressed: () => Navigator.pop(context),
                              child: Text("TAMAM"))
                        ],
                      );
                    },
                  );
                  colors = Colors.cyanAccent;
                } else {
                  colors = Colors.red;
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        backgroundColor: Colors.black,
                        content: Text("lütfen tekrar basınız",
                            style: TextStyle(
                                fontSize: 20,
                                backgroundColor: Colors.black,
                                color: Colors.white)),
                        actions: [
                          ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  Navigator.pop(context);
                                });
                              },
                              child: Text("TAMAM"))
                        ],
                      );
                    },
                  );
                }
              },
              child: Text("KAYIT")),
        )
      ],
    );
  }

  LogIn() {
    TextEditingController bakiye = TextEditingController();
    TextEditingController name = TextEditingController();
    TextEditingController pass = TextEditingController();
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    CollectionReference ana = firestore.collection("onur");
    return StreamBuilder<QuerySnapshot>(
        stream: ana.snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text("hataaa");
          } else if (snapshot.hasData) {
            List<DocumentSnapshot> list = snapshot.data!.docs;
            List<dynamic> listt = list;
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [

                Card(
                  child: TextFormField(
                      controller: pass,
                      style: TextStyle(
                        fontSize: 24,
                      ),
                      decoration: InputDecoration(
                        hintText: "email",
                        icon: Icon(Icons.mail_outline),
                      )),
                ),    Card(
                  child: TextFormField(obscureText:ask ,
                      controller: name,
                      style: TextStyle(
                        fontSize: 24,
                      ),
                      decoration: InputDecoration(
                        suffixIcon: GestureDetector(
                            onTap: () {
                              setState(() {
                                if(ask==true){ask=false;}
                                else
                                {ask=true;}
                              });
                            },
                            child: Icon(ask==true? Icons.visibility:Icons.visibility_off)),
                        hintText: "KULLANICI şifreniz",
                        icon: Icon(Icons.password_sharp),
                      )),
                ),
                ElevatedButton(
                    onPressed: () {
                      _authService
                          .signIn(pass.text.trim(), name.text.trim())
                          .then((value) => (Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      AnaSayfa(pass.text.toString())))));

                      String bakiye;
                      Map<String, dynamic> map = {
                        "userName": name.text,
                        "email": pass.text
                      };
                    },
                    child: Text("GİRİŞ")),
                Container(
                  color: Colors.black,
                  child: GestureDetector(
                    child: Text("şifremi unuttum?",
                        style:
                            TextStyle(color: Colors.cyanAccent, fontSize: 20)),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Resetpassword(),
                          ));
                    },
                  ),
                )
              ],
            );
          } else {
            return CircularProgressIndicator();
          }
        });
  }

  void update() {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    CollectionReference ana = firestore.collection("onur");
    DocumentReference ref =
        firestore.collection("onur").doc((_authService.uId().toString()));
    setState(() {
      ref.update({"ID": _authService.uId()});
      print(_authService.uId().toString());
    });
  }

  Myimage() {
    List <ListTile>liste=[ListTile(
      tileColor: color3,
      title: Text("iletişim bilgileri;0541 573 45 72",style: TextStyle(color: Colors.black,fontSize: 19)),
      trailing: Image.asset("assets/icon/onur00.jpg"),
      onTap: () {
        setState(() {
          print("$t3");

          t3++;
          if (t3 % 2 == 0)
            color3 = Colors.white;
          else {
            color3 = Colors.black;
          }
        });
      },
    ),ListTile(
      tileColor: color2,
      title: Text("Proje sahibi :ONUR KARAYILAN",style: TextStyle(color: Colors.black,fontSize: 19)),
      trailing: Image.asset("assets/images/onur00.jpg"),
      onTap: () {
        setState(() {
          print("$t2");

          t2++;
          if (t2 % 2 == 0)
            color2= Colors.white;
          else {
            color2 = Colors.black;
          }
        });
      },
    ),ListTile(
      tileColor: color3,
      title: Text(txt1,style: TextStyle(color: color4,fontSize: 19)),
      trailing: Image.asset("assets/images/onur00.jpg"),
      onTap: () {
        setState(() {
          print("$t3");

          t3++;
          if (t3 % 2 == 0){
            color3 = Colors.white;
          color4=Colors.black;
          txt1="iletişim bilgileri:05415734572";
          }
          else {
            color3 = Colors.black;
            color4=Colors.white;
            txt1="TIKLAYARAK İLETİŞİM BİLGİLERİNE ULAŞABİLİRSİNİZ";
          }
        });
      },
    )];

    return Scaffold(backgroundColor: Colors.white,
      body: Column(mainAxisSize: MainAxisSize.max,crossAxisAlignment: CrossAxisAlignment.stretch,mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(
            child: Container(
              child: ListView.builder(itemCount: liste.length,itemBuilder: (context, index) {
                return liste[index];
              },),
            ),
           ),
          Expanded(
            child: Container(color: Colors.black,
              child: Slider(min: 0,max: 5,label: t.toString(),value: t, onChanged: (value) {

                setState(() {
                  this.t=value;
                });
              },),
            ),
           ),
        Expanded(
          child: Column(
            children: [
              Container(color: Colors.black,child:
                t>=3?icon:icon2,),
         SizedBox(height: 10,),
           Container(color: Colors.black,
           child: t<=3?Text("Yanıtınız içi teşekkürler:).",style: TextStyle(color: Colors.cyanAccent,fontSize: 22),):Text("bizi tercih ettiğiniz için  teşekkürler:)",style: TextStyle(fontSize: 22,color: Colors.greenAccent)),)
            ],
          ),

        )


        ],
      ),
    );

  }
}

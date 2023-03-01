import 'dart:math';

import 'package:flutter/material.dart';

class help extends StatefulWidget {
  const help({Key? key}) : super(key: key);

  @override
  State<help> createState() => _helpState();
}

class _helpState extends State<help> {
  double gun=1;
  double faiz=1;
  double sonuc=0;
  TextEditingController para=TextEditingController();
  TextEditingController para1=TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: Container(color: Colors.cyanAccent,margin: EdgeInsets.only(right: 40,
                left: 40),child: TextFormField(decoration: InputDecoration(hintText: "kredi ",), controller: para,)),
          ),
          Expanded(
            child:   Container(color: Colors.black,margin: EdgeInsets.only(left: 40,right: 40),

              child:   Slider(label:gun.toString() ,min:1,max: 36,value: gun, onChanged: (double sayi) {

                setState(() {

                  this.gun=sayi;

                  if(gun>1){

                    if(faiz>=1.79){faiz=1.79;}

                    else{

                      faiz=faiz+0.02;

                    }}

                  else{this.faiz=1;}

                });

              },),

            ),
          ),
          Expanded(child: Container(margin: EdgeInsets.only( right: 40,left: 40),color: Colors.cyanAccent,child: ListTile(title:Text("$faiz"),leading: Text("vade:",style: TextStyle(fontSize: 18)), ))),
          ElevatedButton(child: Text("hesapla"),onPressed: () {
            setState(() {
              double sa=double.parse(para.text.toString());
              sonuc=faiz*sa;
            });
          },)          ,
          Expanded(child: Container(color: Colors.black,child: ListTile(title: Text("Ödenmesi gereken toplam tutar:$sonuc+TL",style: TextStyle(color: Colors.white)),trailing: Text("Taksit(Ay)  :$gun",style: TextStyle(color: Colors.white)),)))
        ],
      ),
    );
  }


}

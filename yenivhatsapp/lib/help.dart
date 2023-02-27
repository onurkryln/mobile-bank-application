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
          TextFormField(decoration: InputDecoration(hintText: "kredi "), controller: para,),
Slider(label: gun.round().toString(),min:1,max: 36,value: gun, onChanged: (double sayi) {
setState(() {
  this.gun=sayi;
  if(gun!=1)
  this.faiz=1.79;
  else{this.faiz=1;}
});
  },),
 ListTile(title:Text("$faiz"), ),
 ElevatedButton(child: Text("hesapla"),onPressed: () {
   setState(() {
     double sa=double.parse(para.text.toString());
     sonuc=faiz*sa;
   });
 },)         ,
          ListTile(title: Text("$sonuc"),trailing: Text("$gun"),)
        ],
      ),
    );
  }


}

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'Entityy/hesap.dart';

void main()async {WidgetsFlutterBinding.ensureInitialized();
await Firebase.initializeApp();
runApp((MaterialApp( theme: ThemeData(),home: MyApp())));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Hesap();
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;
  bool showmessage = true;
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
    return Scaffold(
      appBar: AppBar(
        title: Text("ONUR Bank"),
        bottom: TabBar(controller: _tabController, tabs: [
          Tab(icon: Icon(Icons.camera)),
          Tab(
            text: ("messages"),
          ),
          Tab(
            text:("calls"),
          ),
          Tab(
            text: ("s"),
          ),
        ]),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          Container(
            color: Colors.blueAccent,
          ),
          Container(
            color: Colors.green,
          ),
          Container(
            color: Colors.black,
          ),
          Container(
            color: Colors.amberAccent,
          )
        ],
      ),
      floatingActionButton: showmessage
          ? FloatingActionButton(
              onPressed: () {},
              child: Icon(Icons.message),
            )
          : null,
    );
  }
}

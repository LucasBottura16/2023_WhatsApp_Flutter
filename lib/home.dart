import 'package:firebase/routeGenerator.dart';
import 'package:firebase/telas/abaContatos.dart';
import 'package:firebase/telas/abaConversas.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';


class MyHome extends StatefulWidget {
  const MyHome({Key? key}) : super(key: key);

  @override
  State<MyHome> createState() => _MyHomeState();
}

class _MyHomeState extends State<MyHome> with SingleTickerProviderStateMixin {

  FirebaseAuth auth = FirebaseAuth.instance;

  late TabController _tabController;
  List<String> itemMenu = [
    "Configuração",
    "Deslogar"
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _tabController = TabController(length: 2, vsync: this);

  }

  _escolhaMenuItem(String escolhido){
    
    switch(escolhido){
      case "Configuração":
        Navigator.pushNamed(context, RouteGenerator.rotaConfig);
        break;
      case"Deslogar":
        _deslogar();
        break;
    }

  }
  
  _deslogar() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    
    await auth.signOut().then((value) => Navigator.pushReplacementNamed(
        context, RouteGenerator.rotaLogin));
    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("WhatsApp"),
        backgroundColor: const Color(0xff075E54),
        bottom: TabBar(
          indicatorWeight: 4,
          labelStyle: const TextStyle(
            fontSize: 18, fontWeight: FontWeight.bold
          ),
          controller: _tabController,
          indicatorColor: Colors.white,
          tabs: const [
            Tab(text: "Conversas"),
            Tab(text: "Contatos",)
          ],
        ),
        actions: [
         PopupMenuButton<String>(
           onSelected: _escolhaMenuItem,
             itemBuilder: (context){
             return itemMenu.map((String item){
               return PopupMenuItem<String>(
                 value: item,
                   child: Text(item)
               );
             }).toList();
             }
         )
        ],
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          AbaConversas(),
          AbaContatos(),
        ],
      )
    );
  }
}

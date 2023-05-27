import 'package:firebase/model/usuario.dart';
import 'package:firebase/routeGenerator.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AbaContatos extends StatefulWidget {
  const AbaContatos({Key? key}) : super(key: key);

  @override
  State<AbaContatos> createState() => _AbaContatosState();
}

class _AbaContatosState extends State<AbaContatos> {

  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore =FirebaseFirestore.instance;
  String? myUrl;

  Future<List<Usuario>> _recuperarContatos() async {
    
    FirebaseFirestore firestore =FirebaseFirestore.instance;
    
    QuerySnapshot querySnapshot = await firestore.collection("Clientes").get();

    List<Usuario> listaUsuario = [];
      for(var item in querySnapshot.docs){
        if ( item.get("URL") == myUrl) continue;

        Usuario usuario = Usuario();
        usuario.nome =  item.get("nome");
        usuario.url =  item.get("URL");

        listaUsuario.add(usuario);

      }

      return listaUsuario;
  }

  Future<String?> _recuperaDados() async {
    await firestore.collection("Clientes").doc(auth.currentUser?.uid).get()
        .then((value) { setState(() {
      myUrl = value.get("URL");
    });});
    return null;
  }
  
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _recuperaDados();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Usuario>>(
      future: _recuperarContatos(),
        builder: (context, snapshot){
        switch ( snapshot.connectionState){
          case ConnectionState.none :
            break;
            case ConnectionState.waiting :
              return Center(
                child: Column(
                  children: const [
                    Text("Carregando contatos"),
                    CircularProgressIndicator()
                  ],
                ),
              );
            case ConnectionState.active :
            break;
          case ConnectionState.done :
            return ListView.builder(
              itemCount: snapshot.data?.length,
              itemBuilder: (context, index){

                List<Usuario>? listaUsuario = snapshot.data;
                Usuario usuario = listaUsuario![index];

                return ListTile(
                  onTap: (){
                    Navigator.pushNamed(context, RouteGenerator.rotaMensagem, arguments: usuario);
                  },
                  contentPadding:  const EdgeInsets.fromLTRB(16, 8, 16, 8),
                  leading: CircleAvatar(
                    backgroundColor: Colors.grey,
                    backgroundImage: NetworkImage(usuario.url),
                    maxRadius: 30,
                  ),
                  title: Text(usuario.nome, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  subtitle: const Text("", style: TextStyle(fontSize: 14, color: Colors.grey)),

                );

              },

            );
        }
        return Container();
        },
    );
  }
}

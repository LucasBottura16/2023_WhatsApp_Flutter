import 'dart:async';
import 'package:firebase/model/usuario.dart';
import 'package:firebase/routeGenerator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase/model/conversa.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AbaConversas extends StatefulWidget {
  const AbaConversas({Key? key}) : super(key: key);

  @override
  State<AbaConversas> createState() => _AbaConversasState();
}

class _AbaConversasState extends State<AbaConversas> {

  final List<Conversas> _listaConversa = [];
  final _controller = StreamController<QuerySnapshot>.broadcast();
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;
  String? _uid;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _recuperaDados();

    Conversas conversa = Conversas();
    conversa.nome = "Lucas";
    conversa.mensagem = "Salve salve Familia";
    conversa.caminhoFoto = "https://firebasestorage.googleapis.com/v0/b/fir-flutter-8e6f4.appspot.com/o/Perfil%2Fperfil4.jpg?alt=media&token=8a7f2564-d5ef-4aff-b3ee-7d893144a90e";

    _listaConversa.add(conversa);

  }

  Stream<QuerySnapshot>? _adicionarListaConversas()  {

    final stream = firestore.collection("Conversas").doc(_uid!)
        .collection("ultima_conversa").snapshots();

    stream.listen((event) { _controller.add(event);});

      return null;

  }

  Future<String?> _recuperaDados() async {
    setState(() {
      _uid = auth.currentUser?.uid;
    });

    _adicionarListaConversas();
    return null;

  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _controller.close();
  }

  @override
  Widget build(BuildContext context) {

    return StreamBuilder<QuerySnapshot>(
      stream: _controller.stream,
      builder: (context, snapshot){
        switch (snapshot.connectionState){
          case ConnectionState.none:
          case ConnectionState.waiting:
          return Center(
            child: Column(
              children: const [
                Text("Carregando conversas"),
                CircularProgressIndicator()
              ],
            ),
          );
          case ConnectionState.active:
          case ConnectionState.done:
            if(snapshot.hasError){
              return const Text("Errdo ao carregar dados");
            }else{

              QuerySnapshot<Object?>? querySnapshot = snapshot.data;

              if( querySnapshot?.docs.length == 0){
                return const Center(
                  child:  Text("Você não tem nenhuma mensagem ainda!"),
                );
              }
            }
            return ListView.builder(
              itemCount: _listaConversa.length,
              itemBuilder: (context, index){

                List<DocumentSnapshot>? conversas = snapshot.data?.docs.toList();
                DocumentSnapshot item = conversas![index];

                String urlImagem = item["caminhoFoto"];
                String tipo = item["tipoMensagem"];
                String mensagem = item["mensagem"];
                String nome = item["nome"];
                String idDestinatario = item["idDestinatario"];

                Usuario usuario = Usuario();
                usuario.nome = nome;
                usuario.url = urlImagem;
                usuario.uidUsuario = idDestinatario;

                return ListTile(
                  onTap: (){
                    Navigator.pushNamed(context, RouteGenerator.rotaMensagem, arguments: usuario);
                  },
                  contentPadding:  const EdgeInsets.fromLTRB(16, 8, 16, 8),
                  leading: CircleAvatar(
                    backgroundColor: Colors.grey,
                    backgroundImage: NetworkImage(urlImagem),
                    maxRadius: 30,
                  ),
                  title: Text(nome, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  subtitle: Text(tipo == "Texto" ? mensagem : "Imagem...", style: const TextStyle(fontSize: 14, color: Colors.grey)),

                );

              },

            );
        }
      },
    );
  }
}

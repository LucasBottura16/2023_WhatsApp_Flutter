import 'dart:async';
import 'package:firebase/model/conversa.dart';
import 'package:firebase/model/mensagem.dart';
import 'package:firebase/model/usuario.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

class TelaMensagens extends StatefulWidget {
  Usuario contato;

  TelaMensagens(this.contato, {super.key});

  @override
  State<TelaMensagens> createState() => _TelaMensagensState();
}

class _TelaMensagensState extends State<TelaMensagens> {
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  final _controllerM = StreamController<QuerySnapshot>.broadcast();
  final ScrollController _scrollController = ScrollController();

  final TextEditingController _controllerMensagem = TextEditingController();
  String? _uid;
  String? _uidDestinatario;
  ImagePicker picker = ImagePicker();
  bool _subindoImagem = false;

  _enviaMensagem() {
    String textoMensagem = _controllerMensagem.text;

    if (textoMensagem.isNotEmpty) {
      Mensagem mensagem = Mensagem();

      mensagem.idUsuario = _uid!;
      mensagem.mensagem = textoMensagem;
      mensagem.url = "";
      mensagem.data = Timestamp.now().toString();
      mensagem.tipo = "Texto";

      _salvaMensagem(_uid!, _uidDestinatario!, mensagem);

      _salvaMensagem(_uidDestinatario!, _uid!, mensagem);

      _salveConversa(mensagem);
    }
  }
  
  _salveConversa(Mensagem msg){
    
    Conversas cRemetente = Conversas();
    cRemetente.idRemetente = _uid!;
    cRemetente.idDestinatario = _uidDestinatario!;
    cRemetente.mensagem = msg.mensagem;
    cRemetente.nome = widget.contato.nome;
    cRemetente.caminhoFoto = widget.contato.url;
    cRemetente.tipoMensagem = msg.tipo;
    cRemetente.salvar();

    Conversas cDestinatario = Conversas();
    cDestinatario.idRemetente = _uidDestinatario!;
    cDestinatario.idDestinatario = _uid!;
    cDestinatario.mensagem = msg.mensagem;
    cDestinatario.nome = widget.contato.nome;
    cDestinatario.caminhoFoto = widget.contato.url;
    cDestinatario.tipoMensagem = msg.tipo;
    cDestinatario.salvar();

  }

  _salvaMensagem(String idRemetente, String idDestinatario, Mensagem msg) async {
    await firestore
        .collection("Mensagens")
        .doc(idRemetente)
        .collection(idDestinatario)
        .add(msg.toMap());

    setState(() {
      _controllerMensagem.text = "";
    });
  }

  _enviaFoto() async {

    File? imagemSelecionada;
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    imagemSelecionada = File(pickedFile!.path);

    String nomeImagem = DateTime.now().millisecondsSinceEpoch.toString();
    FirebaseStorage storage = FirebaseStorage.instance;
    Reference pastaRaiz = storage.ref();
    Reference arquivo = pastaRaiz.child("Mensagens").child(_uid!).child("$nomeImagem.jpg");

    UploadTask task = arquivo.putFile(imagemSelecionada);

    task.snapshotEvents.listen((TaskSnapshot storageEvent) {
      if (storageEvent.state == TaskState.running) {
        setState(() {
          _subindoImagem = true;
        });
      } else if (storageEvent.state == TaskState.success) {
        _subindoImagem = false;
      }
    });

    //Recuperar URL da imagem
    task.then((TaskSnapshot taskSnapshot) {
      _recuperarUrlImagem(taskSnapshot);
    });

  }

  Future? _recuperarUrlImagem(TaskSnapshot taskSnapshot) async {
    String url = await taskSnapshot.ref.getDownloadURL();

    Mensagem mensagem = Mensagem();

    mensagem.idUsuario = _uid!;
    mensagem.mensagem = "";
    mensagem.url = url;
    mensagem.data = Timestamp.now().toString();
    mensagem.tipo = "Imagem";

    _salvaMensagem(_uid!, _uidDestinatario!, mensagem);

    _salvaMensagem(_uidDestinatario!, _uid!, mensagem);

  }

  Future _recuperaDados() async {
    setState(() {
      _uid = auth.currentUser?.uid;
      _uidDestinatario = widget.contato.uidUsuario;
    });

    _adicionarListaConversas();
    return null;
  }

  Stream<QuerySnapshot>? _adicionarListaConversas()  {

    final stream = firestore
        .collection("Mensagens")
        .doc(_uid)
        .collection(_uidDestinatario!)
        .orderBy("_data", descending: false)
        .snapshots();

    stream.listen((event) {
      _controllerM.add(event);
      Timer(const Duration(seconds: 1), (){_scrollController.jumpTo(_scrollController.position.maxScrollExtent);});
    });

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

    Widget streamBuilderMensagens = StreamBuilder(
        stream: _controllerM.stream,
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
              return Center(
                child: Column(
                  children: const [
                    Text("Carregando mensagens"),
                    CircularProgressIndicator()
                  ],
                ),
              );
            case ConnectionState.active:
            case ConnectionState.done:
              var querySnapshot = snapshot.data;

              if (snapshot.hasError) {
                return const Expanded(
                    child: Text("Erro ao carrgar as mensagens"));
              } else {
                return Expanded(
                    child: ListView.builder(
                      controller: _scrollController,
                        itemCount: querySnapshot?.docs.length,
                        itemBuilder: (context, index) {

                          List<DocumentSnapshot>? mensagens = querySnapshot?.docs.toList();
                          DocumentSnapshot item = mensagens![index];

                          Alignment alignmentMensagem = Alignment.centerRight;
                          Color corMensagem = const Color(0xffd2ffa5);
                          if (_uid != item["_idUsuario"]) {
                            corMensagem = Colors.white;
                            alignmentMensagem = Alignment.centerLeft;
                          }

                          return Align(
                            alignment: alignmentMensagem,
                            child: Padding(
                              padding: const EdgeInsets.all(6),
                              child: Container(
                                width: MediaQuery.of(context).size.width * 0.8,
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                    color: corMensagem,
                                    borderRadius: BorderRadius.circular(8)),
                                child:
                                item["_tipo"] == "Texto"
                                    ? Text(item["_mensagem"],  style: const TextStyle(fontSize: 18))
                                    : Image.network(item["_url"]),
                              ),
                            ),
                          );
                        }));
              }
          }
        });

    Widget caixaMensagem = Container(
        padding: const EdgeInsets.all(0),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                autofocus: true,
                keyboardType: TextInputType.text,
                style: const TextStyle(fontSize: 20),
                decoration: InputDecoration(
                    contentPadding: const EdgeInsets.fromLTRB(22, 8, 22, 8),
                    hintText: "Digite uma mensagem",
                    filled: true,
                    fillColor: Colors.white,
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(32),
                        borderSide: const BorderSide(color: Colors.green)),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(32),
                      borderSide: const BorderSide(color: Colors.green),
                    ),
                    prefixIcon:
                    _subindoImagem
                    ? const CircularProgressIndicator()
                        :  IconButton(
                        icon: const Icon(Icons.camera_alt),
                      onPressed: _enviaFoto),
                ),
                controller: _controllerMensagem,
              ),
            ),
            const SizedBox(width: 8),
            FloatingActionButton(
              backgroundColor: const Color(0xff075E54),
              mini: true,
              onPressed: _enviaMensagem,
              child: const Icon(Icons.send, color: Colors.white),
            )
          ],
        ));

    return Scaffold(
        appBar: AppBar(
          title: Row(
            children: [
              CircleAvatar(
                  radius: 20,
                  backgroundColor: Colors.grey,
                  backgroundImage: NetworkImage(widget.contato.url.toString())),
              const SizedBox(width: 15),
              Text(widget.contato.nome)
            ],
          ),
          backgroundColor: const Color(0xff075E54),
        ),
        body: Container(
          width: MediaQuery.of(context).size.width,
          decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("images/bg.png"), fit: BoxFit.cover)),
          child: SafeArea(
              child: Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [streamBuilderMensagens, caixaMensagem],
            ),
          )),
        ));
  }
}

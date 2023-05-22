import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:io';

class Configuracoes extends StatefulWidget {
  const Configuracoes({Key? key}) : super(key: key);

  @override
  State<Configuracoes> createState() => _ConfiguracoesState();
}

class _ConfiguracoesState extends State<Configuracoes> {
  final TextEditingController _controllerNome = TextEditingController();
  late File _imagem;
  ImagePicker picker = ImagePicker();
  String? _uidUsuario;
  String? _urlRecuperada;
  bool _subindoImagem = false;

  Future? _recuperarImagem(String origemImagem) async {
    File? imagemSelecionada;
    switch (origemImagem) {
      case "Camera":
        final pickedFile = await picker.pickImage(source: ImageSource.camera);
        imagemSelecionada = File(pickedFile!.path);
        break;
      case "Galeria":
        final pickedFile = await picker.pickImage(source: ImageSource.gallery);
        imagemSelecionada = File(pickedFile!.path);
        break;
    }

    setState(() {
      _imagem = imagemSelecionada!;
    });

    _uploadImage();
  }

  Future? _uploadImage() async {
    FirebaseStorage storage = FirebaseStorage.instance;
    Reference pastaRaiz = storage.ref();
    Reference arquivo = pastaRaiz.child("Perfil").child("$_uidUsuario.jpg");

    UploadTask task = arquivo.putFile(_imagem);

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
    _salvarImagem(url);

    setState(() {
      _urlRecuperada = url;
    });
  }

  _salvarNome() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    String nome = _controllerNome.text;

    Map<String, dynamic> dadosAtualizados = {"nome": nome};

    firestore.collection("Clientes").doc(_uidUsuario).update(dadosAtualizados);
  }

  _salvarImagem(String url) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    Map<String, dynamic> dadosAtualizados = {"URL": url};

    firestore.collection("Clientes").doc(_uidUsuario).update(dadosAtualizados);
  }

  _recuperaDados() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? userLogado = auth.currentUser;
    _uidUsuario = userLogado?.uid;

    FirebaseFirestore firestore = FirebaseFirestore.instance;
    await firestore.collection("Clientes").doc(_uidUsuario).get().then((value) {
      setState(() {
        _controllerNome.text = value.get("nome");
        if (value.get("URL") != null) {
          _urlRecuperada = value.get("URL");
        }
      });
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _recuperaDados();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Configurações"),
        backgroundColor: const Color(0xff075E54),
      ),
      body: Container(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                _subindoImagem
                    ? const CircularProgressIndicator()
                    : Container(),
                const SizedBox(height: 10),
                CircleAvatar(
                    radius: 100,
                    backgroundColor: Colors.grey,
                    backgroundImage: _urlRecuperada != null
                        ? NetworkImage(_urlRecuperada.toString())
                        : null),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                        onPressed: () {
                          _recuperarImagem("Camera");
                        },
                        child: const Text("Camera")),
                    const SizedBox(
                      width: 20,
                    ),
                    TextButton(
                        onPressed: () {
                          _recuperarImagem("Galeria");
                        },
                        child: const Text("Galeria")),
                  ],
                ),
                const SizedBox(height: 10),
                TextField(
                  keyboardType: TextInputType.text,
                  style: const TextStyle(fontSize: 20),
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.fromLTRB(32, 16, 32, 16),
                    hintText: "Alterar nome",
                    filled: true,
                    fillColor: Colors.white,
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(32),
                        borderSide: const BorderSide(color: Colors.green)),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(32),
                      borderSide: const BorderSide(color: Colors.green),
                    ),
                  ),
                  controller: _controllerNome,
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.green),
                    padding: MaterialStateProperty.all(
                        const EdgeInsets.fromLTRB(32, 16, 32, 16)),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(32), // Define o raio dos cantos do botão
                      ),
                    ),
                  ),
                  onPressed: () {
                    _salvarNome();
                  },
                  child: const Text(
                    "Salvar",
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

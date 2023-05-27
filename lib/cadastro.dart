import 'package:firebase/routeGenerator.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Cadastro extends StatefulWidget {
  const Cadastro({Key? key}) : super(key: key);

  @override
  State<Cadastro> createState() => _CadastroState();
}

class _CadastroState extends State<Cadastro> {
  final TextEditingController _controllerNome = TextEditingController();
  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerSenha = TextEditingController();

  _validarCampos() async {

    FirebaseAuth auth = FirebaseAuth.instance;
    FirebaseFirestore db = FirebaseFirestore.instance;

    alertaErro(String? erro) {
      debugPrint("entrouu");
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text("Erro ao realizar o cadastro"),
              content: Text(erro!),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text("Fechar"))
              ],
            );
          });
    }

    String nome = _controllerNome.text;
    String email = _controllerEmail.text;
    String senha = _controllerSenha.text;

    Map<String, dynamic> conta = {
      "nome": _controllerNome.text,
      "URL" : null
    };

    if (nome.isNotEmpty) {
      if (email.isNotEmpty && email.contains("@")) {
        if (senha.isNotEmpty && senha.length >= 6) {
          await auth.createUserWithEmailAndPassword(email: email, password: senha)
              .then((value) =>
              db.collection("Clientes").doc(value.user!.uid).set(conta)
          ).then((value) => Navigator.pushNamedAndRemoveUntil(context, RouteGenerator.rotaHome, (_)=>false)
          ).catchError((error) => alertaErro(error.toString()));
        } else {
          alertaErro("A senha deve ter pelo menos 6 caracteres");
        }
      } else {
        alertaErro("Preencha um E-mail válido!");
      }
    } else {
      alertaErro("Preencha o nome!");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Cadastro"),
        backgroundColor: const Color(0xff075E54),
      ),
      body: Container(
        decoration: const BoxDecoration(color: Color(0xff075E54)),
        padding: const EdgeInsets.all(16),
        child: Center(
            child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Image.asset(
                "images/usuario.png",
                width: 200,
                height: 150,
              ),
              const SizedBox(height: 20),
              TextField(
                autofocus: true,
                keyboardType: TextInputType.text,
                style: const TextStyle(fontSize: 20),
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.fromLTRB(32, 16, 32, 16),
                  hintText: "Nome",
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
              const SizedBox(height: 10),
              TextField(
                keyboardType: TextInputType.emailAddress,
                style: const TextStyle(fontSize: 20),
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.fromLTRB(32, 16, 32, 16),
                  hintText: "E-mail",
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
                controller: _controllerEmail,
              ),
              const SizedBox(height: 10),
              TextField(
                keyboardType: TextInputType.visiblePassword,
                style: const TextStyle(fontSize: 20),
                obscureText: true,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.fromLTRB(32, 16, 32, 16),
                  hintText: "Senha",
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
                controller: _controllerSenha,
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
                      borderRadius: BorderRadius.circular(
                          32), // Define o raio dos cantos do botão
                    ),
                  ),
                ),
                onPressed: () {
                  _validarCampos();
                },
                child: const Text(
                  "Cadastrar",
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ),
              ),
            ],
          ),
        )),
      ),
    );
  }
}

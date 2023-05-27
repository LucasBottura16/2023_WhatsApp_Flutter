import 'package:firebase/routeGenerator.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerSenha = TextEditingController();

  _validarCampos() async {
    FirebaseAuth auth = FirebaseAuth.instance;

    alertaErro(String erro) {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text("Erro ao realizar o cadastro"),
              content: Text(erro),
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

    String email = _controllerEmail.text;
    String senha = _controllerSenha.text;

    if (email.isNotEmpty && email.contains("@")) {
      if (senha.isNotEmpty) {
        await auth
            .signInWithEmailAndPassword(email: email, password: senha)
            .then((value) => Navigator.pushReplacementNamed(context, RouteGenerator.rotaHome))
            .catchError((error) => alertaErro(error.toString()));
      } else {
        alertaErro("A senha deve ter pelo menos 6 caracteres");
      }
    } else {
      alertaErro("Preencha um E-mail válido!");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      decoration: const BoxDecoration(color: Color(0xff075E54)),
      padding: const EdgeInsets.all(16),
      child: Center(
          child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Image.asset(
              "images/logo.png",
              width: 200,
              height: 150,
            ),
            const SizedBox(height: 20),
            TextField(
              autofocus: true,
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
              obscureText: true,
              keyboardType: TextInputType.visiblePassword,
              style: const TextStyle(fontSize: 20),
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
                backgroundColor: MaterialStateProperty.all<Color>(Colors.green),
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
                "Entrar",
                style: TextStyle(fontSize: 20, color: Colors.white),
              ),
            ),
            const SizedBox(height: 10),
            Center(
              child: GestureDetector(
                child: const Text("Não tem conta ? Cadastre-se!",
                    style: TextStyle(color: Colors.white)),
                onTap: () {
                  Navigator.pushNamed(context, RouteGenerator.rotaCadastro);
                },
              ),
            )
          ],
        ),
      )),
    ));
  }
}

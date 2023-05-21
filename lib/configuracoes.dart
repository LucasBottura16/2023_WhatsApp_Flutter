import 'package:flutter/material.dart';

class Configuracoes extends StatefulWidget {
  const Configuracoes({Key? key}) : super(key: key);

  @override
  State<Configuracoes> createState() => _ConfiguracoesState();
}

class _ConfiguracoesState extends State<Configuracoes> {

  final TextEditingController _controllerNome = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Configurações"),
        backgroundColor: const Color(0xff075E54),
      ),
      body: Container(
        padding:const EdgeInsets.all(16),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                const CircleAvatar(
                  radius: 100,
                  backgroundColor: Colors.grey,
                  backgroundImage:
                  NetworkImage("https://firebasestorage.googleapis.com/v0/b/fir-flutter-8e6f4.appspot.com/o/Perfil%2Fperfil4.jpg?alt=media&token=8a7f2564-d5ef-4aff-b3ee-7d893144a90e")
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                        onPressed: (){},
                        child: const Text("Camera")
                    ),
                    const SizedBox(width: 20,),
                    TextButton(
                        onPressed: (){},
                        child: const Text("Galeria")
                    ),
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}

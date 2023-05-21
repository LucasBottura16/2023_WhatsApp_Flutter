import 'package:firebase/model/conversa.dart';
import 'package:flutter/material.dart';

class AbaConversas extends StatefulWidget {
  const AbaConversas({Key? key}) : super(key: key);

  @override
  State<AbaConversas> createState() => _AbaConversasState();
}

class _AbaConversasState extends State<AbaConversas> {

  List<Conversas> listaConversa = [
    Conversas(
        "Lucas",
        "Salve salve Familia",
        "https://firebasestorage.googleapis.com/v0/b/fir-flutter-8e6f4.appspot.com/o/Perfil%2Fperfil4.jpg?alt=media&token=8a7f2564-d5ef-4aff-b3ee-7d893144a90e"
    ),
    Conversas(
        "Daniela",
        "Transfere para op itau",
        "https://firebasestorage.googleapis.com/v0/b/fir-flutter-8e6f4.appspot.com/o/Perfil%2Fperfil1.jpg?alt=media&token=b8137bc2-c0f2-4ac1-8f62-80523130b3fa"
    ),
    Conversas(
        "Leonardo",
        "Salve salve Familia",
        "https://firebasestorage.googleapis.com/v0/b/fir-flutter-8e6f4.appspot.com/o/Perfil%2Fperfil2.jpg?alt=media&token=90ea5a20-608f-49e3-bf25-43e459f92503"
    ),
    Conversas(
        "Margarida",
        "O lo ja comeu?",
        "https://firebasestorage.googleapis.com/v0/b/fir-flutter-8e6f4.appspot.com/o/Perfil%2Fperfil3.jpg?alt=media&token=bb5221e2-c5a5-47c5-82bc-e11f778a4cd2"
    ),
    Conversas(
        "Lorenzo",
        "Posso jogar ?",
        "https://firebasestorage.googleapis.com/v0/b/fir-flutter-8e6f4.appspot.com/o/Perfil%2Fperfil5.jpg?alt=media&token=346845b1-b1f2-449a-9bf9-450b5f779d45"
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: listaConversa.length,
      itemBuilder: (context, index){

        Conversas conversas = listaConversa[index];

        return ListTile(
          contentPadding:  const EdgeInsets.fromLTRB(16, 8, 16, 8),
          leading: CircleAvatar(
            backgroundColor: Colors.grey,
            backgroundImage: NetworkImage(conversas.caminhoFoto),
            maxRadius: 30,
          ),
          title: Text(conversas.nome, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          subtitle: Text(conversas.mensagem, style: const TextStyle(fontSize: 14, color: Colors.grey)),

        );

      },

    );
  }
}

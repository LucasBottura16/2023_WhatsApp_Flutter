import 'package:firebase/model/usuario.dart';
import 'package:flutter/material.dart';

class TelaMensagens extends StatefulWidget {

  Usuario contato;

  TelaMensagens(this.contato, {super.key});

  @override
  State<TelaMensagens> createState() => _TelaMensagensState();
}

class _TelaMensagensState extends State<TelaMensagens> {

  final TextEditingController _controllerMensagem = TextEditingController();
  List<String> listaMensgem = [
    "A vida é uma aventura, aproveite cada momento!",
        "Acredite em si mesmo e alcance grandes conquistas.",
        "O sorriso é o melhor acessório que você pode usar.",
        "A persistência é a chave para o sucesso.",
        "Nunca desista, pois grandes coisas levam tempo.",
        "Seja a mudança que você deseja ver no mundo.",
        "Sonhe grande e faça acontecer!",
        "Espalhe amor e gentileza por onde passar.",
        "A felicidade está nas coisas simples da vida.",
        "Aproveite cada dia como se fosse o último.",
        "Acredite no poder dos seus sonhos e faça acontecer.",
        "Nunca é tarde demais para buscar a felicidade e realizar seus objetivos.",
        "Cada novo dia é uma oportunidade para recomeçar e fazer melhor.",
        "A gratidão transforma momentos comuns em momentos especiais.",
  ];

  _enviaMensagem(){

    String textoMensagem = _controllerMensagem.text;

    if( textoMensagem.isNotEmpty ){

    }

  }
  _enviaFoto(){

  }

  @override
  Widget build(BuildContext context) {

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
                    prefixIcon: IconButton(
                      icon: const Icon(Icons.camera_alt),
                      onPressed: _enviaFoto,
                    )
                  ),
                  controller: _controllerMensagem,
                ),
            ),
            const SizedBox(width: 8),
            FloatingActionButton(
              backgroundColor: const Color(0xff075E54),
              mini: true,
              onPressed: _enviaMensagem,
              child: const Icon(Icons.send, color: Colors.white,),

            )
          ],
        )
    );

    Widget listViewMensagem = Expanded(
        child: ListView.builder(
            itemCount: listaMensgem.length,
            itemBuilder: (context, index){

              Alignment alignmentMensagem = Alignment.centerRight;
              Color corMensagem = const Color(0xffd2ffa5);
              if(index % 2 == 0){
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
                      borderRadius: BorderRadius.circular(8)
                    ),
                    child: Text(listaMensgem[index], style: const TextStyle(fontSize: 18),),
                  ),
                ),
              );

            }
        )
    );

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(
                radius: 20,
                backgroundColor: Colors.grey,
                backgroundImage: widget.contato.url != null
                    ? NetworkImage(widget.contato.url.toString())
                    : null),
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
            image: AssetImage("images/bg.png"),
            fit: BoxFit.cover
          )
        ),
        child: SafeArea(
          child: Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                listViewMensagem,
                caixaMensagem
              ],
            ),
          )
        ),
      )
    );
  }
}

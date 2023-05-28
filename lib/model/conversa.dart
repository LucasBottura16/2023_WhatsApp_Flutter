import 'package:cloud_firestore/cloud_firestore.dart';


class Conversas {

  String? _idRemetente;
  String? _idDestinatario;
  String?  _nome;
  String? _mensagem;
  String? _caminhoFoto;
  String? _tipoMensagem;


  Conversas();

  salvar() async {

    FirebaseFirestore firestore = FirebaseFirestore.instance;

    await firestore.collection("Conversas").doc(_idRemetente)
        .collection("ultima_conversa").doc(_idDestinatario).set(toMap());

  }

  Map<String, dynamic> toMap(){
    Map<String, dynamic> map = {
      "idRemetente" : _idRemetente,
      "idDestinatario" : _idDestinatario,
      "nome" : _nome,
      "mensagem" : _mensagem,
      "caminhoFoto" : _caminhoFoto,
      "tipoMensagem" : _tipoMensagem
    };
    return map;
  }

  String get idRemetente => _idRemetente!;

  set idRemetente(String value) {
    _idRemetente = value;
  }

  String get nome => _nome!;

  set nome(String value) {
    _nome = value;
  }

  String get mensagem => _mensagem!;

  String get caminhoFoto => _caminhoFoto!;

  set caminhoFoto(String value) {
    _caminhoFoto = value;
  }

  set mensagem(String value) {
    _mensagem = value;
  }

  String get idDestinatario => _idDestinatario!;

  set idDestinatario(String value) {
    _idDestinatario = value;
  }

  String get tipoMensagem => _tipoMensagem!;

  set tipoMensagem(String value) {
    _tipoMensagem = value;
  }
}

class Mensagem {

  String? _idUsuario;
  String? _mensagem;
  String? _url;
  String? _tipo;

  Mensagem();

  Map<String, dynamic> toMap(){

    Map<String, dynamic> map = {
      "_idUsuario" : _idUsuario,
      "_mensagem" : _mensagem,
      "_url" : _url,
      "_tipo" : _tipo
    };

    return map;

  }

  String get tipo => _tipo!;

  set tipo(String value) {
    _tipo = value;
  }

  String get url => _url!;

  set url(String value) {
    _url = value;
  }

  String get mensagem => _mensagem!;

  set mensagem(String value) {
    _mensagem = value;
  }

  String get idUsuario => _idUsuario!;

  set idUsuario(String value) {
    _idUsuario = value;
  }
}
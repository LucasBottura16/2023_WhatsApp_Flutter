
class Usuario {

  String? _uidUsuario;
  String? _nome;
  String? _url;


  Usuario();

  Map<String, dynamic> toMap(){
    Map<String, dynamic> map = {
      "nome" : nome,
      "URl" : url
    };
    return map;
  }

  String get uidUsuario => _uidUsuario!;

  set uidUsuario(String value) {
    _uidUsuario = value;
  }

  String get url => _url!;

  set url(String value) {
    _url = value;
  }

  String get nome => _nome!;

  set nome(String value) {
    _nome = value;
  }

}
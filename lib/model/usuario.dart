
class Usuario {

  String? _nome;
  String? _url;


  Usuario();

  Map<String, dynamic>? toMap(){
    Map<String, dynamic> map = {
      "nome" : nome,
      "URl" : url
    };
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
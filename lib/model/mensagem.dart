import 'package:flutter/material.dart';

class Mensagem {

  String? _idUsuario;
  String? _mensagem;
  String? _url;
  String? _tipo;

  Mensagem();

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
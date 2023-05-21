import 'package:firebase/configuracoes.dart';
import 'package:flutter/material.dart';
import 'package:firebase/cadastro.dart';
import 'package:firebase/home.dart';
import 'package:firebase/login.dart';


class RouteGenerator {

  static const String rotaHome = "/home";
  static const String rotaLogin = "/login";
  static const String rotaCadastro = "/cadastro";
  static const String rotaConfig = "/config";

  static Route<dynamic>? generateRoute(RouteSettings settings){



    switch(settings.name){
      case "/":
        return MaterialPageRoute(builder: (_) => const Login());
      case rotaLogin:
        return MaterialPageRoute(builder: (_) => const Login());
      case rotaCadastro:
        return MaterialPageRoute(builder: (_) => const Cadastro());
      case rotaHome:
        return MaterialPageRoute(builder: (_) => const MyHome());
      case rotaConfig:
        return MaterialPageRoute(builder: (_) => const Configuracoes());
        default:
        _erroRota();
    }
    return null;
  }

  static Route<dynamic>? _erroRota(){
    return MaterialPageRoute(
        builder: (_) {
          return Scaffold(
            appBar: AppBar(
              title: const Text("Tela não encotrada"),
            ),
            body: const Center(
              child:  Text("Tela não encotrada"),
            ),
          );
        }
    );
  }

}
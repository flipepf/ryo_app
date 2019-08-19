import 'package:flutter/material.dart';
import 'package:ryo_app/pages/criarContaPage.dart';
import 'package:ryo_app/pages/homePage.dart';
import 'package:ryo_app/pages/loginPage.dart';
import 'package:scoped_model/scoped_model.dart';

import 'models/carrinhoModel.dart';
import 'models/usuarioModel.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScopedModel<UsuarioModel>(
      model:
          UsuarioModel(), //TUDO O QUE ESTA ABAIXO DE scopedModel TERÁ ACESSO UsuarioModel E PODE SER MODIFICADO CASO HAJA ALGUMA ALTERAÇÃO NELE
      child: ScopedModelDescendant<UsuarioModel>( //PARA CADA VEZ QUE TROQUE DE USUARIO ELE REFAÇA O CARRINHO
          builder: (context, child, model) {
        return ScopedModel<CarrinhoModel>(
          model: CarrinhoModel(model),
          child: MaterialApp(
              title: 'Ryo App',
              debugShowCheckedModeBanner: false,
              theme: ThemeData(
                primarySwatch: Colors.blue,
                primaryColor: Color.fromARGB(255, 180, 0, 0),
              ),
              home: HomePage()),
        );
      }),
    );
  }
}

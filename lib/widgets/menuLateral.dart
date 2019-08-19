import 'package:flutter/material.dart';
import 'package:ryo_app/models/usuarioModel.dart';
import 'package:ryo_app/pages/loginPage.dart';
import 'package:ryo_app/tiles/itemMenu.dart';
import 'package:scoped_model/scoped_model.dart';

class MenuLateral extends StatelessWidget {
  final PageController pageController;

  MenuLateral(this.pageController);

  @override
  Widget build(BuildContext context) {
    //############################################################# COR DE FUNDO
    Widget _fundo() => Container(
            decoration: BoxDecoration(
          color: Colors.white,
          /*gradient: LinearGradient(colors: [
      Color.fromARGB(255, 203, 236, 241),
      Color.fromARGB(255, 255, 255, 255)
      ], begin: Alignment.topCenter, end: Alignment.bottomCenter)*/
        ));
    //##########################################################################
    return Drawer(
        child: Stack(children: <Widget>[
      _fundo(),
      ListView(padding: EdgeInsets.only(left: 32.0, top: 10.0), children: <
          Widget>[
        //######################################################################
        Container(
          margin: EdgeInsets.only(bottom: 8.0),
          padding: EdgeInsets.fromLTRB(0.0, 16.0, 16.0, 8.0),
          height: 170.0,
          child: Stack(children: <Widget>[
            Positioned(
              top: 15.0,
              left: 0.0,
              child: Text(
                "Ryo Sushi",
                style: TextStyle(fontSize: 34.0, fontWeight: FontWeight.bold),
              ),
            ),
            //######################################################################
            Positioned(
              left: 0.0,
              bottom: 0.0,
              child: ScopedModelDescendant<UsuarioModel>(
                  builder: (context, child, model) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "Olá, ${!model.isLoggedIn() ? "" : model.dadosUsuario["nome"]}",
                      style: TextStyle(
                          fontSize: 18.0, fontWeight: FontWeight.bold),
                    ),
                    //#########################################################
                    GestureDetector(
                      child: Text(
                        !model.isLoggedIn() ?
                        "Entre ou cadastre-se >"
                        : "Sair",
                        style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold),
                      ),
                      onTap: () {
                        if (!model.isLoggedIn())
                          Navigator.of(context).push(
                              MaterialPageRoute( builder: (context) => LoginPage()));
                        else
                          model.signOut();
                      },
                    )
                  ],
                );
              }),
            )
          ]),
        ),
        Divider(),
        ItemMenu(Icons.home, "Início", pageController, 0),
        ItemMenu(Icons.list, "Produtos", pageController, 1),
        ItemMenu(Icons.location_on, "Como Encontrar", pageController, 2),
        ItemMenu(Icons.playlist_add_check, "Meus Pedidos", pageController, 3),
      ]),
    ]));
  }
}

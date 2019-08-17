import 'package:flutter/material.dart';
import 'package:ryo_app/tiles/itemMenu.dart';

class MenuLateral extends StatelessWidget {

  final PageController pageController;

  MenuLateral(this.pageController);

  @override
  Widget build(BuildContext context) {
    //###################################### GERA A COR DEGRADE NO FUNDO DO MENU
    Widget _fundo() => Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(colors: [
          Color.fromARGB(255, 203, 236, 241),
          Color.fromARGB(255, 255, 255, 255)
        ], begin: Alignment.topCenter, end: Alignment.bottomCenter)));
    //##########################################################################


    return Drawer(
        child: Stack(children: <Widget>[
      _fundo(),
      ListView(
          padding: EdgeInsets.only(left: 32.0, top: 10.0),
          children: <Widget>[
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
                    style:
                        TextStyle(fontSize: 34.0, fontWeight: FontWeight.bold),
                  ),
                ),
                Positioned(
                  left: 0.0,
                  bottom: 0.0,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        "Olá, ",
                        style: TextStyle(
                            fontSize: 18.0, fontWeight: FontWeight.bold),
                      ),
                      GestureDetector(
                        child: Text(
                          "Entre ou cadastre-se >",
                          style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold),
                        ),
                        onTap: () {},
                      )
                    ],
                  ),
                ),
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

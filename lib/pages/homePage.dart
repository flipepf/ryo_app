import 'package:flutter/material.dart';
import 'package:ryo_app/tabs/homeTab.dart';
import 'package:ryo_app/widgets/menuLateral.dart';
import 'package:ryo_app/tabs/categoriasTab.dart';

class HomePage extends StatelessWidget {
  final _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return PageView(
      controller: _pageController,
      physics: NeverScrollableScrollPhysics(),
      children: <Widget> [
        Scaffold (
          body: HomeTab(),
          drawer: MenuLateral(_pageController),
        ),
        Scaffold(
          appBar: AppBar(
          title: Text("Produtos"),
          centerTitle: true,
        ),
          drawer: MenuLateral(_pageController),
          body: CategoriasTab(),
        ),
      ]
    );
  }
}

import 'package:flutter/material.dart';
import 'package:ryo_app/tabs/homeTab.dart';
import 'package:ryo_app/tabs/pedidosTab.dart';
import 'package:ryo_app/widgets/botaoCarrinho.dart';
import 'package:ryo_app/widgets/menuLateral.dart';
import 'package:ryo_app/tabs/categoriasTab.dart';
import '../firebase_messaging.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _pageController = PageController();

  //###########################################################################
  final _firebaseNotifications = new FirebaseNotifications();

  @override
  void initState() {
    super.initState();
    _firebaseNotifications.iniciarFirebaseListeners();
  }
  //#######################################################################################
  @override
  Widget build(BuildContext context) {
    return PageView(
      controller: _pageController,
      physics: NeverScrollableScrollPhysics(),
      children: <Widget> [
        //######################################################################
        Scaffold (
          body: HomeTab(),
          drawer: MenuLateral(_pageController),
          floatingActionButton: BotaoCarrinho(),
        ),
        //######################################################################
        Scaffold(
          appBar: AppBar(
          title: Text("Produtos"),
          centerTitle: true,
        ),
          drawer: MenuLateral(_pageController),
          body: CategoriasTab(),
          floatingActionButton: BotaoCarrinho(),
        ),
        //######################################################################
        Scaffold(
          appBar: AppBar(
            title: Text("Meus Pedidos"),
            centerTitle: true,
          ),
          body: PedidosTab(),
          drawer: MenuLateral(_pageController),
        ),
      ]
    );
  }
}
import 'package:flutter/material.dart';
import 'package:ryo_app/models/carrinhoModel.dart';
import 'package:ryo_app/models/usuarioModel.dart';
import 'package:ryo_app/pages/loginPage.dart';
import 'package:ryo_app/tiles/ItemCarrinho.dart';
import 'package:ryo_app/widgets/cardDesconto.dart';
import 'package:ryo_app/widgets/cardTotal.dart';
import 'package:scoped_model/scoped_model.dart';

class CarrinhoPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Meu Carrinho"),
        centerTitle: true,
        actions: <Widget>[
          Container(
            padding: EdgeInsets.only(right: 8.0),
            alignment: Alignment.center,
            child: ScopedModelDescendant<CarrinhoModel>(
              builder: (context, child, model) {
                int p =
                    model.produtos.length; //QUANTODADE DE PRODUTOS NO CARRINHO
                return Text(
                  "${p ?? 0} ${p == 1 ? "ITEM" : "ITENS"}", //SE for NULO RETORNARA 0 SENÃO MOSTRA A QUANTODADE DE ITEMS NO CARRINHO
                  style: TextStyle(fontSize: 17.0),
                );
              },
            ),
          )
        ],
      ),
      body: ScopedModelDescendant<CarrinhoModel>(
          builder: (context, child, model) {
        if (model.isLoading && UsuarioModel.of(context).isLoggedIn()) {
          //SE ESTA CARREGANDO E ESTIVER LOGADO
          return Center(
            child: CircularProgressIndicator(), //ANIMAÇÃO DE CARREGANDO
          );
        } else if (!UsuarioModel.of(context).isLoggedIn()) {
          //SE O USUARIO NÃO ESTIVER LOGADO
          //############################ RETORNA UMA TELA PARA EFETUAR LOGIN
          return Container(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(
                  Icons.remove_shopping_cart,
                  size: 80.0,
                  color: Theme.of(context).primaryColor,
                ),
                SizedBox(
                  height: 16.0,
                ),
                Text(
                  "Faça o login para adicionar produtos!",
                  style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: 16.0,
                ),
                RaisedButton(
                  child: Text(
                    "Entrar",
                    style: TextStyle(fontSize: 18.0),
                  ),
                  textColor: Colors.white,
                  color: Theme.of(context).primaryColor,
                  onPressed: () {
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => LoginPage()));
                  },
                )
              ],
            ),
          );
          //########################################## SE NÃO TEM NENHUM PRODUTO
        } else if (model.produtos == null || model.produtos.length == 0) {
          return Center(
            child: Text(
              "Nenhum produto no carrinho!",
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          );
        //###################### CASO TENHA PRODUTOS NO CARRINHO E ESTAJA LOGADO
        } else {
          return ListView(
            children: <Widget>[
              Column(
                children: model.produtos.map((produto) {
                  return ItemCarrinho(produto);
                }).toList(),
              ),
              CardDesconto(),
              //CardeEntrega(),
              CardTotal(() async {
                    String idPedido = await model.finalizarPedido();
                    if(idPedido != null) //SE RETORNOU O PEDIDO
                      print(idPedido);
                      /*Navigator.of(context).pushReplacement(
                          MaterialPageRoute(builder: (context)=>OrderScreen(idPedido))
                      );*/
                  }),
            ],
          );
        }
      }),
    );
  }
}

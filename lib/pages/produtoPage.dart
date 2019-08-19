import 'package:flutter/material.dart';
import 'package:ryo_app/datas/carrinhoData.dart';
import 'package:ryo_app/datas/produtoData.dart';
import 'package:ryo_app/models/carrinhoModel.dart';
import 'package:ryo_app/models/usuarioModel.dart';

import 'carrinhoPage.dart';
import 'loginPage.dart';

class ProdutoPage extends StatefulWidget {
  final ProdutoData produto;
  ProdutoPage(this.produto);

  @override
  _ProdutoPageState createState() => _ProdutoPageState(produto);
}

class _ProdutoPageState extends State<ProdutoPage> {
  final ProdutoData produto;
  _ProdutoPageState(this.produto);

  @override
  Widget build(BuildContext context) {
    final Color primaryColor = Theme.of(context).primaryColor;

    return Scaffold(
      appBar: AppBar(
        title: Text(produto.nome),
        centerTitle: true,
      ),
      body: ListView(
        children: <Widget>[
          //######################################################################
          AspectRatio(
            aspectRatio: 1.0,
            child: Image.network(
              produto.imagem,
              fit: BoxFit.cover,
            ),
          ),
          //####################################################################
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                //############################################## NOME DO PRODUTO
                Text(
                  produto.nome,
                  style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.w500),
                  maxLines: 3,
                ),
                //############################################# VALOR DO PRODUTO
                Text(
                  "R\$ ${produto.valor.toStringAsFixed(2)}",
                  style: TextStyle(
                      fontSize: 28.0,
                      fontWeight: FontWeight.bold,
                      color: primaryColor),
                ),
                //###############################################################
                SizedBox(
                  height: 16.0,
                ), //ESPAÇAMENTO ENTRE LINHAS OU COLUNAS
                SizedBox(
                  height: 46.0,
                  child: RaisedButton(
                    onPressed: () {
                      if (UsuarioModel.of(context).isLoggedIn()) {
                        //FUNÇÃO of CRIADA PARA ACESSAR AS FUNÇÕES DE usuarioModel EM QUALQUER PARTE DO APP
                        //SE O USUARIO ESTIVER LOGADO, ADICIONA AO CARRINHO
                        CarrinhoData prod = CarrinhoData();
                        prod.quantidade = 1;
                        prod.produtoId = produto.id;
                        prod.categoria = produto.categoria;
                        //produto.ProdutoData = produto;
                        CarrinhoModel.of(context).addItemCarrinho(prod);
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => CarrinhoPage()));
                      } else {
                        //SE NÃO ABRE A TELA PARA O USUARIO LOGAR
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => LoginPage()));
                      }
                    },
                    child: Text(
                      UsuarioModel.of(context).isLoggedIn()
                          ? "Adicionar ao Carrinho"
                          : "Entre para Comprar",
                      style: TextStyle(fontSize: 20.0),
                    ),
                    color: primaryColor,
                    textColor: Colors.white,
                  ),
                ),
                SizedBox(
                  height: 16.0,
                ),
                //##############################################################
                Text(
                  "Descrição",
                  style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w500),
                ),
                Text(
                  produto.descricao,
                  style: TextStyle(fontSize: 18.0),
                )
                //##############################################################
              ],
            ),
          )
        ],
      ),
    );
  }
}
//}

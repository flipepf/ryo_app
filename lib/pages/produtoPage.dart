import 'package:flutter/material.dart';
import 'package:ryo_app/datas/produtoData.dart';

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
                  style: TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.w500
                  ),
                  maxLines: 3,
                ),
                //############################################# VALOR DO PRODUTO
                Text(
                  "R\$ ${produto.valor.toStringAsFixed(2)}",
                  style: TextStyle(
                      fontSize: 28.0,
                      fontWeight: FontWeight.bold,
                      color: primaryColor
                  ),
                ),
                //###############################################################
                SizedBox(height: 16.0,),//ESPAÇAMENTO ENTRE LINHAS OU COLUNAS
                SizedBox(
                  height: 46.0,
                  child: RaisedButton(
                    onPressed: (){ },
                    /*  if(UserModel.of(context).isLoggedIn()){
                        CartProduct cartProduct = CartProduct();
                        cartProduct.quantidade = 1;
                        cartProduct.pid = produto.id;
                        cartProduct.categoria = produto.categoria;
                        cartProduct.produtoData = produto;
                        CartModel.of(context).addCartItem(cartProduct);
                        Navigator.of(context).push(
                            MaterialPageRoute(builder: (context)=>CarrinhoPage())
                        );
                      } else {
                        Navigator.of(context).push(
                            MaterialPageRoute(builder: (context)=>LoginScreen())
                        );
                      }
                    } */
                    child: Text("Adicionar ao Carrinho",
                      style: TextStyle(fontSize: 20.0),
                    ),
                    /*child: Text(UserModel.of(context).isLoggedIn() ? "Adicionar ao Carrinho"
                        : "Entre para Comprar",
                      style: TextStyle(fontSize: 18.0),
                    ),*/
                    color: primaryColor,
                    textColor: Colors.white,
                  ),
                ),
                SizedBox(height: 16.0,),
                //##############################################################
                Text(
                  "Descrição",
                  style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.w500
                  ),
                ),
                Text(
                  produto.descricao,
                  style: TextStyle(
                      fontSize: 18.0
                  ),
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

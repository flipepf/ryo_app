import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ryo_app/datas/carrinhoData.dart';
import 'package:ryo_app/datas/produtoData.dart';
import 'package:ryo_app/models/carrinhoModel.dart';

class ItemCarrinho extends StatelessWidget {
  final CarrinhoData produto;
  ItemCarrinho(this.produto);

  @override
  Widget build(BuildContext context) {
    Widget _buildContent(){
      CarrinhoModel.of(context).updateValor();
      return Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(8.0),
            width: 120.0,
            child: Image.network(
              produto.produtoData.imagem,
              fit: BoxFit.cover,
            ),
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  //####################################################### NOME
                  Text(
                    produto.produtoData.nome,
                    style: TextStyle(fontWeight: FontWeight.w500, fontSize: 17.0),
                  ),
                  //###################################################### VALOR
                  Text(
                    "R\$ ${produto.produtoData.valor.toStringAsFixed(2)}",
                    style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold
                    ),
                  ),
                  //################################################# QUANTIDADE
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      IconButton(
                        icon: Icon(Icons.remove),
                        color: Theme.of(context).primaryColor,
                        onPressed: produto.quantidade > 1 ?
                            (){
                          CarrinhoModel.of(context).decQuantidade(produto);
                        } : null,
                      ),
                      Text(produto.quantidade.toString()),
                      IconButton(
                        icon: Icon(Icons.add),
                        color: Theme.of(context).primaryColor,
                        onPressed: (){
                          CarrinhoModel.of(context).incQuantidade(produto);
                        },
                      ),
                      FlatButton(
                        child: Text("Remover"),
                        textColor: Colors.grey[500],
                        onPressed: (){
                          CarrinhoModel.of(context).removeItemCarrinho(produto);
                        },
                      )
                    ],
                  )
                ],
              ),
            ),
          )
        ],
      );
    }
    //############################################ CARD DOS PRODUTOS NO CARRINHO
    return Card(
        margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
        child: produto.produtoData == null ?
        FutureBuilder<DocumentSnapshot>(
          future: Firestore.instance.collection("produtos").document(produto.categoria)
              .collection("items").document(produto.produtoId).get(), //PEGA OS DADOS DO BANCO
          builder: (context, snapshot){
            if(snapshot.hasData){ //SE O SNAPSHOT TEM DADOS
              produto.produtoData = ProdutoData.fromDocument(snapshot.data); //CONVERTE O DOCUMENTO RECEBIDO DO FIREBASE E SALVA NO OBJETO
              return _buildContent();
            } else { //SE NÃO RETORNA UMA ANIMAÇÃO DE CARREGANDO
              return Container(
                height: 70.0,
                child: CircularProgressIndicator(),
                alignment: Alignment.center,
              );
            }
          },
        ) :
        _buildContent()
    );
  }
}

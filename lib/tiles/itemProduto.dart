import 'package:flutter/material.dart';
import 'package:ryo_app/datas/produtoData.dart';
import 'package:ryo_app/pages/produtosPage.dart';

class ItemProduto extends StatelessWidget {
  final String tipo;
  final ProdutoData produto;

  ItemProduto(this.tipo, this.produto);

  @override
  Widget build(BuildContext context) {
    return InkWell( //DIFERENTE DO GestureDetecteed AO SER CLICADO ESSE WIDGET TEM ANIMAÇÃO
      onTap: (){
        Navigator.of(context).push(
            MaterialPageRoute(builder: (context)=>ProdutoPage(produto))
        );
      },
      child: Card(
        child: tipo == "grid"
            ? Column( //################# SE O TIPO FOR GRID CONSTROI UMA COLUNA
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            //################################################ IMAGEM DO PRODUTO
            AspectRatio(
              aspectRatio: 1.0,
              child: Image.network(
                produto.imagem,
                fit: BoxFit.cover,
              ),
            ),
            //########################################### INFORMAÇÕES DO PRODUTO
            Expanded(
              child: Container(
                padding: EdgeInsets.all(8.0),
                child: Column(
                  children: <Widget>[
                    // ######################################### NOME DO PRODUTO
                    Text(
                      produto.nome,
                      style: TextStyle(fontSize: 18.0,fontWeight: FontWeight.w900),
                      textAlign: TextAlign.center,
                    ),
                    // ######################################## VALOR DO PRODUTO
                    Text(
                      "R\$ ${produto.valor.toStringAsFixed(2)}",
                      style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontSize: 19.0,
                          fontWeight: FontWeight.bold),
                    )
                  ],
                ),
              ),
            )
          ],
        )
        //######################################################################
            : Row( // ################ SE O TIPO NÃO FOR GRID CONSTROI UMA LINHA
          children: <Widget>[
            //################################################ IMAGEM DO PRODUTO
            Flexible(
              flex: 1,
              child: Image.network(
                produto.imagem,
                fit: BoxFit.cover,
                height: 180.0,
              ),
            ),
            //########################################### INFORMAÇÕES DO PRODUTO
            Flexible(
              flex: 1,
              child: Container(
                padding: EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    // ######################################### NOME DO PRODUTO
                    Text(
                      produto.nome,
                      style: TextStyle(fontSize: 17.0, fontWeight: FontWeight.w900),
                    ),
                    // ######################################## VALOR DO PRODUTO
                    Text(
                      "R\$ ${produto.valor.toStringAsFixed(2)}",
                      style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
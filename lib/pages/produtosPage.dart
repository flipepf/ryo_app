import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ryo_app/datas/produtoData.dart';
import 'package:ryo_app/tiles/itemProduto.dart';

class ProdutosPage extends StatelessWidget {

  final DocumentSnapshot snapshot;

  ProdutosPage(this.snapshot);

  Widget build(BuildContext context) {
    return DefaultTabController( //TABS COM ESTILO GRADE OU LISTA
      length: 2,    //QUANTIODADE DE TABS
      child: Scaffold(
          appBar: AppBar(
            title: Text(snapshot.data["nome"]), //NOME DA CATEGORIA SELECIONADA
            centerTitle: true,
            bottom: TabBar(
              indicatorColor: Colors.white, //COR DA TAB SELECIONADA
              tabs: <Widget>[
                Tab(icon: Icon(Icons.grid_on),),
                Tab(icon: Icon(Icons.list),)
              ],
            ),
          ),
          body: FutureBuilder<QuerySnapshot>( //FUTURE DO TIPO QuerySnapshot (FOTOGRAFIA DE UMA COLEÇÃO)
              future: Firestore.instance.collection("produtos").document(snapshot.documentID) //snapshot.documentID REFERE-SE AO SNAPSHOT QUE FOI PASSADO POR PARAMETRO NO CONSTRUTOR E QUE SE REFERE A CATEGORIA SELECIONADA
                  .collection("items").getDocuments(),
              builder: (context, snapshot){
                if(!snapshot.hasData) //SE O SNAPSHOT NÃO TEM NENHUM DADO
                  return Center(child: CircularProgressIndicator(),); //CIRCULO DE CARREGANDO
                else
                  return TabBarView(
                      physics: NeverScrollableScrollPhysics(), // DESLISAR DE UMA TAB PARA OUTRA APENAS PELOS BOTÕES DO APPBAR
                      children: [
                        GridView.builder( //.builder PARA NÃO CARREGAR TODOS OS PRODUTOS AO MEMSO TEMPO, CARREGA CONFORME DESLIZA
                            padding: EdgeInsets.all(4.0),
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount( //DEFINE QUANTOS ITENS TEM NA HORIZONTAL
                              crossAxisCount: 2,
                              mainAxisSpacing: 4.0,
                              crossAxisSpacing: 4.0,
                              childAspectRatio: 0.65, //RAZÃO ENTRE ALTURA E LARGURA
                            ),
                            itemCount: snapshot.data.documents.length, //DEFINE QUANTOS ITEMS TEM NO GRID, SEGUNDO A QUANTIDADE DE DOCUMENTOS QUE O SNAPSHOT RETORNOU
                            itemBuilder: (context, index){
                              ProdutoData data = ProdutoData.fromDocument(snapshot.data.documents[index]); //TRANSFORMA CADA DOCUMENTO QUE RETORNA EM UM OBJETO DO TIPO ProdutoData
                              data.categoria = this.snapshot.documentID;
                              return ItemProduto("grid", data);
                            }
                        ),
                        ListView.builder(
                            padding: EdgeInsets.all(4.0),
                            itemCount: snapshot.data.documents.length,
                            itemBuilder: (context, index){
                              ProdutoData data = ProdutoData.fromDocument(snapshot.data.documents[index]);
                              data.categoria = this.snapshot.documentID;
                              return ItemProduto("list", data);
                            }
                        )
                      ]
                  );
              }
          )
      ),
    );
  }
}

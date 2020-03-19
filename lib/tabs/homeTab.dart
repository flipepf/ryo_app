import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:transparent_image/transparent_image.dart';

class HomeTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    //####################################### GERA A COR DEGRADE NO FUNDO DA TAB
    Widget _fundo() => Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color.fromARGB(255, 180, 0, 0),
            Color.fromARGB(255, 0, 0, 0)
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter
        )
      )
    );
    //#######################################################
    return Stack(
      children: <Widget>[
        _fundo(),
        //###################################################
        CustomScrollView(
          slivers: <Widget> [     // LISTA DE SLIVERS
            SliverAppBar(         // APP BAR DO TIPO SLIVER
              floating: true,     // FLUTUANTE
              snap: true,         // COMPORTAMENTO - AO MOVIMENTAR O APPBAR FICA OCULTA AO VOLTAR UM POUCO JÁ REAPARECE
              //pinned: true,
              backgroundColor: Colors.transparent, //COR TRANSPARENTE PARA QUE APAREÇA O FUNDO
              elevation: 0.0,     // FICA NO MESMO PLANO DO CONTEÚDO
              flexibleSpace: FlexibleSpaceBar(
                title: const Text("Promoções", style: TextStyle(fontSize: 22)),
                centerTitle: true
              )
            ),
            //#################################################################
            FutureBuilder<QuerySnapshot>(
              future: Firestore.instance
                  .collection("home").orderBy("pos").getDocuments(), //PEGA TODAS AS IMAGENS DA COLEÇÃO home ORDENADA PELO CAMPO pos
              builder: (context, snapshot){
                if(!snapshot.hasData) //SE O SNAPSHOT RETORNAR VAZIO
                  return SliverToBoxAdapter( //RETORNA UM UM SLIVER QUE VAI CRIAR UMA ANIMAÇÃO DE CARREGANDO
                    child: Container(
                      height: 200.0,
                      alignment: Alignment.center,
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    ),
                  );
                else
                  return SliverStaggeredGrid.count( //COLOCA AS IMAGENS EM UMA GRADE
                    crossAxisCount: 2, //DEFINE A QUANTIDADE DE BLOCOS NA HORIZONTAL
                    mainAxisSpacing: 1.0, //ESPAÇAMENTO ENTRE AS IMAGENS NA VERTICAL
                    crossAxisSpacing: 1.0, //ESPAÇAMENTO ENTRE AS IMAGENS NA HORIZONTAL
                    staggeredTiles: snapshot.data.documents.map( //DIMENSÕES DAS IMAGENS PEGANDO
                            (doc){
                              return StaggeredTile.count(doc.data["x"], doc.data["y"]); //PARA CADA UM DOS DOCUMENTOS DE RETORNO DA FUNÇÃO ELE ESTÁ PEGANDO O x E O y E PASANDO P/ O staggeredTiles:
                            }
                    ).toList(), //TRANSFORMA O MAP PARA LIST
                    children: snapshot.data.documents.map(
                            (doc){
                          return FadeInImage.memoryNetwork( //IMAGEM QUE VAI APARECER SUAVEMENTE
                            placeholder: kTransparentImage,
                            image: doc.data["image"],
                            fit: BoxFit.cover, //COBRE TOO O ESPAÇO POSSIVEL NA GRADE
                          );
                        }
                    ).toList(),
                  );
              },
            )
          ]
        )
      ]
    );
  }
}
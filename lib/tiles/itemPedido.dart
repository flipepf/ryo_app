import 'dart:collection';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ItemPedido extends StatelessWidget {

  final String idPedido;

  ItemPedido(this.idPedido);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
      child: Padding(
        padding: EdgeInsets.all(8.0),
        child: StreamBuilder<DocumentSnapshot>( //StreamBuilder PARA OBSERVAR A ALTERAÇÃO DO STATUS DO PEDIDO
            stream: Firestore.instance.collection("pedidos").document(idPedido).snapshots(),
            builder: (context, snapshot){
              if(!snapshot.hasData) //SE O SNAPSHOT NÃO CONTEM DADO
                return Center(child: CircularProgressIndicator(),); //ANIMAÇÃO DE CARREGANDO
              else { //CASO O SNAPSHOT TENHA ALGUM DADO
               int status = snapshot.data["status"];
                //##############################################################
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    //######################################### CÓDIGO DO PEDIDO 
                    Text(
                      "Código do pedido: ${snapshot.data.documentID}",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 5.0,),
                    //#################### DESCRIÇÃO DOS PRODUTOS DE CADA PEDIDO
                    Text( _buildTextoProduto(snapshot.data) ),
                    SizedBox(height: 5.0,),
                    //##########################################################
                    Text(
                      "Status do Pedido:",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 5.0,),
                    //##########################################################
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        //############################################ CIRCULO 1
                        _buildCirculo("1", "Preparação", status, 1),
                        Container( height: 1.0, width: 40.0, color: Colors.grey[500],
                        ),
                        //############################################ CIRCULO 2
                        _buildCirculo("2", "Transporte", status, 2),
                        Container( height: 1.0, width: 40.0, color: Colors.grey[500],
                        ),
                        //############################################ CIRCULO 3
                        _buildCirculo("3", "Entrega", status, 3),
                      ],
                    )
                  ],
                );
              }
            }
        ),
      )
  );
  }
  //########################## FUNÇÃO QUE GERA O TEXTO DOS PRODUTOS DE UM PEDIDO
  String _buildTextoProduto(DocumentSnapshot snapshot){
    String text = "Descrição:\n";
    for(LinkedHashMap p in snapshot.data["produtos"]){ // ACESSANDO OS PRODUTOS
      text += "${p["quantidade"]} x ${p["produto"]["nome"]} (R\$ ${p["produto"]["valor"].toStringAsFixed(2)})\n";
    }
    text += "Total: R\$ ${snapshot.data["valorTotal"].toStringAsFixed(2)}";
    return text;
  }
  //#################### FUNÇÃO QUE CRIA OS CIRCULOS DE ACOMPANHAMENTO DO PEDIDO
  Widget _buildCirculo(String titulo, String subTitulo, int status, int numeroIcone){
    Color corFundo;
    Widget filho;
    //############################## SE O STATUS É MENOR QUE O NUMERO DO CIRCULO
    if(status < numeroIcone){
      corFundo = Colors.grey[500]; //COR DE FUNDO CINZA
      filho = Text(titulo, style: TextStyle(color: Colors.white),);
    //################################# SE O STATUS É IGUAL AO NUMERO DO CIRCULO
    } else if (status == numeroIcone){
      corFundo = Colors.blue; // FUNDO AZUL
      filho = Stack( // CIRCULO COM ANIMAÇÃO DE CARREGANDO
        alignment: Alignment.center,
        children: <Widget>[
          Text(titulo, style: TextStyle(color: Colors.white),),
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
          )
        ],
      );
    //######################################### SE O STATUS É MAIOR QUE O NÚMERO
    } else {
      corFundo = Colors.green; // FUNDO VERDE
      filho = Icon(Icons.check, color: Colors.white,); // ICONE DE MARCADO
    }
    //##########################################################################
    return Column(
      children: <Widget>[
        CircleAvatar(
          radius: 20.0,
          backgroundColor: corFundo,
          child: filho,
        ),
        Text(subTitulo)
      ],
    );

  }

}
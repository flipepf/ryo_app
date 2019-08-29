import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ryo_app/models/usuarioModel.dart';
import 'package:ryo_app/pages/loginPage.dart';
import 'package:ryo_app/tiles/itemPedido.dart';

class PedidosTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    if(UsuarioModel.of(context).isLoggedIn()){ //VERIFICA SE USUARIO ESTA LOGADO

      String idUsuario = UsuarioModel.of(context).firebaseUser.uid; //OBTEM O ID DO USUARIO FIREBASE

      return FutureBuilder<QuerySnapshot>(
        future: Firestore.instance.collection("usuarios").document(idUsuario) //OBTEM TODOS OS DOCUMENTOS DA CONEXÃO
            .collection("pedidos").getDocuments(),
        builder: (context, snapshot){
          if(!snapshot.hasData) //SE O snapnhot NÃO TEM NENHUM DADO MOSTRA ANIMAÇÃO DE CARREGANDO
            return Center( child: CircularProgressIndicator(), );
          else { //SE USUARIO ESTIVER LOGADO
            return ListView(
              //DO SNAPSHOT mapea O doc QUE VAI RECEBER E PASSA UM ItemPedido PASSANDO O doc.documentID E CONVERTENDO PARAQ UMA LISTA
              children: snapshot.data.documents.map((doc) => ItemPedido(doc.documentID)).toList()
                  .reversed.toList(),
            );
          }
        },
      );
    //SE NÃO ESTÁ LOGADO ABRE A TELA INFORMANDO E POSSIBILITANDO REDIRECIONAR PARA TELA DE LOGIN
    } else {
      return Container(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(Icons.view_list,
              size: 80.0, color: Theme.of(context).primaryColor,),
            SizedBox(height: 16.0,),
            Text("Faça o login para acompanhar!",
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 16.0,),
            RaisedButton(
              child: Text("Entrar", style: TextStyle(fontSize: 18.0),),
              textColor: Colors.white,
              color: Theme.of(context).primaryColor,
              onPressed: (){
                Navigator.of(context).push(MaterialPageRoute(builder: (context)=>LoginPage()));
              },
            )
          ],
        ),
      );
    }
  }
}


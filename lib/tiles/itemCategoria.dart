import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ryo_app/pages/produtosPage.dart';

class ItemCategoria extends StatelessWidget {

  final DocumentSnapshot snapshot;

  ItemCategoria(this.snapshot);

  @override
  Widget build(BuildContext context) {
    return
      ListTile(
      leading: CircleAvatar(
        //radius: 25.0,
        maxRadius: 22.0,
        backgroundColor: Colors.transparent,
        backgroundImage: NetworkImage(snapshot.data["icon"]),
      ),
      title: Text(snapshot.data["nome"]),
      trailing: Icon(Icons.keyboard_arrow_right),
      onTap: (){
        Navigator.of(context).push(
            MaterialPageRoute(builder: (context)=>ProdutosPage(snapshot)) //ABRE A PAGINA DE PRODUTOS DA DETERMINADA CATEGORIA
        );
      },
    );
  }
}
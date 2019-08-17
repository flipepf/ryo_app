import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ryo_app/tiles/itemCategoria.dart';

class CategoriasTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<QuerySnapshot>(
      future: Firestore.instance.collection("produtos").getDocuments(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) //SE RETORNOU VAZIO
          return Center(
            child: CircularProgressIndicator(),); //ANIMAÇÃO DE CARREGANDO
        else {
          var dividedTiles = ListTile
              .divideTiles(
              tiles: snapshot.data.documents.map((doc) {
                return ItemCategoria(doc);
              }).toList(),
              color: Colors.grey[500])
              .toList();
          return ListView(
            children: dividedTiles,
          );
        }
      },
    );
  }
}
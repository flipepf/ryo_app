import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
//import 'package:ryo_app/pages/categoriaPage.dart';

class ItemCategoria extends StatelessWidget {

  final DocumentSnapshot snapshot;

  ItemCategoria(this.snapshot);

  @override
  Widget build(BuildContext context) {
    return
      ListTile(
      leading: CircleAvatar(
        radius: 25.0,
        backgroundColor: Colors.transparent,
        backgroundImage: NetworkImage(snapshot.data["icon"]),
      ),
      title: Text(snapshot.data["nome"]),
      trailing: Icon(Icons.keyboard_arrow_right),
      onTap: (){
      /*  Navigator.of(context).push(
            MaterialPageRoute(builder: (context)=>CategoryScreen(snapshot))
        );*/
      },
    );
  }
}
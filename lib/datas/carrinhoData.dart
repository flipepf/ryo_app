import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ryo_app/datas/produtoData.dart';

class CarrinhoData {

  String id;
  String categoria;
  String produtoId;
  int quantidade;
  ProdutoData produtoData;

  CarrinhoData(); //CONSTRUTOR

  CarrinhoData.fromDocument(DocumentSnapshot document){
    id = document.documentID;
    categoria = document.data["categoria"];
    produtoId = document.data["produtoId"];
    quantidade = document.data["quantidade"];
  }

  Map<String, dynamic> toMap(){
    return {
      "categoria": categoria,
      "produtoId": produtoId,
      "quantidade": quantidade,
      //"produto": produtoData.toResumedMap() //PASSA APENAS UM RESUMO DO PRODUTO
    };
  }

}
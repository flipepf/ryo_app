import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ryo_app/datas/produtoData.dart';

class CarrinhoData {

  String id;
  String categoria;
  String produtoId;
  int quantidade;
  ProdutoData productData;

  CarrinhoData();

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
      "produto": productData.toResumedMap() //PASSA APENAS UM RESUMO DO PRODUTO
    };
  }

}
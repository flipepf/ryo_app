import 'package:cloud_firestore/cloud_firestore.dart';

class ProdutoData {

  String categoria;
  String id;
  String nome;
  String descricao;
  double valor;
  String imagem;

  //CONVERTE OS DADOS DO DOCUMENTO NOS DADOS DA CLASSE ProdutoData
  ProdutoData.fromDocument(DocumentSnapshot snapshot){ //CONSTRUTOR QUE RECEBE UM DOCUMENT SNAPSHOT
    id = snapshot.documentID;
    nome = snapshot.data["nome"];
    descricao = snapshot.data["descricao"];
    valor = snapshot.data["valor"] + 0.0;
    imagem = snapshot.data["imagem"];
  }

  Map<String, dynamic> toResumedMap(){
    return {
      "nome": nome,
      "descricao": descricao,
      "valor": valor
    };
  }
}
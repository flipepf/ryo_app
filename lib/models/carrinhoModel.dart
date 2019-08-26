import 'dart:async';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ryo_app/datas/carrinhoData.dart';
import 'package:ryo_app/models/usuarioModel.dart';
import 'package:scoped_model/scoped_model.dart';

class CarrinhoModel extends Model {

  UsuarioModel usuario;
  List<CarrinhoData> produtos = []; //LISTA QUE ARMAZENARA OS PRODUTOS NO CARRINHO
  String codigoCupom;
  int percentagemDesconto = 0;
  bool isLoading = false;
  CarrinhoModel(this.usuario){
    if (usuario.isLoggedIn())
      _loadItemsCarrinho();
  } //CONSTRUTOR

  static CarrinhoModel of(BuildContext context) => ScopedModel.of<CarrinhoModel>(context);

  //################# CARREGA OS PRODUTOS NO CARRINHO A PARTIR DO BANCO DE DADOS
  void _loadItemsCarrinho() async {
    QuerySnapshot query = await Firestore.instance.collection("usuarios").document(usuario.firebaseUser.uid).collection("carrinho")
        .getDocuments();
    produtos = query.documents.map((doc) => CarrinhoData.fromDocument(doc)).toList();
    notifyListeners();
  }
  //################################################## ADICIONA ITEM AO CARRINHO
  void addItemCarrinho(CarrinhoData produto){
    produtos.add(produto);// ADICIONA O PRODUTO A LISTA produtos
    Firestore.instance.collection("usuarios").document(usuario.firebaseUser.uid) //ENTRA NA COLEÇÃO DO USUARIO
     .collection("carrinho").add(produto.toMap()).then((doc){
     produto.id = doc.documentID; //ARMAZENA NA BASE DE DADOS PEGANDO O ID QUE O FIREBASE CRIOU E PASSANDO TAMBÉM PARA O OBJETO
    });
    notifyListeners();
  }
  //#################################################### REMOVE ITEM DO CARRINHO
  void removeItemCarrinho(CarrinhoData produto){
    Firestore.instance.collection("usuarios").document(usuario.firebaseUser.uid)
     .collection("carrinho").document(produto.id).delete();
    produtos.remove(produto);
    notifyListeners();
  }
  //######################################################### AUMENTA QUANTIDADE
  void decQuantidade(CarrinhoData produto){
    produto.quantidade--;
    Firestore.instance.collection("usuarios").document(usuario.firebaseUser.uid).collection("carrinho")
        .document(produto.id).updateData(produto.toMap());
    notifyListeners();
  }
  //######################################################### DIMINUI QUANTIDADE
  void incQuantidade(CarrinhoData produto){
    produto.quantidade++;
    Firestore.instance.collection("usuarios").document(usuario.firebaseUser.uid).collection("carrinho")
        .document(produto.id).updateData(produto.toMap());
    notifyListeners();
  }
  // ATUALIZA O PREÇO DOS PRODUTOS NO CARRINHO PARA REALIZAR O CÁLCULO ASSIM QUE A PAGINA FOR CARREGADA
  void updateValor(){ notifyListeners(); }
  //################################################## PEGA O PREÇO DOS PRODUTOS
  double getValorProdutos(){
    double valor = 0.0;
    for(CarrinhoData p in produtos){ //PEGA CADA PRODUTO EM produtos e PASSA PARA p
      if(p.produtoData != null) // SE TIVER ALGUM PRODUTO NO CARRINHO
        valor += p.quantidade * p.produtoData.valor; //ACRESCENTA NO VALOR TOTAL
    }
    return valor;
  }
  //############################ SETA A PERCENTAGEM DO DESCONTO CONFORME O CUPOM
  void setCupom(String codigoCupom, int percentagemDesconto){
    this.codigoCupom = codigoCupom;
    this.percentagemDesconto = percentagemDesconto;
  }
  //######################################################### CALCULA O DESCONTO
  double getDesconto(){
    return getValorProdutos() * percentagemDesconto / 100;
  }
  //############################################### RETORNA A O VALOR DA ENTREGA
  double getValorEntrega(){
    return 5.99;
  }
 //########################################################### FINALIZA O PEDIDO
  
  Future<String> finalizarPedido() async {
    if(produtos.length == 0) return null; //SE A LISTA DE PRODUTOS ESTIVER VAZIA
    isLoading = true; // INFORMA QUE HAVERÁ PROCESSAMENTO - CARREGANDO = TRUE
    notifyListeners(); // NOTIFICA OS LISTENNERS PARA MOSTRAR O SIMBOLO DE CAREGANDO
    //###################### PREENCHE OS TRES VALORES COM OS VALORES DOS OBJETOS
    double valorProdutos = getValorProdutos();
    double valorEntrega = getValorEntrega();
    double desconto = getDesconto();
    //FUNÇÃO RETORNA UM DocumentReference (PROVIDENCIA ID PARA CADA PEDIDO)
    DocumentReference refPedido = await Firestore.instance.collection("pedidos").add( //ADICIONA UM NOVO PEDIDO A BASE DE DADOS E UM map COM TODAS AS INFORMAÇÕES DO pedido
        { "idUsuario": usuario.firebaseUser.uid,
          "produtos": produtos.map((produto)=>produto.toMap()).toList(), //MAPEA A LISTA DE PRODUTOS, TRANSFORMANDO CADA ItemCarrinho EM LISTA DE maps map
          "valorEntrega": valorEntrega,
          "valorProdutos": valorProdutos,
          "desconto": desconto,
          "valorTotal": valorProdutos - desconto + valorEntrega,
          "status": 1 }
    );
    //SALVA O ID DO PEDIDO NA COLEÇÃO DOS USUÁRIOS
    await Firestore.instance.collection("usuarios").document(usuario.firebaseUser.uid)
        .collection("pedidos").document(refPedido.documentID).setData(
        { "idPedido": refPedido.documentID } //GAMBIARRA É PRECISO SALVAR UMA INFORMAÇÃO ENTAO SALVA DENTRO DE CADA DOCUMENTO O PROPRIO ID
    );
    //#################################### PARA REMOVER OS PRODUTOS DOS CARRINHOS
    //PEGA UM SNAPSHOT (REFERENCIA DE CADA UM) DOS PRODUTOS NO CARRINHO DO USUARIO
    QuerySnapshot produtosCarrinho = await Firestore.instance.collection("usuarios").document(usuario.firebaseUser.uid)
        .collection("carrinho").getDocuments();
    for(DocumentSnapshot doc in produtosCarrinho.documents){ //PARA CADA PRODUTO DA LISTA DO CARRINHO
      doc.reference.delete(); //LIMPA OS PRODUTO DA COLEÇÃO carrinho DO USUARIO
    }
    //####################################### LIMPA AS LISTAS E VARIAVEIS LOCAIS
    produtos.clear();
    codigoCupom = null;
    percentagemDesconto = 0;
    isLoading = false;
    notifyListeners();

    return refPedido.documentID;
  }
 
}
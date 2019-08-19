import 'dart:async';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ryo_app/datas/carrinhoData.dart';
import 'package:ryo_app/models/usuarioModel.dart';
import 'package:scoped_model/scoped_model.dart';

class CarrinhoModel extends Model {

  UsuarioModel usuario;
  List<CarrinhoData> produtos = []; //LISTA QUE ARMAZENARA OS PRODUTOS NO CARRINHO
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
  //################################## ATUALIZA O PREÇO DOS PRODUTOS NO CARRINHO
  void updateValor(){ notifyListeners(); }
  //################################################## PEGA O PREÇO DOS PRODUTOS
  double getValorProdutos(){
    double valor = 0.0;
    for(CarrinhoData c in produtos){
      if(c.produtoData != null)
        valor += c.quantidade * c.produtoData.valor;
    }
    return valor;
  }
/*
  void setCoupon(String couponCode, int discountPercentage){
    this.couponCode = couponCode;
    this.discountPercentage = discountPercentage;
  }

  double getDiscount(){
    return getProductsPrice() * discountPercentage / 100;
  }

  double getShipPrice(){
    return 9.99;
  }

  Future<String> finishOrder() async {
    if(produtos.length == 0) return null;
    isLoading = true;
    notifyListeners();
    double produtosPrice = getProductsPrice();
    double shipPrice = getShipPrice();
    double discount = getDiscount();
    DocumentReference refOrder = await Firestore.instance.collection("orders").add(
        {
          "clientId": usuario.firebaseUser.uid,
          "produtos": produtos.map((produto)=>produto.toMap()).toList(),
          "shipPrice": shipPrice,
          "produtosPrice": produtosPrice,
          "discount": discount,
          "totalPrice": produtosPrice - discount + shipPrice,
          "status": 1
        }
    );

    await Firestore.instance.collection("usuarios").document(usuario.firebaseUser.uid)
        .collection("orders").document(refOrder.documentID).setData(
        {
          "orderId": refOrder.documentID
        }
    );

    QuerySnapshot query = await Firestore.instance.collection("usuarios").document(usuario.firebaseUser.uid)
        .collection("cart").getDocuments();

    for(DocumentSnapshot doc in query.documents){
      doc.reference.delete();
    }

    produtos.clear();
    couponCode = null;
    discountPercentage = 0;
    isLoading = false;
    notifyListeners();
    return refOrder.documentID;
  }

  */
}
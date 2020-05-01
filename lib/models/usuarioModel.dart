import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:flutter/material.dart';
import '../firebase_messaging.dart';

class UsuarioModel extends Model {
  //Model OBJETO QUE GUARDARA OS ESTADOS DE ALGO, NO CASO DO USUARIO QUE TEM TODAS AS FUNÕES QUE PODEM MODIFICAR O MODELO

  FirebaseAuth _auth = FirebaseAuth.instance; //OBJETO PARA ARMAZENAR A STRING

  FirebaseUser firebaseUser; //OBJETO QUE ARMAZENA O USUARIO LOGADO NO MOMENTO
  Map<String, dynamic> dadosUsuario = Map(); //MAP QUE ARMAZENARA OS DADOS DO USUARIO

  bool isLoading = false;
  //METODO ESTATICO (DA CLASSE, NÃO DO OBJETO) RETORNA UM SCOPED MODEL PARA QUE POSSA TER ACESSO AO UsuarioModel DE QUALQUER PARTE DO APP
  //SEM QUE SEJA NECESSARIO UTILIZAR O ScopedModelDescendant
  static UsuarioModel of(BuildContext context) => ScopedModel.of<UsuarioModel>(context);

  final _firebaseNotifications = new FirebaseNotifications();
  String idUsuario = "";
  //####################################################### SUBSCREVE O LISTENER
  @override
  void addListener(VoidCallback listener) {
    super.addListener(listener);
    _loadCurrentUser(); //CHAMA A FUNÇÃO PARA TENTAR CARREGAR OS DADOS DO USUARIO PARA O MAP
    _firebaseNotifications.iniciarFirebaseListeners();
  }
  //################################################################ CRIAR CONTA
  void signUp(
      {@required Map<String, dynamic> dadosUsuario,
      @required String pass,
      @required VoidCallback onSuccess,
      @required VoidCallback onFail}) {
    isLoading = true; //########################### NOTIFICA QUE ESTA CARREGANDO
    notifyListeners();

    _auth.createUserWithEmailAndPassword(
            // TENTA CRIAR O USUARIO NO FIREBIRD
            email: dadosUsuario["email"], // PASSANDO O EMAIL
            password: pass // E A SENHA
            //########################## CASO OCORRA TUDO CERTO
            )
        .then((user) async {
      firebaseUser = user; // SALVA O USUARIO
      await _saveUserData(dadosUsuario); // ARMAZENA OS DADOS DO USUARIO NO FIREBASE
      onSuccess(); // CHAMA A FUNÇÃO onSucces
      _atualizaToken();
      isLoading = false; // INDICA QUE TERMINOU DE CARREGAR
      notifyListeners(); // INFORMA QUE HOUVE ALTERAÇÃO PARA ALTERAR A VIEW
      //########################### CASO OCORRA ALGUM ERRO
    }).catchError((e) {
      onFail(); // CHAMA A FUNÇÃO onFail
      isLoading = false; // INDICA QUE FINALIZOU DE CARREGAR
      notifyListeners(); // INFORMA QUE HOUVE ALTERAÇÃO PARA ALTERAR A VIEW
    });
  }
  //################################################## SALVA OS DADOS DO USUÁRIO
  Future<Null> _saveUserData(Map<String, dynamic> dadosUsuario) async {
    this.dadosUsuario = dadosUsuario; //PASSA OS DADOS QUE RECEBEU PELO PARAMETRO PARA O Map
    await Firestore.instance
        .collection("usuarios")
        .document(firebaseUser.uid)
        .setData(dadosUsuario); // NA COLEÇÃO usuários CRIA UM DOCUMENTO COM O ID DO USUARIO firebase E ARMAZENA NELE OS CAMPOS DO Map
  }
  //###################################################################### LOGIN
  void signIn({@required String email,
      @required String pass,
      @required VoidCallback onSuccess,
      @required VoidCallback onFail}) async {
    isLoading = true;
    notifyListeners();
    FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: pass)
        .then((user) async {
          firebaseUser = user;
          await _loadCurrentUser();
          onSuccess();
          _atualizaToken();
          isLoading = false;
          notifyListeners();
        }).catchError((e) {
          onFail();
          isLoading = false;
          notifyListeners();
        });
    }
  //####################################################################### SAIR
  void signOut() async {
    Map<String, dynamic> mapa = {"token": ""};
    await Firestore.instance.collection("usuarios").document(idUsuario).updateData(mapa);
    await _auth.signOut();
    dadosUsuario = Map();
    firebaseUser = null;
    idUsuario = "";
    notifyListeners();
  }
  //############################################################ RECUPERAR SENHA
  void recoverPass(String email) {
    _auth.sendPasswordResetEmail(email: email);
  }
  //###################################################  VERIFICA SE ESTÁ LOGADO
  bool isLoggedIn() {
    return firebaseUser != null;
  }
  //############################################# CARREGA DADOS DO USUARIO ATUAL
  Future<Null> _loadCurrentUser() async {
    //SE O USUARIO FOR NULO TENTA PEGAR O USUARIO ATUAL NO FIREBASE
    if (firebaseUser == null) firebaseUser = await _auth.currentUser();
    //SE CARREGOU COM SUCESSO
    if (firebaseUser != null) {
      //SE O MAP ESTA SEM DADOS
      if (dadosUsuario["nome"] == null) {
        DocumentSnapshot docUser = await Firestore.instance //
            .collection("usuarios")
            .document(firebaseUser.uid)
            .get();
        dadosUsuario = docUser.data; //PASSA OS DADOS PARA O MAP
        idUsuario = firebaseUser.uid.toString();
      }
    }
    notifyListeners();
  }
  //#######################  ATUALIZA O TOKEN DO APP NA BASE DE DADOS DO USUÁRIO
  void _atualizaToken() async {
    final token = _firebaseNotifications.PegaToken();
    Map<String, dynamic> mapa = {"token": token};
    print("cheguei aki " + mapa.toString());
    await Firestore.instance.collection("usuarios").document(idUsuario).updateData(mapa);
  }
}
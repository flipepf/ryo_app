import 'package:flutter/material.dart';
import 'package:ryo_app/models/usuarioModel.dart';
import 'package:scoped_model/scoped_model.dart';
import '../firebase_messaging.dart';

class CriarContaPage extends StatefulWidget {
  @override
  _CriarContaPageState createState() => _CriarContaPageState();
}

class _CriarContaPageState extends State<CriarContaPage> {
  final _emailController = TextEditingController();
  final _passController = TextEditingController();
  final _nomeController = TextEditingController();
  final _endController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final token = new FirebaseNotifications().pegaToken();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text("Criar Conta"),
          centerTitle: true,
        ),
        body: ScopedModelDescendant<UsuarioModel>(
            //ScopedModelDescendant FORMA DE ACESSAR O MODELO
            builder: (context, child, model) {
          if (model.isLoading)
            return Center(
              child: CircularProgressIndicator(),
            );

          return Form(
            key: _formKey,
            child: ListView(
              padding: EdgeInsets.fromLTRB(16.0, 80.0, 16.0, 16.0),
              children: <Widget>[
                //############################################ CAIXA DE TEXTO NOME
                TextFormField(
                  controller: _nomeController,
                  decoration: InputDecoration(hintText: "Nome"),
                  validator: (text) {
                    if (text.isEmpty) return "Nome inválido!";
                  },
                ),
                //############################################## CAIXA TEXTO EMAIL
                SizedBox(
                  height: 18.0,
                ),
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(hintText: "E-mail"),
                  keyboardType: TextInputType.emailAddress,
                  validator: (text) {
                    if (text.isEmpty || !text.contains("@"))
                      return "E-mail inválido!";
                  },
                ),
                SizedBox(
                  height: 18.0,
                ),
                //############################################## CAIXA TEXTO SENHA
                TextFormField(
                  controller: _passController,
                  decoration: InputDecoration(hintText: "Senha"),
                  obscureText: true,
                  validator: (text) {
                    if (text.isEmpty || text.length < 6)
                      return "Senha inválida!";
                  },
                ),
                SizedBox(
                  height: 18.0,
                ),
                //########################################### CAIXA TEXTO ENDEREÇO
                TextFormField(
                  controller: _endController,
                  decoration: InputDecoration(hintText: "Endereço"),
                  validator: (text) {
                    if (text.isEmpty) return "Endereço inválido!";
                  },
                ),
                SizedBox(
                  height: 20.0,
                ),
                //############################################### BOTÃO CADASTRAR
                SizedBox(
                  height: 50.0,
                  child: RaisedButton(
                    child: Text(
                      "Criar Conta",
                      style: TextStyle(
                        fontSize: 20.0,
                      ),
                    ),
                    textColor: Colors.white,
                    color: Theme.of(context).primaryColor,
                    onPressed: () {
                      if (_formKey.currentState.validate()) {
                        Map<String, dynamic> dadosUsuario = {
                          "nome": _nomeController.text,
                          "email": _emailController.text,
                          "endereço": _endController.text,
                          "token:": token.toString(),
                        };
                        model.signUp(
                          dadosUsuario: dadosUsuario,
                          pass: _passController.text,
                          onSuccess: _onSuccess,
                          onFail: _onFail,
                        );
                      }
                    },
                  ),
                ),
              ],
            ),
          );
        }));
  }
  //############################################################################
  void _onSuccess() {
    _scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text("Usuário criado com sucesso!"),
      backgroundColor: Theme.of(context).primaryColor,
      duration: Duration(seconds: 3),
    ));
    Future.delayed(Duration(seconds: 2)).then((_) {
      Navigator.of(context).pop();
    });
  }
  //############################################################################
  void _onFail() {
    _scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text("Falha ao criar usuário!"),
      backgroundColor: Colors.redAccent,
      duration: Duration(seconds: 3),
    ));
  }
}

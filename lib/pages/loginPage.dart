import 'package:flutter/material.dart';
import 'package:ryo_app/models/usuarioModel.dart';
import 'package:scoped_model/scoped_model.dart';
import 'criarContaPage.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  //############################################################################
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text("Entrar"),
          centerTitle: true,
          actions: <Widget>[
            FlatButton(
              child: Text(
                "CRIAR CONTA",
                style: TextStyle(fontSize: 16.0),
              ),
              textColor: Colors.white,
              onPressed: () {
                Navigator.of(context).pushReplacement(
                    //SUBSTITUI A TELA ATUAL PELA CRIAR CONTA PARA QUE AO CRIAR A CONTA JA REALIZE O LOGIN
                    MaterialPageRoute(builder: (context) => CriarContaPage()));
              },
            )
          ],
        ),
        //######################################################################
        body: ScopedModelDescendant<UsuarioModel>( //ScopedModelDescendant FORMA DE ACESSAR O MODELO
          builder: (context, child, model) {
            if (model.isLoading) //SE ESTIVER CARREGANDO
              return Center(
                child: CircularProgressIndicator(), //RETORNA ANIMAÇÃO DE CARREGANDO
              );

            return Form(
              //CASO O CONTRARIO CARREGA O FORMULARIO
              key: _formKey,
              child: ListView(
                padding: EdgeInsets.fromLTRB(16.0, 110.0, 16.0, 16.0),
                children: <Widget>[
                  //########################################## CAIXA TEXTO EMAIL
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
                  //########################################## CAIXA TEXTO SENHA
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
                  Align(
                    alignment: Alignment.centerRight,
                    child: FlatButton(
                      onPressed: (){
                        if(_emailController.text.isEmpty) { // VERIFICA SE O CAMPO DE TEXTO ESTÁ VAZIO
                          _scaffoldKey.currentState.showSnackBar(
                              SnackBar(content: Text(
                                  "Insira seu e-mail para recuperação!"),
                                backgroundColor: Colors.redAccent,
                                duration: Duration(seconds: 3),
                              )
                          );
                        } else { //CASO O EMAIL JA ESTEJA PREENCHIDO
                          model.recoverPass(_emailController.text); //CHAMA A FUNÇÃO DO MODEL PASSANDO O EMAIL COMO PARAMETRO
                          _scaffoldKey.currentState.showSnackBar(
                              SnackBar(content: Text("Confira seu e-mail!"),
                                backgroundColor: Theme
                                    .of(context)
                                    .primaryColor,
                                duration: Duration(seconds: 3),
                              )
                          );
                        }
                      },
                      child: Text(
                        "Esqueci minha senha",
                        textAlign: TextAlign.right,
                      ),
                      padding: EdgeInsets.zero,
                    ),
                  ),
                  SizedBox(
                    height: 16.0,
                  ),
                  //############################################### BOTÃO ENTRAR
                  SizedBox(
                    height: 50.0,
                    child: RaisedButton(
                      child: Text(
                        "Entrar",
                        style: TextStyle(
                          fontSize: 20.0,
                        ),
                      ),
                      textColor: Colors.white,
                      color: Theme.of(context).primaryColor,
                      onPressed: () {
                        if (_formKey.currentState.validate()) {}
                        model.signIn(
                            email: _emailController.text,
                            pass: _passController.text,
                            onSuccess: _onSuccess,
                            onFail: _onFail
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        ));
  }
  //############################################################################
  void _onSuccess() {
    Navigator.of(context).pop();
  }
  //############################################################################
  void _onFail() {
    _scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text("Falha ao Entrar!"),
      backgroundColor: Colors.redAccent,
      duration: Duration(seconds: 3),
    ));
  }
}

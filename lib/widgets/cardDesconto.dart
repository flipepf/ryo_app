import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ryo_app/models/carrinhoModel.dart';

class CardDesconto extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
        margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
        child: ExpansionTile( //########################## EXPANDE AO PRESSIONAR
            leading:
                Icon(Icons.card_giftcard), //################## ICONE A ESQUERDA
            //#################################################### TEXTO DO CARD
            title: Text(
              "Cupom de desconto",
              textAlign: TextAlign.start,
              style: TextStyle(
                  fontWeight: FontWeight.w500, color: Colors.grey[700]),
            ),
            trailing: Icon(Icons.add), //####################### ICONE A DIREITA
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(8.0),
                child: TextFormField(
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: "Digite seu cupom"),
                  initialValue: CarrinhoModel.of(context).codigoCupom ?? "", //VALOR INICIAL, CASO JA TENHA UM CUPOM APLICADO SENÃO STRING VAZIA
                  onFieldSubmitted: (text) { //QUANDO O CUPOM FOR SUBMETIDO PASSANDO POR PARAMETRO SEU TEXTO
                    Firestore.instance.collection("cupons").document(text).get() //PROCURA NA BASE DE DADOS SE O CUPOM É VÁLIDO
                        .then((docSnap) {
                      if (docSnap.data != null) { //###### SE O CUPOM FOR VÁLIDO
                        CarrinhoModel.of(context).setCupom(text, docSnap.data["percentual"]);//CHAMA A FUNÇÃO PARA APLICAR O DESCONTO PASSANBDO POR PARAMETRO O TEXTO E O DESCONTO DEFINIDO NA BASE DE DADOS
                        Scaffold.of(context).showSnackBar(SnackBar( // MOSTRA UM NOTIFICATION INFORMANDO A APLICAÇÃO DO CUPOM
                          content: Text( "Desconto de ${docSnap.data["percentual"]}% aplicado!"),
                          backgroundColor: Theme.of(context).primaryColor,
                        ));
                      } else { //####################### SE O CUPOM NÃO É VÁLIDO
                        CarrinhoModel.of(context).setCupom(null, 0);
                        Scaffold.of(context).showSnackBar(SnackBar( //MENSAGEM DE CUPOM NÃO EXISTENTE
                          content: Text("Cupom não existente!"),
                          backgroundColor: Colors.redAccent,
                        ));
                      }
                    });
                  },
                ),
              )
            ]
        )
    );
  }
}

import 'package:flutter/material.dart';
import 'package:ryo_app/models/carrinhoModel.dart';
import 'package:scoped_model/scoped_model.dart';

class CardTotal extends StatelessWidget {

  final VoidCallback finalizarPedido;
  CardTotal(this.finalizarPedido); //RECEBE A FUNÇÃO DE ONDE PE CHAMADO (CarrinhoPage)

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: Container(
        padding: EdgeInsets.all(16.0),
        child: ScopedModelDescendant<CarrinhoModel>( //ACESSAR OS DADOS DO CARRINHO
          builder: (context, child, model){
            double valor = model.getValorProdutos();
            double desconto = model.getDesconto();
            double entrega = model.getValorEntrega();
            //##################################################################
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch, //.stretch OCPUPA O MAXIMO ESPAÇO POSSIVEL NA LARGURA
              children: <Widget>[
                Text(
                  "Resumo do Pedido",
                  textAlign: TextAlign.start,
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
                SizedBox(height: 12.0,),
                //##################################################### SUBTOTAL
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween, //UM ITEM A DIREITA (suntotal), UM ITEM A ESQUERDA (R$)
                  children: <Widget>[
                    Text("Subtotal"),
                    Text("R\$ ${valor.toStringAsFixed(2)}")
                  ],
                ),
                Divider(),
                //##################################################### DESCONTO
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text("Desconto"),
                    Text("R\$ ${desconto.toStringAsFixed(2)}")
                  ],
                ),
                Divider(),
                //###################################################### ENTREGA
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text("Entrega"),
                    Text("R\$ ${entrega.toStringAsFixed(2)}")
                  ],
                ),
                Divider(),
                SizedBox(height: 12.0,),
                //################################################## VALOR TOTAL
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text("Total",
                      style: TextStyle(fontWeight: FontWeight.w500),),
                    Text("R\$ ${(valor + entrega - desconto).toStringAsFixed(2)}",
                      style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 16.0),)
                  ],
                ),
                SizedBox(height: 12.0,),
                //############################################### BOTÃO FINALIZAR PEDIDO
                RaisedButton(
                  child: Text("Finalizar Pedido"),
                  textColor: Colors.white,
                  color: Theme.of(context).primaryColor,
                  onPressed: finalizarPedido,
                )
              ],
            );
          },
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

class ItemMenu extends StatelessWidget {

  final IconData icon;
  final String text;
  final PageController controller;
  final int page;

  ItemMenu(this.icon, this.text, this.controller, this.page);

  @override
  Widget build(BuildContext context) {
    return Material( //RETORNA UM MATERIAL PARA DAR EFEITO VISUAL AO CLICAR NO ICONE
      color: Colors.transparent,
      child: InkWell(
        onTap: (){ //AO CLICAR NO ITEM DO MENU
          Navigator.of(context).pop(); //FECHA O MENU
          controller.jumpToPage(page); //E VAI PARA A PAGINA SELECIONADA
        },
        child: Container(
          height: 60.0,
          child: Row(
            children: <Widget>[
              Icon(
                icon,
                size: 32.0,
                color: controller.page.round() == page ? // ICONE DA PAGINA ATUAL FICA DE COR DIFERENTE
                  Theme.of(context).primaryColor : Colors.grey[700],
              ),
              SizedBox(width: 32.0,),
              Text(
                text,
                style: TextStyle(
                  fontSize: 16.0,
                  color: controller.page.round() == page ? //TEXTO DA PAGINA ATUAL FICA DE COR DIFERENTE
                  Theme.of(context).primaryColor : Colors.grey[700],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:quick_converter/core/notifiers/menu_notifier.dart';

class SidebarWidget extends StatelessWidget {
  const SidebarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final menuNotifier = Provider.of<MenuNotifier>(context, listen: false);

    final theme = Theme.of(context);

    return Drawer(
      backgroundColor: theme.drawerTheme.backgroundColor,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          Container(
              height: 150,
              color: theme.secondaryHeaderColor,
              padding: const EdgeInsets.all(10),
              alignment: Alignment.center,
              child: Icon(
                Icons.menu,
                size: 50,
              )),
          ListTile(
            leading: const Icon(Icons.money_outlined),
            title: Text('Conversor de Moedas',
                style: TextStyle(color: theme.listTileTheme.textColor)),
            iconColor: theme.listTileTheme.iconColor ?? theme.iconTheme.color,
            tileColor: theme.listTileTheme.tileColor,
            onTap: () {
              menuNotifier.setPage(ActivePage.currency);
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.attach_money_outlined),
            title: Text('Conversor de CryptoMoedas',
                style: TextStyle(color: theme.listTileTheme.textColor)),
            iconColor: theme.listTileTheme.iconColor ?? theme.iconTheme.color,
            tileColor: theme.listTileTheme.tileColor,
            onTap: () {
              menuNotifier.setPage(ActivePage.crypto);
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.history),
            title: Text('Histórico',
                style: TextStyle(color: theme.listTileTheme.textColor)),
            iconColor: theme.listTileTheme.iconColor ?? theme.iconTheme.color,
            tileColor: theme.listTileTheme.tileColor,
            onTap: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text('Aviso'),
                    content: Text('Conteúdo em Desenvolvimento!'),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text('Fechar'),
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}

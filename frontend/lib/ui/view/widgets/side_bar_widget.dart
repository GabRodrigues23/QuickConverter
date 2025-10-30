import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:QuickConverter/core/notifiers/menu_notifier.dart';

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
              menuNotifier.updateMenuIndex(0);
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
              menuNotifier.updateMenuIndex(1);
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
              menuNotifier.updateMenuIndex(2);
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}

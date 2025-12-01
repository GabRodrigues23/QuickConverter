import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quick_converter/core/notifiers/history_notifier.dart';

class HistoryModal extends StatelessWidget {
  const HistoryModal({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      height: MediaQuery.of(context).size.height * 0.6,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.only(bottom: 20),
            decoration: BoxDecoration(
              color: Colors.grey.withAlpha(1),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Histórico', style: theme.textTheme.displayMedium),
              IconButton(
                icon: Icon(Icons.delete_outline),
                onPressed: () {
                  Provider.of<HistoryNotifier>(context, listen: false)
                      .clearHistory();
                },
              )
            ],
          ),
          const SizedBox(height: 10),
          Expanded(
            child: Consumer<HistoryNotifier>(
              builder: (context, historyNotifier, child) {
                if (historyNotifier.items.isEmpty) {
                  return Center(
                    child: Text(
                      'Nenhuma conversão recente',
                      style: theme.textTheme.labelLarge,
                    ),
                  );
                }

                return ListView.separated(
                  itemCount: historyNotifier.items.length,
                  separatorBuilder: (_, __) => const Divider(),
                  itemBuilder: (context, index) {
                    final item = historyNotifier.items[index];

                    final dateStr =
                        "${item.date.day.toString().padLeft(2, '0')}/${item.date.month.toString().padLeft(2, '0')} ${item.date.hour}:${item.date.minute.toString().padLeft(2, '0')}";

                    return ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: CircleAvatar(
                        child: Icon(Icons.swap_horiz),
                      ),
                      title: Text(
                        '${item.amount} ${item.from} ➔ ${item.result} ${item.to}',
                        style: theme.textTheme.labelLarge,
                      ),
                      subtitle: Text(
                        dateStr,
                        style: theme.textTheme.labelSmall,
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

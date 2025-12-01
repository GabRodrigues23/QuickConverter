import 'package:flutter/material.dart';

class HistoryModal extends StatelessWidget {
  const HistoryModal({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final List<Map<String, String>> dummyHistory = [
      {
        'from': 'USD',
        'to': 'BRL',
        'amount': '100.00',
        'result': '540.00',
        'date': 'Hoje, 10:30'
      },
      {
        'from': 'BTC',
        'to': 'USD',
        'amount': '1.00',
        'result': '65,000.00',
        'date': 'Ontem, 14:20'
      },
      {
        'from': 'EUR',
        'to': 'JPY',
        'amount': '50.00',
        'result': '8,200.00',
        'date': '20/10, 09:15'
      },
    ];

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
          Text('Histórico de Conversões', style: theme.textTheme.displayMedium),
          const SizedBox(height: 20),
          Expanded(
            child: ListView.separated(
              itemCount: dummyHistory.length,
              separatorBuilder: (_, __) => const Divider(),
              itemBuilder: (context, index) {
                final item = dummyHistory[index];
                return ListTile(
                  leading: CircleAvatar(
                    child: Icon(Icons.swap_horiz),
                  ),
                  title: Text(
                      '${item['amount']} ${item['from']} ➔ ${item['result']} ${item['to']}',
                      style: theme.textTheme.labelLarge),
                  subtitle:
                      Text(item['date']!, style: theme.textTheme.labelSmall),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

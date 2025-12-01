import 'dart:convert';

class HistoryItem {
  final String from;
  final String to;
  final String amount;
  final String result;
  final DateTime date;

  HistoryItem({
    required this.from,
    required this.to,
    required this.amount,
    required this.result,
    required this.date,
  });

  Map<String, dynamic> toMap() {
    return {
      'from': from,
      'to': to,
      'amount': amount,
      'result': result,
      'date': date.toIso8601String(),
    };
  }

  factory HistoryItem.fromMap(Map<String, dynamic> map) {
    return HistoryItem(
      from: map['from'] ?? '',
      to: map['to'] ?? '',
      amount: map['amount'] ?? '',
      result: map['result'] ?? '',
      date: DateTime.parse(map['date']),
    );
  }

  String toJson() => json.encode(toMap());

  factory HistoryItem.fromJson(String source) =>
      HistoryItem.fromMap(json.decode(source));
}

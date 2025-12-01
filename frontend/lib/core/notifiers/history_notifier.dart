import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:quick_converter/data/model/history_item.dart';

class HistoryNotifier extends ChangeNotifier {
  List<HistoryItem> _items = [];

  List<HistoryItem> get items => _items;

  HistoryNotifier() {
    loadHistory();
  }

  Future<void> loadHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String>? historyJson = prefs.getStringList('conversion_history');

    if (historyJson != null) {
      _items = historyJson.map((item) => HistoryItem.fromJson(item)).toList();
      _items.sort((a, b) => b.date.compareTo(a.date));
      notifyListeners();
    }
  }

  Future<void> addToHistory(HistoryItem item) async {
    _items.insert(0, item);
    if (_items.length > 20) {
      _items.removeLast();
    }
    notifyListeners();
    _saveToPrefs();
  }

  Future<void> clearHistory() async {
    _items.clear();
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('conversion_history');
  }

  Future<void> _saveToPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> historyJson =
        _items.map((item) => item.toJson()).toList();
    await prefs.setStringList('conversion_history', historyJson);
  }
}

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:logbook_app_077/features/logbook/models/log_model.dart';

class LogController {
  final ValueNotifier<List<LogModel>> logsNotifier = ValueNotifier([]);
  final ValueNotifier<List<LogModel>> filteredLogs = ValueNotifier([]);
  final ValueNotifier<String> searchQuery = ValueNotifier(""); 
  
  final String username;
  late final String _userStorageKey;

  LogController({required this.username}) {
    _userStorageKey = 'user_logs_data_$username';
    loadFromDisk();
  }

  void searchLog(String query) {
    searchQuery.value = query; 

    if (query.isEmpty) {
      filteredLogs.value = logsNotifier.value;
    } else {
      filteredLogs.value = logsNotifier.value
          .where((log) => log.title.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
  }

  void addLog(String title, String desc, String category) {
    final String formattedTime = DateTime.now().toString().substring(0, 16);
    final newLog = LogModel(
      title: title, 
      description: desc, 
      timestamp: formattedTime, 
      category: category, 
    );
    
    logsNotifier.value = [...logsNotifier.value, newLog];
    filteredLogs.value = logsNotifier.value; 
    saveToDisk();
  }

  void updateLog(int index, String title, String desc, String category) {
    final currentLogs = List<LogModel>.from(logsNotifier.value);
    final String formattedTime = DateTime.now().toString().substring(0, 16);

    currentLogs[index] = LogModel(
      title: title, 
      description: desc, 
      timestamp: formattedTime,
      category: category, 
    );
    
    logsNotifier.value = currentLogs;
    filteredLogs.value = logsNotifier.value; 
    saveToDisk();
  }

  void removeLog(int index) {
    final currentLogs = List<LogModel>.from(logsNotifier.value);
    currentLogs.removeAt(index);
    
    logsNotifier.value = currentLogs;
    filteredLogs.value = logsNotifier.value; 
    saveToDisk();
  }

  Future<void> saveToDisk() async {
    final prefs = await SharedPreferences.getInstance();
    final String encodedData = jsonEncode(logsNotifier.value.map((e) => e.toMap()).toList());
    await prefs.setString(_userStorageKey, encodedData);
  }

  Future<void> loadFromDisk() async {
    final prefs = await SharedPreferences.getInstance();
    final String? data = prefs.getString(_userStorageKey);
    if (data != null) {
      final List decoded = jsonDecode(data);
      logsNotifier.value = decoded.map((e) => LogModel.fromMap(e)).toList();
      filteredLogs.value = logsNotifier.value;
    } else {
      logsNotifier.value = [];
      filteredLogs.value = [];
    }
  }
}
// lib/src/features/cycle_tracking/data/datasources/cycle_local_data_source.dart
import 'dart:convert';
import 'package:lafyamind_app/src/features/cycle_tracking/models/cycle_data.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CycleLocalDataSource {
  static const String CYCLES_KEY = 'cycles_data';

  Future<List<CycleData>> getCycles() async {
    final prefs = await SharedPreferences.getInstance();
    final cyclesJson = prefs.getStringList(CYCLES_KEY) ?? [];

    return cyclesJson
        .map((json) => CycleData.fromJson(jsonDecode(json)))
        .toList();
  }

  Future<void> saveCycles(List<CycleData> cycles) async {
    final prefs = await SharedPreferences.getInstance();
    final cyclesJson =
        cycles.map((cycle) => jsonEncode(cycle.toJson())).toList();

    await prefs.setStringList(CYCLES_KEY, cyclesJson);
  }

  // // Get day log for specific date
  // DayLog? getDayLog(DateTime date) {
  //   final formattedDate = DateTime(date.year, date.month, date.day);

  //   try {
  //     return dayLogs.firstWhere(
  //       (log) =>
  //           DateTime(log.date.year, log.date.month, log.date.day) ==
  //           formattedDate,
  //     );
  //   } catch (e) {
  //     // No log found for this date
  //     return null;
  //   }
  // }
}

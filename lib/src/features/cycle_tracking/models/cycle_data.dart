// lib/src/features/cycle_tracking/domain/models/cycle_data.dart
import 'package:flutter/foundation.dart';

enum CyclePhase { menstrual, follicular, ovulation, luteal }

enum FlowIntensity { none, light, medium, heavy }

enum Symptom {
  cramps,
  headache,
  bloating,
  breastTenderness,
  acne,
  fatigue,
  backache,
  nausea,
  spotting,
  cravings,
  insomnia,
  dizziness,
  other
}

enum MoodType {
  happy,
  calm,
  sensitive,
  sad,
  anxious,
  irritable,
  energetic,
  tired,
  stressed,
  other
}

class CycleData {
  final String id;
  final DateTime startDate;
  final int cycleLength;
  final int periodLength;
  final List<DayLog> dayLogs;

  CycleData({
    required this.id,
    required this.startDate,
    required this.cycleLength,
    required this.periodLength,
    required this.dayLogs,
  });

  // Copy with constructor for immutability
  CycleData copyWith({
    String? id,
    DateTime? startDate,
    int? cycleLength,
    int? periodLength,
    List<DayLog>? dayLogs,
  }) {
    return CycleData(
      id: id ?? this.id,
      startDate: startDate ?? this.startDate,
      cycleLength: cycleLength ?? this.cycleLength,
      periodLength: periodLength ?? this.periodLength,
      dayLogs: dayLogs ?? this.dayLogs,
    );
  }

  // Calculate current cycle day
  int getCurrentCycleDay() {
    final today = DateTime.now();
    return today.difference(startDate).inDays + 1;
  }

  // Determine current phase based on cycle day
  CyclePhase getCurrentPhase() {
    final cycleDay = getCurrentCycleDay();

    if (cycleDay <= periodLength) {
      return CyclePhase.menstrual;
    } else if (cycleDay < (cycleLength / 2) - 2) {
      return CyclePhase.follicular;
    } else if (cycleDay >= (cycleLength / 2) - 2 &&
        cycleDay <= (cycleLength / 2) + 2) {
      return CyclePhase.ovulation;
    } else {
      return CyclePhase.luteal;
    }
  }

  // Predict next period
  DateTime getPredictedNextPeriod() {
    return startDate.add(Duration(days: cycleLength));
  }

  // Get day log for specific date
  DayLog? getDayLog(DateTime date) {
    final formattedDate = DateTime(date.year, date.month, date.day);
    return dayLogs.firstWhere(
      (log) =>
          DateTime(log.date.year, log.date.month, log.date.day) ==
          formattedDate,
      orElse: () => DayLog(date: formattedDate, symptoms: []),
    );
  }

  // Factory constructor from JSON
  factory CycleData.fromJson(Map<String, dynamic> json) {
    return CycleData(
      id: json['id'],
      startDate: DateTime.parse(json['startDate']),
      cycleLength: json['cycleLength'],
      periodLength: json['periodLength'],
      dayLogs: (json['dayLogs'] as List)
          .map((logJson) => DayLog.fromJson(logJson))
          .toList(),
    );
  }

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'startDate': startDate.toIso8601String(),
      'cycleLength': cycleLength,
      'periodLength': periodLength,
      'dayLogs': dayLogs.map((log) => log.toJson()).toList(),
    };
  }
}

// lib/src/features/cycle_tracking/domain/models/day_log.dart
class DayLog {
  final DateTime date;
  final FlowIntensity? flow;
  final List<Symptom> symptoms;
  final MoodType? mood;
  final String? notes;

  DayLog({
    required this.date,
    this.flow,
    required this.symptoms,
    this.mood,
    this.notes,
  });

  // Copy with constructor for immutability
  DayLog copyWith({
    DateTime? date,
    FlowIntensity? flow,
    List<Symptom>? symptoms,
    MoodType? mood,
    String? notes,
  }) {
    return DayLog(
      date: date ?? this.date,
      flow: flow ?? this.flow,
      symptoms: symptoms ?? this.symptoms,
      mood: mood ?? this.mood,
      notes: notes ?? this.notes,
    );
  }

  // Factory constructor from JSON
  factory DayLog.fromJson(Map<String, dynamic> json) {
    return DayLog(
      date: DateTime.parse(json['date']),
      flow: json['flow'] != null ? FlowIntensity.values[json['flow']] : null,
      symptoms: json['symptoms'] != null
          ? (json['symptoms'] as List).map((i) => Symptom.values[i]).toList()
          : [],
      mood: json['mood'] != null ? MoodType.values[json['mood']] : null,
      notes: json['notes'],
    );
  }

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'date': date.toIso8601String(),
      'flow': flow?.index,
      'symptoms': symptoms.map((s) => s.index).toList(),
      'mood': mood?.index,
      'notes': notes,
    };
  }
}

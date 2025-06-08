// lib/src/features/cycle_tracking/data/repositories/cycle_repository_impl.dart
import 'package:lafyamind_app/src/features/cycle_tracking/data/cycle_local_data_source.dart';
import 'package:lafyamind_app/src/features/cycle_tracking/infrastructures/cycle_repository.dart';
import 'package:lafyamind_app/src/features/cycle_tracking/models/cycle_data.dart';
import 'package:uuid/uuid.dart';

class CycleRepositoryImpl implements CycleRepository {
  final CycleLocalDataSource localDataSource;

  CycleRepositoryImpl({required this.localDataSource});

  @override
  Future<List<CycleData>> getCycles() async {
    return await localDataSource.getCycles();
  }

  @override
  Future<CycleData?> getCurrentCycle() async {
    final cycles = await getCycles();
    if (cycles.isEmpty) return null;

    // Sort cycles by start date, most recent first
    cycles.sort((a, b) => b.startDate.compareTo(a.startDate));
    return cycles.first;
  }

  @override
  Future<void> saveCycle(CycleData cycle) async {
    final cycles = await getCycles();

    // Find and replace if cycle already exists
    final index = cycles.indexWhere((c) => c.id == cycle.id);
    if (index >= 0) {
      cycles[index] = cycle;
    } else {
      cycles.add(cycle);
    }

    await localDataSource.saveCycles(cycles);
  }

  @override
  Future<void> logDay(String cycleId, DayLog dayLog) async {
    final cycles = await getCycles();
    final index = cycles.indexWhere((c) => c.id == cycleId);

    if (index >= 0) {
      final cycle = cycles[index];
      final logIndex = cycle.dayLogs.indexWhere((log) =>
          log.date.year == dayLog.date.year &&
          log.date.month == dayLog.date.month &&
          log.date.day == dayLog.date.day);

      final updatedLogs = [...cycle.dayLogs];
      if (logIndex >= 0) {
        updatedLogs[logIndex] = dayLog;
      } else {
        updatedLogs.add(dayLog);
      }

      cycles[index] = cycle.copyWith(dayLogs: updatedLogs);
      await localDataSource.saveCycles(cycles);
    }
  }

  @override
  Future<void> startNewCycle(DateTime startDate,
      {int? estimatedLength, int? estimatedPeriodLength}) async {
    final cycles = await getCycles();

    // Default values if not provided
    final cycleLength = estimatedLength ?? 28;
    final periodLength = estimatedPeriodLength ?? 5;

    // Create new cycle
    final newCycle = CycleData(
      id: const Uuid().v4(),
      startDate: startDate,
      cycleLength: cycleLength,
      periodLength: periodLength,
      dayLogs: [
        DayLog(
          date: startDate,
          flow: FlowIntensity.medium,
          symptoms: [],
        ),
      ],
    );

    cycles.add(newCycle);
    await localDataSource.saveCycles(cycles);
  }
}

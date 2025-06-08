import 'package:lafyamind_app/src/features/cycle_tracking/models/cycle_data.dart';

abstract class CycleRepository {
  Future<List<CycleData>> getCycles();
  Future<CycleData?> getCurrentCycle();
  Future<void> saveCycle(CycleData cycle);
  Future<void> logDay(String cycleId, DayLog dayLog);
  Future<void> startNewCycle(DateTime startDate,
      {int? estimatedLength, int? estimatedPeriodLength});
}

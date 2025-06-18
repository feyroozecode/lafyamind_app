// lib/src/features/cycle_tracking/application/providers.dart
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lafyamind_app/src/features/cycle_tracking/data/cycle_data_reposiotry_impl.dart';
import 'package:lafyamind_app/src/features/cycle_tracking/data/cycle_local_data_source.dart';
import 'package:lafyamind_app/src/features/cycle_tracking/infrastructures/cycle_repository.dart';
import 'package:lafyamind_app/src/features/cycle_tracking/models/cycle_data.dart';

// Data source provider
final cycleLocalDataSourceProvider = Provider<CycleLocalDataSource>((ref) {
  return CycleLocalDataSource();
});

// Repository provider
final cycleRepositoryProvider = Provider<CycleRepository>((ref) {
  return CycleRepositoryImpl(
    localDataSource: ref.watch(cycleLocalDataSourceProvider),
  );
});

// Cycles provider
final cyclesProvider = FutureProvider<List<CycleData>>((ref) async {
  final repository = ref.watch(cycleRepositoryProvider);
  return await repository.getCycles();
});

// Current cycle provider
final currentCycleProvider = FutureProvider<CycleData?>((ref) async {
  final repository = ref.watch(cycleRepositoryProvider);
  return await repository.getCurrentCycle();
});

// Selected date provider
final selectedDateProvider = StateProvider<DateTime>((ref) {
  return DateTime.now();
});

// // Day log for selected date provider
// final selectedDayLogProvider = FutureProvider<DayLog?>((ref) async {
//   final selectedDate = ref.watch(selectedDateProvider);
//   final currentCycleAsync = ref.watch(currentCycleProvider);

//   final currentCycle = await currentCycleAsync.when(
//     data: (cycle) => cycle,
//     loading: () async => null,
//     error: (_, __) async => null,
//   );

//   if (currentCycle == null) return null;

//   return await currentCycle.getDayLog(selectedDate);
//   //currentCycle.getDayLog(selectedDate);
// });

// Day log state notifier for editing
class DayLogNotifier extends StateNotifier<DayLog?> {
  final CycleRepository repository;
  final String? cycleId;

  DayLogNotifier(this.repository, this.cycleId, DayLog? initialState)
      : super(initialState);

  void setFlow(FlowIntensity flow) {
    if (state == null) return;
    state = state!.copyWith(flow: flow);
  }

  void toggleSymptom(Symptom symptom) {
    if (state == null) return;
    final symptoms = List<Symptom>.from(state!.symptoms);

    if (symptoms.contains(symptom)) {
      symptoms.remove(symptom);
    } else {
      symptoms.add(symptom);
    }

    state = state!.copyWith(symptoms: symptoms);
  }

  void setMood(MoodType mood) {
    if (state == null) return;
    state = state!.copyWith(mood: mood);
  }

  void setNotes(String notes) {
    if (state == null) return;
    state = state!.copyWith(notes: notes);
  }

  Future<void> save() async {
    if (state == null || cycleId == null) return;
    await repository.logDay(cycleId!, state!);
  }
}

// Day log editor provider
final dayLogEditorProvider =
    StateNotifierProvider.autoDispose<DayLogNotifier, DayLog?>((ref) {
  final repository = ref.watch(cycleRepositoryProvider);
  final currentCycleAsync = ref.watch(currentCycleProvider);
  final selectedDate = ref.watch(selectedDateProvider);
  //final selectedDayLogAsync = ref.watch(selectedDayLogProvider);

  // Get current cycle ID
  String? cycleId;
  currentCycleAsync.whenData((cycle) {
    cycleId = cycle?.id;
  });

  // Get initial day log state
  DayLog? initialDayLog;
  // selectedDayLogAsync.whenData((dayLog) {
  //   initialDayLog = dayLog;
  // });

  // If no initial day log exists, create an empty one
  if (initialDayLog == null) {
    initialDayLog = DayLog(
      date: selectedDate,
      symptoms: [],
    );
  }

  return DayLogNotifier(repository, cycleId, initialDayLog);
});

// Provider to start a new cycle
final startNewCycleProvider =
    Provider<Future<void> Function(DateTime startDate)>((ref) {
  final repository = ref.watch(cycleRepositoryProvider);

  return (DateTime startDate) async {
    await repository.startNewCycle(startDate);
    ref.refresh(cyclesProvider);
    ref.refresh(currentCycleProvider);
  };
});

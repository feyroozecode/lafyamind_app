import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lafyamind_app/src/features/cycle_tracking/application/providers.dart';

class FirstCycleForm extends ConsumerStatefulWidget {
  const FirstCycleForm({Key? key}) : super(key: key);

  @override
  ConsumerState<FirstCycleForm> createState() => _FirstCycleFormState();
}

class _FirstCycleFormState extends ConsumerState<FirstCycleForm> {
  final _formKey = GlobalKey<FormState>();
  DateTime _lastPeriodStartDate = DateTime.now();
  int _cycleLength = 28;
  int _periodLength = 5;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Welcome to Cycle Tracking!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'To get started, we need some information about your menstrual cycle.',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 24),

            // Last period start date
            const Text(
              'When did your last period start?',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            GestureDetector(
              onTap: _showDatePicker,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${_lastPeriodStartDate.day}/${_lastPeriodStartDate.month}/${_lastPeriodStartDate.year}',
                      style: const TextStyle(fontSize: 16),
                    ),
                    const Icon(Icons.calendar_today),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Cycle length
            const Text(
              'What is your average cycle length?',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'A menstrual cycle is counted from the first day of one period to the first day of the next.',
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: Slider(
                    value: _cycleLength.toDouble(),
                    min: 21,
                    max: 35,
                    divisions: 14,
                    label: _cycleLength.toString(),
                    onChanged: (value) {
                      setState(() {
                        _cycleLength = value.round();
                      });
                    },
                  ),
                ),
                Container(
                  width: 60,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '$_cycleLength',
                    style: const TextStyle(fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Period length
            const Text(
              'How many days does your period usually last?',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: Slider(
                    value: _periodLength.toDouble(),
                    min: 2,
                    max: 10,
                    divisions: 8,
                    label: _periodLength.toString(),
                    onChanged: (value) {
                      setState(() {
                        _periodLength = value.round();
                      });
                    },
                  ),
                ),
                Container(
                  width: 60,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '$_periodLength',
                    style: const TextStyle(fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 32),

            // Submit button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _submitForm,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text(
                  'lancer la Track de mon Cycle',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showDatePicker() async {
    final selectedDate = await showDatePicker(
      context: context,
      initialDate: _lastPeriodStartDate,
      firstDate: DateTime.now().subtract(const Duration(days: 90)),
      lastDate: DateTime.now(),
    );

    if (selectedDate != null) {
      setState(() {
        _lastPeriodStartDate = selectedDate;
      });
    }
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      final startNewCycle = ref.read(startNewCycleProvider);
      await startNewCycle(
        _lastPeriodStartDate,
      );

      // Show success message
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Your cycle has been set up!')),
        );
      }
    }
  }
}

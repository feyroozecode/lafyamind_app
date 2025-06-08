import 'package:flutter/material.dart';
import 'package:lafyamind_app/src/features/core/common_import.dart';
import 'package:lafyamind_app/src/features/cycle_tracking/models/cycle_data.dart';

class SymptomSelector extends StatelessWidget {
  final List<Symptom> selectedSymptoms;
  final Function(Symptom) onSymptomToggled;

  const SymptomSelector({
    Key? key,
    required this.selectedSymptoms,
    required this.onSymptomToggled,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: Symptom.values.map((symptom) {
        final isSelected = selectedSymptoms.contains(symptom);
        return _buildSymptomChip(symptom, isSelected);
      }).toList(),
    );
  }

  Widget _buildSymptomChip(Symptom symptom, bool isSelected) {
    return FilterChip(
      label: Text(_getSymptomLabel(symptom)),
      selected: isSelected,
      onSelected: (_) => onSymptomToggled(symptom),
      backgroundColor: Colors.grey.shade200,
      selectedColor: Colors.purple.shade100,
      checkmarkColor: Colors.purple,
    );
  }

  String _getSymptomLabel(Symptom symptom) {
    switch (symptom) {
      case Symptom.cramps:
        return 'Crampes';
      case Symptom.headache:
        return 'Maux de tête';
      case Symptom.bloating:
        return 'Ballonnements';
      case Symptom.breastTenderness:
        return 'Sensibilité des seins';
      case Symptom.acne:
        return 'Acné';
      case Symptom.fatigue:
        return 'Fatigue';
      case Symptom.backache:
        return 'Mal de dos';
      case Symptom.nausea:
        return 'Nausée';
      case Symptom.spotting:
        return 'Spotting';
      case Symptom.cravings:
        return 'Envies alimentaires';
      case Symptom.insomnia:
        return 'Insomnie';
      case Symptom.dizziness:
        return 'Vertiges';
      case Symptom.other:
        return 'Autre';
      default:
        return '';
    }
  }
}

import 'package:flutter/material.dart';
import 'package:lafyamind_app/src/features/cycle_tracking/models/cycle_data.dart';

class FlowSelector extends StatelessWidget {
  final FlowIntensity? selectedFlow;
  final Function(FlowIntensity) onFlowSelected;

  const FlowSelector({
    Key? key,
    required this.selectedFlow,
    required this.onFlowSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildFlowOption(context, FlowIntensity.none, 'None'),
        _buildFlowOption(context, FlowIntensity.light, 'Light'),
        _buildFlowOption(context, FlowIntensity.medium, 'Medium'),
        _buildFlowOption(context, FlowIntensity.heavy, 'Heavy'),
      ],
    );
  }

  Widget _buildFlowOption(
      BuildContext context, FlowIntensity flow, String label) {
    final isSelected = selectedFlow == flow;
    final color = _getFlowColor(flow);

    return GestureDetector(
      onTap: () => onFlowSelected(flow),
      child: Column(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: isSelected ? color : Colors.transparent,
              border: Border.all(
                color: color,
                width: 2,
              ),
              shape: BoxShape.circle,
            ),
            child: isSelected
                ? const Icon(Icons.check, color: Colors.white)
                : null,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  Color _getFlowColor(FlowIntensity flow) {
    switch (flow) {
      case FlowIntensity.none:
        return Colors.grey;
      case FlowIntensity.light:
        return Colors.red.shade300;
      case FlowIntensity.medium:
        return Colors.red.shade500;
      case FlowIntensity.heavy:
        return Colors.red.shade700;
      default:
        return Colors.grey;
    }
  }
}

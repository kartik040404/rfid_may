import 'package:flutter/material.dart';

class StepperIndicatorWidget extends StatelessWidget {
  final int currentStep;
  final List<String> stepLabels;

  const StepperIndicatorWidget({
    super.key,
    required this.currentStep,
    required this.stepLabels,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: List.generate(stepLabels.length, (index) {
          return _buildStepIndicator(
            context: context,
            index: index,
            label: stepLabels[index],
          );
        }),
      ),
    );
  }

  Widget _buildStepIndicator({
    required BuildContext context,
    required int index,
    required String label,
  }) {
    bool isActive = currentStep >= index;
    bool isCompleted = currentStep > index;
    Color activeColor = Colors.red.shade700;
    Color inactiveColor = Colors.grey.shade300;
    Color activeTextColor = Colors.red.shade700;
    Color inactiveTextColor = Colors.grey.shade600;

    return Column(
      children: [
        CircleAvatar(
          radius: 18,
          backgroundColor: isActive ? activeColor : inactiveColor,
          child: isCompleted
              ? const Icon(Icons.check, color: Colors.white, size: 20)
              : Text(
                  '${index + 1}',
                  style: TextStyle(
                    color: isActive ? Colors.white : Colors.black54,
                    fontWeight: FontWeight.bold,
                  ),
                ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 12,
            color: isActive ? activeTextColor : inactiveTextColor,
            fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
          ),
        )
      ],
    );
  }
}

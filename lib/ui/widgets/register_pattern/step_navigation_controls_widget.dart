import 'package:flutter/material.dart';

class StepNavigationControlsWidget extends StatelessWidget {
  final int currentStep;
  final int totalSteps;
  final Function onNext;
  final Function onBack;
  final bool Function() canProceedToNextStep;
  final Future<bool?> Function()? onConfirmNext;

  const StepNavigationControlsWidget({
    super.key,
    required this.currentStep,
    required this.totalSteps,
    required this.onNext,
    required this.onBack,
    required this.canProceedToNextStep,
    this.onConfirmNext,
  });

  @override
  Widget build(BuildContext context) {
    Color primaryColor = Colors.red.shade700;
    Color disabledColor = Colors.grey.shade400;
    Color buttonTextColor = Colors.white;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if (currentStep > 0)
            TextButton.icon(
              icon: Icon(Icons.arrow_back_ios, color: Colors.grey.shade700, size: 16),
              label: Text("Back", style: TextStyle(color: Colors.grey.shade700, fontSize: 14)),
              onPressed: () => onBack(),
              style: TextButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10)),
            )
          else
            const SizedBox(), // To maintain space when back button is not shown

          if (currentStep < totalSteps - 1)
            ElevatedButton.icon(
              label: const Text("Continue"),
              icon: const Icon(Icons.arrow_forward_ios, size: 16),
              onPressed: () async {
                if (!canProceedToNextStep()) {
                  String message = currentStep == 0
                      ? 'Please select a pattern to continue.'
                      : 'Please scan at least one RFID tag to continue.';
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(message),
                      backgroundColor: Colors.orange.shade700,
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                  return;
                }
                if (onConfirmNext != null) {
                  final proceed = await onConfirmNext!();
                  if (proceed == true) {
                    onNext();
                  }
                } else {
                  onNext();
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                foregroundColor: buttonTextColor,
                padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 10),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                textStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
              ),
            ),
        ],
      ),
    );
  }
}

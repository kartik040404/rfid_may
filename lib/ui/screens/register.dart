import 'package:flutter/material.dart';

class RegisterPatternPage extends StatefulWidget {
  @override
  _RegisterPatternPageState createState() => _RegisterPatternPageState();
}

class _RegisterPatternPageState extends State<RegisterPatternPage> {
  int _currentStep = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Register New Pattern", style: TextStyle(color: Colors.white)),
        backgroundColor: Color(0xFF1E1E1E), // Dark theme
        iconTheme: IconThemeData(color: Colors.white), // Back arrow color
      ),
      body: Theme(
        data: Theme.of(context).copyWith(
          colorScheme: ColorScheme.light(
            primary: Color(0xFF6A5ACD), // Purple theme
            onPrimary: Colors.white,
            secondary: Color(0xFFB0B0B0), // Gray for inactive steps
          ),
        ),
        child: Stepper(
          type: StepperType.vertical,
          currentStep: _currentStep,
          onStepContinue: () {
            if (_currentStep < 3) {
              setState(() => _currentStep += 1);
            }
          },
          onStepCancel: () {
            if (_currentStep > 0) {
              setState(() => _currentStep -= 1);
            }
          },
          steps: [
            Step(
              title: Text("Register New Pattern"),
              content: TextField(
                decoration: InputDecoration(
                  labelText: "Pattern Name",
                  border: OutlineInputBorder(),
                ),
              ),
              isActive: _currentStep >= 0,
              state: _currentStep > 0 ? StepState.complete : StepState.indexed,
            ),
            Step(
              title: Text("Enter Pattern Metadata"),
              content: TextField(
                decoration: InputDecoration(
                  labelText: "Metadata Details",
                  border: OutlineInputBorder(),
                ),
              ),
              isActive: _currentStep >= 1,
              state: _currentStep > 1 ? StepState.complete : StepState.indexed,
            ),
            Step(
              title: Text("Attach RFID Tag"),
              content: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF1E1E1E), // Purple
                  foregroundColor: Colors.white,
                ),
                onPressed: () {},
                child: Text("Scan RFID Tag"),
              ),
              isActive: _currentStep >= 2,
              state: _currentStep > 2 ? StepState.complete : StepState.indexed,
            ),
            Step(
              title: Text("Save New Pattern"),
              content: Column(
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF1E1E1E), // Dark button
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    ),
                    onPressed: () {
                      // Logic to save the pattern
                    },
                    child: Text("Save Pattern"),
                  ),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        _currentStep = 0; // Reset back to step 1
                      });
                    },
                    child: Text("Cancel", style: TextStyle(color: Colors.red)),
                  ),
                ],
              ),
              isActive: _currentStep >= 3,
              state: _currentStep == 3 ? StepState.complete : StepState.indexed,
            ),
          ],
          controlsBuilder: (BuildContext context, ControlsDetails details) {
            if (_currentStep == 3) {
              return SizedBox.shrink(); // Hide default buttons at last step
            }
            return Row(
              children: <Widget>[
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF1E1E1E),
                    foregroundColor: Colors.white,
                  ),
                  onPressed: details.onStepContinue,
                  child: Text("Continue"),
                ),
                TextButton(
                  onPressed: details.onStepCancel,
                  child: Text("Back", style: TextStyle(color: Colors.red)),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:testing_aar_file/ui/widgets/custom_app_bar.dart';
import '../../../../../RFIDPlugin.dart';
import '../../widgets/register_pattern/stepper_indicator_widget.dart';
import '../../widgets/register_pattern/pattern_selection_step_widget.dart';
import '../../widgets/register_pattern/rfid_attachment_step_widget.dart';
import '../../widgets/register_pattern/review_and_save_step_widget.dart';
import '../../widgets/register_pattern/step_navigation_controls_widget.dart';

class NewRegisterPatternScreen extends StatefulWidget {
  @override
  _NewRegisterPatternScreenState createState() =>
      _NewRegisterPatternScreenState();
}

class _NewRegisterPatternScreenState extends State<NewRegisterPatternScreen> {
  int _currentStep = 0;
  final int _totalSteps = 3; // Define total steps

  String status = 'Idle';
  final TextEditingController _searchController = TextEditingController();

  List<Map<String, String>> allPatterns = [
    {"name": "Pattern Alpha", "code": "A001X"},
    {"name": "Pattern Bravo", "code": "B002Y"},
    {"name": "Pattern Charlie", "code": "C003Z"},
    {"name": "Pattern Delta", "code": "D004W"},
    {"name": "Pattern Echo", "code": "E005V"},
  ];
  List<Map<String, String>> filteredPatterns = [];

  Map<String, String>? selectedPattern;
  final List<String> rfidTags = [];
  bool isScanning = false;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
    _onSearchChanged(); // Initial call to populate or clear based on controller's text
  }

  void _onSearchChanged() {
    String query = _searchController.text.toLowerCase().trim();
    setState(() {
      if (query.isEmpty) {
        filteredPatterns = []; // Show nothing or a message if query is empty
      } else {
        filteredPatterns = allPatterns
            .where((pattern) =>
                pattern['name']!.toLowerCase().contains(query) ||
                pattern['code']!.toLowerCase().contains(query))
            .toList();
      }
    });
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  Future<void> startInventory() async {
    if (rfidTags.length >= 3) {
      setState(() {
        status = 'Maximum 3 RFID tags allowed.';
      });
      return;
    }

    setState(() {
      isScanning = true;
      status = 'Scanning for RFID tag...';
    });

    try {
      await RFIDPlugin.setPower(1);
      final epc = await RFIDPlugin.readSingleTag();

      if (!mounted) return; // Check if the widget is still in the tree

      setState(() {
        isScanning = false;
        if (epc != null && epc.isNotEmpty) {
          if (!rfidTags.contains(epc)) {
            rfidTags.add(epc);
            status = 'Tag Scanned: $epc';
          } else {
            status = 'Tag already added: $epc';
          }
        } else {
          status = 'No Tag Found or empty EPC.';
        }
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        isScanning = false;
        status = 'Error during scan: $e';
      });
    }
  }

  Future<void> stopInventory() async {
    if (isScanning) {
      try {
        await RFIDPlugin.stopInventory();
      } catch (e) {
        print('Error stopping inventory: $e');
      }
      if (!mounted) return;
      setState(() {
        isScanning = false;
        status = 'Scanning Stopped.';
      });
    }
  }

  void removeRfidTag(int index) {
    setState(() {
      rfidTags.removeAt(index);
      status = rfidTags.isEmpty ? 'No tags attached.' : 'Tag removed.';
    });
  }

  Future<void> savePattern() async {
    if (selectedPattern == null || rfidTags.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Pattern and RFID tags must be selected.'),
          backgroundColor: Colors.orange.shade700,
        ),
      );
      return;
    }

    final payload = {
      "pattern_code": selectedPattern!['code'],
      "pattern_name": selectedPattern!['name'],
      "rfids": rfidTags,
    };

    final uri = Uri.parse("http://your-api-endpoint.com/patterns");

    setState(() {
      status = "Saving pattern..."; // Indicate saving process
    });

    try {
      final response = await http.post(
        uri,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(payload),
      ).timeout(const Duration(seconds: 10)); // Add a timeout

      if (!mounted) return;

      if (response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Pattern saved successfully!'),
            backgroundColor: Colors.green.shade700,
          ),
        );
        setState(() {
          selectedPattern = null;
          rfidTags.clear();
          _currentStep = 0;
          _searchController.clear(); // This will trigger _onSearchChanged
          status = 'Idle';
        });
      } else {
        String errorMessage = 'Failed to save pattern.';
        try {
          final responseBody = jsonDecode(response.body);
          if (responseBody['message'] != null) {
            errorMessage += ' Server: ${responseBody['message']}';
          }
        } catch (_) {
        }
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('$errorMessage (Code: ${response.statusCode})'),
            backgroundColor: Colors.red.shade700,
          ),
        );
        setState(() {
          status = "Save failed.";
        });
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error saving pattern: $e'),
          backgroundColor: Colors.red.shade700,
        ),
      );
      setState(() {
        status = "Save error.";
      });
    }
  }

  Future<bool?> _confirmPatternDialog() async {
    return showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Row(
          children: [
            Icon(Icons.check_circle_outline, color: Colors.red.shade700, size: 28),
            const SizedBox(width: 12),
            const Text(
              'Confirm Selection',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Divider(height: 20, thickness: 1),
            const Text('You have selected:',
                style: TextStyle(fontSize: 16, color: Colors.black54)),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.red.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.red.shade200),
              ),
              child: Text(
                '${selectedPattern?['name']} (${selectedPattern?['code']})',
                style: TextStyle(
                    fontSize: 17, // Slightly larger for emphasis
                    fontWeight: FontWeight.w600,
                    color: Colors.red.shade900),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Proceed to attach RFID tags?',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
        actionsPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: Text('Cancel', style: TextStyle(color: Colors.grey.shade700, fontSize: 16, fontWeight: FontWeight.bold)),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red.shade700,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
              textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)
            ),
            child: const Text('Continue'),
          ),
        ],
      ),
    );
  }

  bool _canProceedToNextStep() {
    switch (_currentStep) {
      case 0:
        return selectedPattern != null;
      case 1:
        return rfidTags.isNotEmpty;
      default:
        return true; // For review step, always allow if reached
    }
  }

  void _onNextStep() {
    if (_currentStep < _totalSteps - 1) {
      setState(() {
        _currentStep++;
        if (_currentStep == 1) { // Moving to RFID step
             status = rfidTags.isEmpty ? 'Scan RFID tags.' : '${rfidTags.length} tag(s) attached.';
        } else if (_currentStep == 2) { // Moving to Review step
            status = "Review your pattern details.";
        }
      });
    }
  }

  void _onPreviousStep() {
    if (_currentStep > 0) {
      setState(() {
        _currentStep--;
         if (_currentStep == 0) { // Moving back to Pattern Selection
            status = "Select a pattern.";
         } else if (_currentStep == 1) { // Moving back to RFID step
            status = rfidTags.isEmpty ? 'Scan RFID tags.' : '${rfidTags.length} tag(s) attached.';
         }
      });
    }
  }
  
  List<Widget> _buildStepWidgets() {
    return [
      PatternSelectionStepWidget(
        searchController: _searchController,
        filteredPatterns: filteredPatterns,
        selectedPattern: selectedPattern,
        onPatternSelected: (pattern) {
          setState(() {
            selectedPattern = pattern;
          });
        },
      ),
      RfidAttachmentStepWidget(
        status: status,
        rfidTags: rfidTags,
        isScanning: isScanning,
        onStartInventory: startInventory,
        onStopInventory: stopInventory,
        onRemoveRfidTag: removeRfidTag,
      ),
      ReviewAndSaveStepWidget(
        selectedPattern: selectedPattern,
        rfidTags: rfidTags,
        onSavePattern: savePattern,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final List<String> stepLabels = [
      'Select Pattern',
      'Attach Tags',
      'Review & Save',
    ];

    return WillPopScope(
      onWillPop: () async {
        if (_currentStep > 0) {
          setState(() {
            _currentStep--;
          });
          return false; // Prevent default back navigation
        }
        return true; // Allow back navigation if on the first step
      },
      child: Scaffold(
        appBar: const CustomAppBar(title: 'Register New Pattern'),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              StepperIndicatorWidget(
                currentStep: _currentStep,
                stepLabels: stepLabels,
              ),
              const SizedBox(height: 16), // Spacing after stepper
              Expanded(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  transitionBuilder: (Widget child, Animation<double> animation) {
                    return FadeTransition(opacity: animation, child: child);
                  },
                  child: Container( // Key added to ensure AnimatedSwitcher updates
                    key: ValueKey<int>(_currentStep),
                    child: _buildStepWidgets()[_currentStep],
                  ),
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: StepNavigationControlsWidget(
          currentStep: _currentStep,
          totalSteps: _totalSteps,
          onNext: _onNextStep,
          onBack: _onPreviousStep,
          canProceedToNextStep: _canProceedToNextStep,
          onConfirmNext: _currentStep == 0 ? _confirmPatternDialog : null,
        ),
      ),
    );
  }
}
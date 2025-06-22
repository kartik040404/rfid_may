import 'package:flutter/material.dart';

class PatternSelectionStepWidget extends StatelessWidget {
  final TextEditingController searchController;
  final FocusNode searchFocusNode;
  final List<Map<String, String>> filteredPatterns;
  final Map<String, String>? selectedPattern;
  final Function(Map<String, String>) onPatternSelected;

  const PatternSelectionStepWidget({
    super.key,
    required this.searchController,
    required this.searchFocusNode,
    required this.filteredPatterns,
    required this.selectedPattern,
    required this.onPatternSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation:4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Select Pattern Name/Code",
              style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold,fontSize: 16),
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: 300, // set your desired width
              height: 48, // set your desired height
              child: TextField(
                controller: searchController,
                focusNode: searchFocusNode,
                decoration: InputDecoration(
                  hintText: "Enter pattern name or code",
                  hintStyle: TextStyle(fontSize: 14), // change hint text size here
                  prefixIcon: Icon(Icons.search, color: Colors.red.shade700),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.grey.shade400),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.red.shade700, width: 2),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            if (searchController.text.isNotEmpty && filteredPatterns.isEmpty)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: Text(
                    "No patterns found matching your search.",
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 16),
                  ),
                ),
              ),
            Expanded(
              child: searchController.text.isNotEmpty
                  ? ListView.builder(
                      itemCount: filteredPatterns.length,
                      itemBuilder: (context, idx) {
                        final pat = filteredPatterns[idx];
                        final isSelected = selectedPattern != null &&
                            selectedPattern!['code'] == pat['code'];
                        return Card(
                          elevation: 2,
                          margin: const EdgeInsets.symmetric(vertical: 4.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                            side: BorderSide(
                              color: isSelected ? Colors.red.shade700 : Colors.transparent,
                              width: 1.5,
                            ),
                          ),
                          color: isSelected ? Colors.red.shade50 : Colors.white,
                          child: ListTile(
                            title: Flexible(
                              child: Text(
                                '${pat['name']} (${pat['code']})',
                                style: TextStyle(
                                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                  color: isSelected ? Colors.red.shade900 : Colors.black87,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            trailing: isSelected
                                ? Icon(Icons.check_circle, color: Colors.red.shade700)
                                : null,
                            onTap: () => onPatternSelected(pat),
                          ),
                        );
                      },
                    )
                  : Center(
                      child: Text(
                        "Start typing to search for available patterns.",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.grey.shade600, fontSize: 15),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'dart:ui';
import 'package:flutter/material.dart';
import '../../../utils/size_config.dart';

class PatternSelectionStepWidget extends StatefulWidget {
  final TextEditingController searchController;
  final List<Map<String, String>> filteredPatterns;
  final Map<String, String>? selectedPattern;
  final Function(Map<String, String>) onPatternSelected;
  final FocusNode searchFocusNode;

  const PatternSelectionStepWidget({
    super.key,
    required this.searchController,
    required this.filteredPatterns,
    required this.selectedPattern,
    required this.onPatternSelected,
    required this.searchFocusNode,
  });

  @override
  State<PatternSelectionStepWidget> createState() => _PatternSelectionStepWidgetState();
}

class _PatternSelectionStepWidgetState extends State<PatternSelectionStepWidget> {
  bool _isSearchFocused = false;

  @override
  void initState() {
    super.initState();
    widget.searchFocusNode.addListener(_handleFocusChange);
  }

  @override
  void dispose() {
    widget.searchFocusNode.removeListener(_handleFocusChange);
    super.dispose();
  }

  void _handleFocusChange() {
    setState(() {
      _isSearchFocused = widget.searchFocusNode.hasFocus;
    });
  }

  void _closeSearchOverlay() {
    widget.searchFocusNode.unfocus();
    setState(() {
      _isSearchFocused = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return Stack(
      children: [
        // Main content (initial layout)
        _buildInitialLayout(context),
        // Overlay search UI
        if (_isSearchFocused) _buildSearchOverlayStack(context),
      ],
    );
  }

  Widget _buildInitialLayout(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: EdgeInsets.all(SizeConfig.blockSizeHorizontal * 4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Select Pattern Name/Code",
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: SizeConfig.textMultiplier * 2,
              ),
            ),
            SizedBox(height: SizeConfig.blockSizeVertical * 1.5),
            SizedBox(
              width: double.infinity,
              height: SizeConfig.blockSizeVertical * 6,
              child: TextField(
                controller: widget.searchController,
                focusNode: widget.searchFocusNode,
                decoration: InputDecoration(
                  hintText: "Enter pattern name or code",
                  hintStyle: TextStyle(fontSize: SizeConfig.textMultiplier * 1.5),
                  prefixIcon: Icon(Icons.search, color: Colors.red.shade700),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.grey.shade400),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.red.shade700, width: 2),
                  ),
                  contentPadding: EdgeInsets.symmetric(horizontal: SizeConfig.blockSizeHorizontal * 2),
                ),
              ),
            ),
            SizedBox(height: SizeConfig.blockSizeVertical * 1.5),
            if (widget.searchController.text.isNotEmpty && widget.filteredPatterns.isEmpty)
              Padding(
                padding: EdgeInsets.all(SizeConfig.blockSizeHorizontal * 2),
                child: Center(
                  child: Text(
                    "No patterns found matching your search.",
                    style: TextStyle(color: Colors.grey.shade600, fontSize: SizeConfig.textMultiplier * 1.7),
                  ),
                ),
              ),
            Expanded(
              child: widget.searchController.text.isNotEmpty
                  ? Container(
                      child: Scrollbar(
                        thumbVisibility: true,
                        child: ListView.builder(
                          itemCount: widget.filteredPatterns.length,
                          itemBuilder: (context, idx) {
                            final pat = widget.filteredPatterns[idx];
                            final isSelected = widget.selectedPattern != null &&
                                widget.selectedPattern!['code'] == pat['code'];
                            return Card(
                              elevation: 2,
                              margin: EdgeInsets.symmetric(vertical: SizeConfig.blockSizeVertical * 0.5),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                                side: BorderSide(
                                  color: isSelected ? Colors.red.shade700 : Colors.transparent,
                                  width: 1.5,
                                ),
                              ),
                              color: isSelected ? Colors.red.shade50 : Colors.white,
                              child: ListTile(
                                title: Text(
                                  '${pat['name']} (${pat['code']})',
                                  style: TextStyle(
                                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                    color: isSelected ? Colors.red.shade900 : Colors.black87,
                                    fontSize: SizeConfig.textMultiplier * 1.7,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                                trailing: isSelected
                                    ? Icon(Icons.check_circle, color: Colors.red.shade700)
                                    : null,
                                onTap: () => widget.onPatternSelected(pat),
                              ),
                            );
                          },
                        ),
                      ),
                    )
                  : Center(
                      child: Text(
                        "Start typing to search for available patterns.",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.grey.shade600, fontSize: SizeConfig.textMultiplier * 1.5),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  // Overlay UI using Stack: search bar at top, list up to keyboard, blocks background
  Widget _buildSearchOverlayStack(BuildContext context) {
    final mq = MediaQuery.of(context);
    final bottomInset = mq.viewInsets.bottom; // keyboard height
    return Positioned.fill(
      child: GestureDetector(
        onTap: _closeSearchOverlay,
        child: AbsorbPointer(
          absorbing: false,
          child: Container(
            color: Colors.white.withOpacity(0.98),
            child: Column(
              children: [
                SafeArea(
                  child: Container(
                    margin: EdgeInsets.only(
                      left: SizeConfig.blockSizeHorizontal * 2,
                      right: SizeConfig.blockSizeHorizontal * 2,
                      top: SizeConfig.blockSizeVertical * 1.5,
                    ),
                    child: Material(
                      elevation: 4,
                      borderRadius: BorderRadius.circular(10),
                      child: SizedBox(
                        height: SizeConfig.blockSizeVertical * 6,
                        child: TextField(
                          controller: widget.searchController,
                          focusNode: widget.searchFocusNode,
                          autofocus: true,
                          decoration: InputDecoration(
                            hintText: "Enter pattern name or code",
                            hintStyle: TextStyle(fontSize: SizeConfig.textMultiplier * 1.5),
                            prefixIcon: Icon(Icons.search, color: Colors.red.shade700),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(color: Colors.grey.shade400),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(color: Colors.red.shade700, width: 2),
                            ),
                            contentPadding: EdgeInsets.symmetric(horizontal: SizeConfig.blockSizeHorizontal * 2),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    margin: EdgeInsets.only(
                      left: SizeConfig.blockSizeHorizontal * 2,
                      right: SizeConfig.blockSizeHorizontal * 2,
                      top: SizeConfig.blockSizeVertical * 2,
                      bottom: bottomInset, // leave space for keyboard
                    ),
                    child: widget.searchController.text.isNotEmpty
                        ? Scrollbar(
                            thumbVisibility: true,
                            child: ListView.builder(
                              itemCount: widget.filteredPatterns.length,
                              itemBuilder: (context, idx) {
                                final pat = widget.filteredPatterns[idx];
                                final isSelected = widget.selectedPattern != null &&
                                    widget.selectedPattern!['code'] == pat['code'];
                                return Card(
                                  elevation: 2,
                                  margin: EdgeInsets.symmetric(vertical: SizeConfig.blockSizeVertical * 0.5),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    side: BorderSide(
                                      color: isSelected ? Colors.red.shade700 : Colors.transparent,
                                      width: 1.5,
                                    ),
                                  ),
                                  color: isSelected ? Colors.red.shade50 : Colors.white,
                                  child: ListTile(
                                    title: Text(
                                      '${pat['name']} (${pat['code']})',
                                      style: TextStyle(
                                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                        color: isSelected ? Colors.red.shade900 : Colors.black87,
                                        fontSize: SizeConfig.textMultiplier * 1.7,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    trailing: isSelected
                                        ? Icon(Icons.check_circle, color: Colors.red.shade700)
                                        : null,
                                    onTap: () {
                                      widget.onPatternSelected(pat);
                                      widget.searchFocusNode.unfocus();
                                      setState(() {
                                        _isSearchFocused = false;
                                      });
                                    },
                                  ),
                                );
                              },
                            ),
                          )
                        : Center(
                            child: Text(
                              "Start typing to search for available patterns.",
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.grey.shade600, fontSize: SizeConfig.textMultiplier * 1.5),
                            ),
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

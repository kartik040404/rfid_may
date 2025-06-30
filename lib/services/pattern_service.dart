// lib/services/pattern_service.dart

import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import '../model/Pattern.dart';

class PatternService {
  static final BASE_URL = dotenv.env['BASE_URL'];

  // In-memory cache keyed by rfdId
  static Map<String, Pattern> patterns = {};

  // Fetch all patterns from backend and index them by `rfdId`.
  static Future<void> fetchPatterns() async {
    final uri = Uri.parse('${BASE_URL}/api/productionappservices/getpatterndetailslist');
    print("=========================${uri}");
    final resp = await http.get(uri);
    if (resp.statusCode == 200) {
      final List<dynamic> data = json.decode(resp.body);
      final fetched = data.map((e) => Pattern.fromJson(e)).toList();
      // Build a map where each key is the tag ID (rfdId)
      patterns = {
        for (final p in fetched)
          p.rfdId: p,
      };
      print('Loaded ${patterns.length} patterns keyed by RFID');
    } else {
      throw Exception('Failed to load patterns (${resp.statusCode})');
    }
  }

  // Lookup a pattern by its scanned RFID tag.
  static Pattern? getByTag(String tag) => patterns[tag];

  // Update a pattern’s `rfdId` on the server and locally re-index the map.
  static Future<void> updateRfd({
    required String patternCode,
    required String rfdId,
  }) async {
    final uri = Uri.parse('${BASE_URL}/api/productionappservices/updatepatternrfd');
    final resp = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'PatternCode': patternCode,
        'RfdId': rfdId,
      }),
    );

    if (resp.statusCode == 200) {
      // Find the existing entry by patternCode
      final entry = patterns.entries.firstWhere(
            (e) => e.value.patternCode == patternCode,
        orElse: () => throw Exception('Local pattern not found'),
      );

      final oldPattern = entry.value;
      // Remove old key
      patterns.remove(entry.key);
      // Insert updated pattern under its new rfdId
      patterns[rfdId] = Pattern(
        id: oldPattern.id,
        supplierName: oldPattern.supplierName,
        patternCode: oldPattern.patternCode,
        patternName: oldPattern.patternName,
        toolLifeStartDate: oldPattern.toolLifeStartDate,
        invoiceNo: oldPattern.invoiceNo,
        invoiceDate: oldPattern.invoiceDate,
        numberOfParts: oldPattern.numberOfParts,
        partsProduced: oldPattern.partsProduced,
        remainingBalance: oldPattern.remainingBalance,
        signal: oldPattern.signal,
        lastPrdDate: oldPattern.lastPrdDate,
        assetName: oldPattern.assetName,
        rfdId: rfdId,
      );
    } else if (resp.statusCode == 404) {
      throw Exception('Pattern not found on server');
    } else {
      throw Exception('Failed to update RfdId (${resp.statusCode})');
    }
  }
}

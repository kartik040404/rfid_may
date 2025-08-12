//------------------------------------------------- PatternService --------------------------------------------------//
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/Pattern.dart';

//------------------------------------------------- Class Definition --------------------------------------------------//
class PatternService {
  //------------------------------------------------- Base URL --------------------------------------------------//
  static const _baseUrl = 'http://10.10.1.7:8301';

  //------------------------------------------------- Pattern Storage --------------------------------------------------//
  static Map<String, Pattern> patterns = {};
  static List<Pattern> allPatterns = [];

  //------------------------------------------------- Fetch Patterns --------------------------------------------------//
  static Future<void> fetchPatterns() async {
    final uri =
        Uri.parse('$_baseUrl/api/productionappservices/getpatterndetailslist');
    final resp = await http.get(uri);
    if (resp.statusCode == 200) {
      final List<dynamic> data = json.decode(resp.body);
      final fetched = data.map((e) => Pattern.fromJson(e)).toList();
      allPatterns = fetched;

      patterns = {
        for (final p in fetched)
          if (p.rfdId.isNotEmpty) p.rfdId: p,
      };
      print('Loaded ${patterns.length} patterns keyed by RFID');
      print('Loaded ${allPatterns.length} patterns in total');
    } else {
      throw Exception('Failed to load patterns (${resp.statusCode})');
    }
  }

  //------------------------------------------------- Get Pattern by Tag --------------------------------------------------//
  static Pattern? getByTag(String tag) => patterns[tag];

  //------------------------------------------------- Update RfdId --------------------------------------------------//
  static Future<void> updateRfd({
    required String patternCode,
    required String rfdId,
  }) async {
    final uri =
        Uri.parse('$_baseUrl/api/productionappservices/updatepatternrfd');
    final resp = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'PatternCode': patternCode,
        'RfdId': rfdId,
      }),
    );

    if (resp.statusCode == 200) {
      final entry = patterns.entries.firstWhere(
        (e) => e.value.patternCode == patternCode,
        orElse: () => throw Exception('Local pattern not found'),
      );

      final oldPattern = entry.value;
      patterns.remove(entry.key);
      patterns[rfdId] = Pattern(
        id: oldPattern.id,
        supplierName: oldPattern.supplierName,
        patternCode: oldPattern.patternCode,
        patternName: oldPattern.patternName,
        toolLifeStartDate: oldPattern.toolLifeStartDate,
        invoiceNo: oldPattern.invoiceNo,
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

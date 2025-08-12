//------------------ Pattern Model -------------//
import 'package:intl/intl.dart';

//------------------ Pattern Class -------------//
class Pattern {
  //------------------ Fields -------------//
  final int id;
  final String supplierName;
  final String patternCode;
  final String patternName;
  final DateTime toolLifeStartDate;
  final String invoiceNo;

  final double numberOfParts;
  final double partsProduced;
  final double remainingBalance;
  final String signal;
  final DateTime lastPrdDate;
  final String assetName;
  final String rfdId;

  //------------------ Constructor -------------//
  Pattern({
    required this.id,
    required this.supplierName,
    required this.patternCode,
    required this.patternName,
    required this.toolLifeStartDate,
    required this.invoiceNo,
    required this.numberOfParts,
    required this.partsProduced,
    required this.remainingBalance,
    required this.signal,
    required this.lastPrdDate,
    required this.assetName,
    required this.rfdId,
  });

  //------------------ Utility: Convert to double -------------//
  static double _toDouble(dynamic val) {
    if (val is num) return val.toDouble();
    if (val is String) return double.tryParse(val) ?? 0.0;
    return 0.0;
  }

  //------------------ Factory: From JSON -------------//
  factory Pattern.fromJson(Map<String, dynamic> json) {
    DateTime _parseDate(String? s) {
      print('Parsing date: $s');
      if (s == null || s.isEmpty) return DateTime.fromMillisecondsSinceEpoch(0);
      if (s.length == 8 && RegExp(r"^\d{8}$").hasMatch(s)) {
        print('Using yyyyMMdd format');
        return DateFormat('yyyyMMdd').parse(s);
      }
      try {
        print('Trying dd/MM/yyyy format');
        return DateFormat('dd/MM/yyyy').parse(s);
      } catch (e) {
        print('Failed parsing date $s: $e');
        return DateTime.fromMillisecondsSinceEpoch(0);
      }
    }

    return Pattern(
      id: json['id'] is int
          ? json['id'] as int
          : int.tryParse(json['id']?.toString() ?? '') ?? 0,
      supplierName: json['SupplierName'] as String? ?? '',
      patternCode: json['PatternCode']?.toString() ?? '',
      patternName: json['PatternName'] as String? ?? '',
      toolLifeStartDate: _parseDate(json['ToolLifeStartDate'] as String?),
      invoiceNo: json['InvoiceNo'] as String? ?? '',
      numberOfParts: _toDouble(json['NumberOfParts']),
      partsProduced: _toDouble(json['PartsProduced']),
      remainingBalance: _toDouble(json['RemainingBalance']),
      signal: json['Signal'] as String? ?? '',
      lastPrdDate: _parseDate(json['LastPrdDate'] as String?),
      assetName: json['AssetName'] as String? ?? '',
      rfdId: json['RfdId'] as String? ?? '',
    );
  }

  //------------------ Convert to JSON -------------//
  Map<String, dynamic> toJson() => {
        'id': id,
        'SupplierName': supplierName,
        'PatternCode': patternCode,
        'PatternName': patternName,
        'ToolLifeStartDate': DateFormat('dd/MM/yyyy').format(toolLifeStartDate),
        'InvoiceNo': invoiceNo,
        'NumberOfParts': numberOfParts,
        'PartsProduced': partsProduced,
        'RemainingBalance': remainingBalance,
        'Signal': signal,
        'LastPrdDate': DateFormat('dd/MM/yyyy').format(lastPrdDate),
        'AssetName': assetName,
        'RfdId': rfdId,
      };
}

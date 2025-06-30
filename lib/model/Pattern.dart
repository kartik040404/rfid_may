// "SupplierName": "S J IRON AND STEELS PVT LTD",
//
// "PatternCode": 1010602615,
//
// "PatternName": "PATTERN FOR 3L BED PLATE 5706 0110 3702/398534010000 (S)",
//
// "ToolLifeStartDate": "01/02/2023",
//
// "InvoiceNo": "",
//
// "InvoiceDate": "",
//
// "NumberOfParts": 70000.000,
//
// "PartsProduced": 60551.000,
//
// "RemainingBalance": 9449.000,
//
// "Signal": "RED",
//
// "LastPrdDate": "07/06/2025",
//
// "AssetName": ""
// "RfdId": ""



import 'package:intl/intl.dart';

class Pattern {
  final int id;
  final String supplierName;
  final String patternCode;
  final String patternName;
  final DateTime toolLifeStartDate;
  final String invoiceNo;
  final DateTime invoiceDate;
  final double numberOfParts;
  final double partsProduced;
  final double remainingBalance;
  final String signal;
  final DateTime lastPrdDate;
  final String assetName;
  final String rfdId;

  Pattern({
    required this.id,
    required this.supplierName,
    required this.patternCode,
    required this.patternName,
    required this.toolLifeStartDate,
    required this.invoiceNo,
    required this.invoiceDate,
    required this.numberOfParts,
    required this.partsProduced,
    required this.remainingBalance,
    required this.signal,
    required this.lastPrdDate,
    required this.assetName,
    required this.rfdId,
  });

  static double _toDouble(dynamic val) {
    if (val is num) return val.toDouble();
    if (val is String) return double.tryParse(val) ?? 0.0;
    return 0.0;
  }

  factory Pattern.fromJson(Map<String, dynamic> json) {
    // helper to parse "dd/MM/yyyy" dates, falling back on epoch if blank
    DateTime _parseDate(String? s) {
      if (s == null || s.isEmpty) return DateTime.fromMillisecondsSinceEpoch(0);
      return DateFormat('dd/MM/yyyy').parse(s);
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
      invoiceDate: _parseDate(json['InvoiceDate'] as String?),
      numberOfParts: _toDouble(json['NumberOfParts']),
      partsProduced: _toDouble(json['PartsProduced']),
      remainingBalance: _toDouble(json['RemainingBalance']),
      signal: json['Signal'] as String? ?? '',
      lastPrdDate: _parseDate(json['LastPrdDate'] as String?),
      assetName: json['AssetName'] as String? ?? '',
      rfdId: json['RfdId'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'SupplierName': supplierName,
    'PatternCode': patternCode,
    'PatternName': patternName,
    'ToolLifeStartDate': DateFormat('dd/MM/yyyy').format(toolLifeStartDate),
    'InvoiceNo': invoiceNo,
    'InvoiceDate': DateFormat('dd/MM/yyyy').format(invoiceDate),
    'NumberOfParts': numberOfParts,
    'PartsProduced': partsProduced,
    'RemainingBalance': remainingBalance,
    'Signal': signal,
    'LastPrdDate': DateFormat('dd/MM/yyyy').format(lastPrdDate),
    'AssetName': assetName,
    'RfdId': rfdId,
  };
}

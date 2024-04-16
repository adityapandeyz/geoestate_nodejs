// ignore_for_file: public_member_api_docs, sort_constructors_first
class Dataset {
  String refNo;
  String bankName;
  String branchName;
  String partyName;
  String colonyName;
  String cityVillageName;
  double latitude;
  double longitude;
  int marketRate;
  String unit;
  DateTime createdAt;
  String remarks;
  String colorMark;
  DateTime dateOfVisit;
  int id;
  String entryBy;

  Dataset({
    required this.refNo,
    required this.bankName,
    required this.branchName,
    required this.partyName,
    required this.colonyName,
    required this.cityVillageName,
    required this.latitude,
    required this.longitude,
    required this.marketRate,
    required this.unit,
    required this.createdAt,
    required this.remarks,
    required this.colorMark,
    required this.dateOfVisit,
    required this.id,
    required this.entryBy,
  });

  Dataset copyWith(
    Map<String, dynamic> updates, {
    String? refNo,
    String? bankName,
    String? branchName,
    String? partyName,
    String? colonyName,
    String? cityVillageName,
    double? latitude,
    double? longitude,
    int? marketRate,
    String? unit,
    DateTime? createdAt,
    String? remarks,
    int? id,
    DateTime? dateOfVisit,
    String? colorMark,
    String? entryBy,
  }) {
    return Dataset(
      refNo: refNo ?? this.refNo,
      bankName: bankName ?? this.bankName,
      branchName: branchName ?? this.branchName,
      partyName: partyName ?? this.partyName,
      colonyName: colonyName ?? this.colonyName,
      cityVillageName: cityVillageName ?? this.cityVillageName,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      marketRate: marketRate ?? this.marketRate,
      unit: unit ?? this.unit,
      createdAt: createdAt ?? this.createdAt,
      remarks: remarks ?? this.remarks,
      id: id ?? this.id,
      dateOfVisit: dateOfVisit ?? this.dateOfVisit,
      colorMark: colorMark ?? this.colorMark,
      entryBy: entryBy ?? this.entryBy,
    );
  }

  factory Dataset.fromJson(Map<String, dynamic> map) {
    return Dataset(
      refNo: map['refNo'] ?? '',
      bankName: map['bankName'] ?? '',
      branchName: map['branchName'] ?? '',
      partyName: map['partyName'] ?? '',
      colonyName: map['colonyName'] ?? '',
      cityVillageName: map['cityVillageName'] ?? '',
      latitude: map['latitude'] ?? 0.0,
      longitude: map['longitude'] ?? 0.0,
      marketRate: map['marketRate'] ?? 0,
      unit: map['unit'] ?? '',
      createdAt: DateTime.tryParse(map['createdAt'] ?? '') ?? DateTime.now(),
      remarks: map['remarks'] ?? '',
      id: map['id'],
      dateOfVisit:
          DateTime.tryParse(map['dateOfVisit'] ?? '') ?? DateTime.now(),
      colorMark: map['colorMark'] ?? '',
      entryBy: map['entryBy'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'refNo': refNo,
      'bankName': bankName,
      'branchName': branchName,
      'partyName': partyName,
      'colonyName': colonyName,
      'cityVillageName': cityVillageName,
      'latitude': latitude,
      'longitude': longitude,
      'marketRate': marketRate,
      'createdAt': createdAt.toIso8601String(), // Convert to ISO string
      'remarks': remarks,
      'id': id,
      'dateOfVisit': dateOfVisit.toIso8601String(), // Convert to ISO string
      'colorMark': colorMark,
      'entryBy': entryBy,
    };
  }
}

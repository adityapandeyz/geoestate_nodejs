class Bank {
  final int id;
  final String bankName;
  final String branchName;
  final String ifscCode;

  Bank({
    required this.id,
    required this.bankName,
    required this.branchName,
    required this.ifscCode,
  });

  factory Bank.fromJson(Map<String, dynamic> json) {
    return Bank(
      id: json['id'],
      bankName: json['bankName'],
      branchName: json['branchName'],
      ifscCode: json['ifscCode'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'bankName': bankName,
      'branchName': branchName,
      'ifscCode': ifscCode,
    };
  }
}

class BankModel {
  final String? uid;
  final String bankName;
  final String id;
  final String accountNumber;
  bool? paymentStatus;
  num? amount;
  String? vendorID;
  String? account;
  final DateTime timeCreated;

  BankModel(
      {required this.id,
      this.uid,
      this.vendorID,
      required this.timeCreated,
      required this.bankName,
      this.paymentStatus,
      this.amount,
      this.account,
      required this.accountNumber});
  Map<String, dynamic> toMap() {
    return {
      'account': account,
      'id': id,
      'paymentStatus': paymentStatus,
      'accountNumber': accountNumber,
      'vendorID': vendorID,
      'bankName': bankName,
      'amount': amount,
      'timeCreated': timeCreated
    };
  }

  BankModel.fromMap(data, this.uid)
      : bankName = data['bankName'],
        timeCreated = data['timeCreated'].toDate(),
        amount = data['amount'],
        paymentStatus = data['paymentStatus'],
        account = data['account'],
        vendorID = data['vendorID'] ?? '',
        id = data['id'],
        accountNumber = data['accountNumber'];
  // category = data['category'],
}

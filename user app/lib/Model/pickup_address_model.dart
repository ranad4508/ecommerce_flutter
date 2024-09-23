class PickupAddressModel {
  final String address;
  final String storename;
  final String phonenumber;
  final String uid;

  PickupAddressModel(
      {required this.address,
      required this.uid,
      required this.storename,
      required this.phonenumber});

  PickupAddressModel.fromMap(Map<String, dynamic> data, this.uid)
      : address = data['address'],
        phonenumber = data['phonenumber'],
        storename = data['storename'];

  Map<String, dynamic> toMap() {
    return {
      'address': address,
      'storename': storename,
      'phonenumber': phonenumber
    };
  }
}

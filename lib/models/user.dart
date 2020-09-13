class UserModel {
  final String name;
  final String uid;
  final int phone;
  final String address;

  UserModel({this.name, this.uid, this.phone, this.address});

  factory UserModel.fromJSON(Map<String, dynamic> json) {
    return UserModel(
        name: json['name'],
        uid: json['uid'],
        phone: json['phone'],
        address: json['address']);
  }

  Map toJson() =>
      {'name': name, 'uid': uid, 'phone': phone, 'address': address};
}

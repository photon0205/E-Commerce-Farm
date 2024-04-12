import 'package:cloud_firestore/cloud_firestore.dart';

class Seller {
  String? sellerId;
  final String aadhar;
  final String address;
  final String email;
  final String mobileNo;
  final String sellerName;
  final String shopName;
  final String password;
  final List<dynamic> productImg;

  Seller(
    this.productImg, {
    required this.aadhar,
    required this.address,
    required this.email,
    required this.mobileNo,
    required this.sellerName,
    required this.shopName,
    required this.password,
  });

  Seller.fromDocumentSnapshot(DocumentSnapshot<Map<String, dynamic>> doc)
      : aadhar = doc.data()!['aadhar'],
        email = doc.data()!['email'],
        mobileNo = doc.data()!['mobileNumber'],
        sellerName = doc.data()!['name'],
        shopName = doc.data()!['shopName'],
        address = doc.data()!['address'],
        password = doc.data()!['password'],
        productImg =
            doc.data()!['productImg'].map((e) => e.toString()).toList();

  Map<String, dynamic> toMap() {
    return {
      'aadhar': aadhar,
      'address': address,
      'email': email,
      'mobileNumber': mobileNo,
      'name': sellerName,
      'password': password,
      'shopName': shopName,
    };
  }
}

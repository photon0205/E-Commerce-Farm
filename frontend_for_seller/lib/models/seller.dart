class Seller {
  final String aadhar;
  final String address;
  final String email;
  final String mobileNo;
  final String sellerName;
  final String shopName;
  final String password;
  final List<String> subCatList;
  List<String>? category;

  Seller( {
    required this.aadhar,
    required this.address,
    required this.email,
    required this.mobileNo,
    required this.sellerName,
    required this.shopName,
    required this.password,
    required this.subCatList,
    this.category
  });

  Map<String, dynamic> toMap() {
    return {
      'aadhar': aadhar,
      'address': address,
      'email': email,
      'mobileNumber': mobileNo,
      'name': sellerName,
      'password': password,
      'shopName': shopName,
      'services': subCatList,
    };
  }
}

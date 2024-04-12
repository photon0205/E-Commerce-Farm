import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:geolocator/geolocator.dart';
import '../models/product.dart';
import '../models/seller.dart';
import 'local_storage.dart';

class DatabaseService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  addSellerData(Seller sellerData, {String? tagLine}) async {
    User? user = FirebaseAuth.instance.currentUser;
    await _db.collection("Sellers").doc(user!.uid).set(sellerData.toMap());
    String name = sellerData.shopName;
    List<String> searchField = [];
    String temp = "";
    name = name.toLowerCase();
    temp = "";
    for (int i = 0; i < name.length; i++) {
      temp = temp + name[i];
      searchField.add(temp);
    }
    localStorage.username = sellerData.sellerName;
    localStorage.services = sellerData.subCatList;
    Position postion = await Geolocator.getCurrentPosition();
    String s = "${postion.latitude},${postion.longitude}";
    localStorage.location = s;
    if (tagLine != null) {
      await _db.collection("Sellers").doc(user.uid).update(
          {"tagLine": tagLine, "searchField": searchField, "location": s});
    } else {
      await _db
          .collection("Sellers")
          .doc(user.uid)
          .update({"searchField": searchField, "location": s});
    }
  }

  addProductData(Product prodData) async {
    User? user = FirebaseAuth.instance.currentUser;
    DocumentReference prod =
        await _db.collection("Products").add(prodData.toMap());
    String name = prodData.name;
    List<String> searchField = [];
    String temp = "";
    name = name.toLowerCase();
    for (int i = 0; i < name.length; i++) {
      temp = temp + name[i];
      searchField.add(temp);
    }
    
    await _db.collection("Sellers").doc(user!.uid).update({
      'productImg' : FieldValue.arrayUnion([prodData.imgUrls[0]]),
    });
    String s = localStorage.location;
    await prod.update({
      'uid': user.uid,
      'docId': prod.id,
      'searchField': searchField,
      "location": s,
      "rating": 0,
      "ordersRated": 0
    });
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> pendingOrders() {
    User? user = FirebaseAuth.instance.currentUser;
    Stream<QuerySnapshot<Map<String, dynamic>>> pending = _db
        .collection("Orders")
        .where("sellerId", isEqualTo: user!.uid)
        .where("status", isEqualTo: "requested")
        .snapshots();
    return pending;
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> confirmedOrders() {
    User? user = FirebaseAuth.instance.currentUser;
    Stream<QuerySnapshot<Map<String, dynamic>>> pending = _db
        .collection("Orders")
        .where("sellerId", isEqualTo: user!.uid)
        .where("status", isEqualTo: "confirmed")
        .snapshots();
    return pending;
  }

  confirmOrder(String orderID) async {
    await _db.collection("Orders").doc(orderID).update({"status": "confirmed"});
  }

  rejectOrder(String orderID) async {
    await _db.collection("Orders").doc(orderID).update({"status": "rejected"});
  }

  deleteProduct(String id) async {
    await _db.collection("Products").doc(id).delete();
  }

  updateProduct(Product product) async {
    await _db.collection("Products").doc(product.id).update(product.toMap());
  }

  Future<Seller> retrieveSellerData() async {
    User? user = FirebaseAuth.instance.currentUser;
    DocumentSnapshot<Map<String, dynamic>> snapshot =
        await _db.collection("Sellers").doc(user!.uid).get();
    Map<String, dynamic>? data = snapshot.data();
    List<dynamic> temp = data!['services'];
    QuerySnapshot<Map<String, dynamic>> querySnapshot = await _db
        .collection("Services")
        .where("subCategories", arrayContainsAny: temp)
        .get();
    List<String>? category =
        querySnapshot.docs.map((e) => e.data()["title"].toString()).toList();
    List<String> subCat = temp.map((e) => e.toString()).toList();
    Seller seller = Seller(
        sellerName: data['name'],
        shopName: data['shopName'],
        address: data['address'],
        aadhar: data['aadhar'],
        mobileNo: data['mobileNumber'],
        email: data['email'],
        password: data['password'],
        subCatList: subCat,
        category: category);
    localStorage.services = subCat;
    localStorage.username = seller.sellerName;

    return seller;
  }

  Future<List<Product>> getMyProducts() async {
    List<Product> listOfProd = [];
    User? user = FirebaseAuth.instance.currentUser;
    String userid = user!.uid;
    QuerySnapshot<Map<String, dynamic>> snapshot =
        await _db.collection('Products').where('uid', isEqualTo: userid).get();
    for (var doc in snapshot.docs) {
      Map<String, dynamic> data = doc.data();
      List<dynamic> list = data['imgUrl'];
      List<String> finalList = list.map((e) => e.toString()).toList();
      listOfProd.add(Product(
        name: data['name'],
        description: data['description'],
        type: data['type'],
        price: data['price'],
        address: data['address'],
        category: data['category'],
        seller: data['seller'],
        imgUrls: finalList,
        open: data['open'],
        id: doc.id,
      ));
    }
    // print(listOfProd);
    return listOfProd;
  }

  Future<String> retrieveName() async {
    User? user = FirebaseAuth.instance.currentUser;
    DocumentSnapshot<Map<String, dynamic>> snapshot =
        await _db.collection("Sellers").doc(user!.uid).get();
    return snapshot.data()!["name"];
  }

  Future<List<String>> retrieveCategories() async {
    QuerySnapshot<Map<String, dynamic>> snapshot =
        await _db.collection('Services').get();
    List<String> list = snapshot.docs
        .map((qSnapshot) => qSnapshot.data()['title'].toString())
        .toList();
    return list;
  }

  Future<List<String>> retrieveSubCategories(List<String> catList) async {
    QuerySnapshot<Map<String, dynamic>> snapshot =
        await _db.collection('Services').where('title', whereIn: catList).get();
    List<String> list = [];
    for (var qSnapshot in snapshot.docs) {
      List<dynamic> temp = qSnapshot.data()['subCategories'];
      List<String> subCategories = temp.map((e) => e.toString()).toList();
      list = [...list, ...subCategories];
    }
    return list;
  }
}

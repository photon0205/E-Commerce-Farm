import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:frontend/models/category.dart';
import 'package:frontend/models/product.dart';
import 'package:frontend/models/user.dart';
import 'package:frontend/services/local_storage.dart';

import '../models/seller.dart';

class DatabaseService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  User? user = FirebaseAuth.instance.currentUser;
  addUserData(UserI userData) async {
    await _db.collection("Users").doc(userData.id).set(userData.toMap());
    await _db.collection("Users").doc(userData.id).update({
      "following": [],
      'Dob': "",
      "Gender": "",
      "MobileNumber": "",
    });
  }

  Future<Map<String, dynamic>> retrieveUserData() async {
    DocumentSnapshot<Map<String, dynamic>> snapshot =
        await _db.collection("Users").doc(user!.uid).get();
    return snapshot.data()!;
  }

  Future<List<Seller>> retrieveAllSellers() async {
    QuerySnapshot<Map<String, dynamic>> snapshot =
        await _db.collection("Sellers").get();
    return snapshot.docs.map((DocumentSnapshot<Map<String, dynamic>> snap) {
      Seller s = Seller.fromDocumentSnapshot(snap);
      s.sellerId = snap.id;
      return s;
    }).toList();
  }

  Future<void> addFollowing(String sellerId) async {
    await _db.collection("Users").doc(user!.uid).update({
      "following": [...localStorage.following, sellerId],
    });
    localStorage.following = [...localStorage.following, sellerId];
  }

  Future<void> removeFollowing(String sellerId) async {
    List<String> list = localStorage.following;
    list.remove(sellerId);
    localStorage.following = list;
    await _db.collection("Users").doc(user!.uid).update({
      "following": [...list],
    });
  }

  Future<List<Seller>> retrieveFollowedSellers() async {
    DocumentSnapshot<Map<String, dynamic>> userSnap =
        await _db.collection('Users').doc(user!.uid).get();
    List<dynamic> list = userSnap.data()!['following'];
    if (list.isEmpty) {
      return [];
    }
    QuerySnapshot<Map<String, dynamic>> snapshot = await _db
        .collection("Sellers")
        .where(FieldPath.documentId, whereIn: list)
        .get();
    return snapshot.docs.map((DocumentSnapshot<Map<String, dynamic>> snap) {
      Seller s = Seller.fromDocumentSnapshot(snap);
      s.sellerId = snap.id;
      return s;
    }).toList();
  }

  Future<List<Seller>> searchResultSellers(String search) async {
    search = search.toLowerCase();
    QuerySnapshot<Map<String, dynamic>> snapshot = await _db
        .collection("Sellers")
        .where('searchField', arrayContains: search)
        .get();
    return snapshot.docs
        .map((DocumentSnapshot<Map<String, dynamic>> snap) =>
            Seller.fromDocumentSnapshot(snap))
        .toList();
  }

  Future<List<ProductModel?>> retrieveFilteredProductsData(
      String subCategory) async {
    QuerySnapshot<Map<String, dynamic>> snapshot = await _db
        .collection("Products")
        .where('category', isEqualTo: subCategory)
        .get();
    return snapshot.docs
        .map((DocumentSnapshot<Map<String, dynamic>> snap) =>
            ProductModel.fromDocumentSnapshot(snap))
        .toList();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> orderStatus() {
    Stream<QuerySnapshot<Map<String, dynamic>>> ordersStream = _db
        .collection("Orders")
        .where("userId", isEqualTo: user!.uid)
        .snapshots();
    return ordersStream;
  }

  Future<void> requestOrder(ProductModel productModel) async {
    DocumentReference<Map<String, dynamic>> order =
        await _db.collection("Orders").add({
      "productName": productModel.name,
      "productId": productModel.docId,
      "userName": localStorage.username,
      "userContact": localStorage.number,
      "sellerId": productModel.sellerId,
      "sellerName": productModel.seller,
      "prodPrice": productModel.price.toString(),
      "prodCat": productModel.category,
      "sellerLocation": productModel.location,
      "userId": user!.uid,
      "status": "requested",
      "imageUrl": productModel.urls[0],
      "rating": 0,
    });
    print("hello");
    await order.update({"orderId": order.id});
    print("bye");
  }

  Future<List<ProductModel?>> retrieveSearchProducts(
    String search, {
    List<String>? filterCat,
    String? priceFrom,
    String? priceTo,
    String? sortByPrice,
    String? sortByRating,
  }) async {
    search = search.toLowerCase();
    CollectionReference<Map<String, dynamic>> prodCollection =
        _db.collection("Products");
    QuerySnapshot<Map<String, dynamic>> snapshot;
    Query<Map<String, dynamic>> query =
        prodCollection.where('searchField', arrayContains: search);
    if (filterCat != null) {
      query = query.where('category', whereIn: filterCat);
    }
    if (priceFrom != null) {
      query.where("price", isGreaterThanOrEqualTo: priceFrom);
    }
    if (priceTo != null) {
      query.where("price", isLessThanOrEqualTo: priceTo);
    }
    if (sortByPrice != null) {
      if (sortByPrice == 'Low to High') {
        query = query.orderBy('price', descending: true);
      }
      if (sortByPrice == 'High to Low') {
        query = query.orderBy('price');
      }
    }
    if (sortByRating != null) {
      if (sortByRating == 'High to Low') {
        query = query.orderBy('rating', descending: true);
      }
      if (sortByRating == 'Low to High') {
        query = query.orderBy('rating');
      }
    }
    snapshot = await query.get();
    return snapshot.docs
        .map((DocumentSnapshot<Map<String, dynamic>> snap) =>
            ProductModel.fromDocumentSnapshot(snap))
        .toList();
  }

  Future<List<String>?> retrieveWishlist() async {
    User? user = FirebaseAuth.instance.currentUser;

    print('object');
    DocumentSnapshot<Map<String, dynamic>> documentSnapshot =
        await _db.collection('Users').doc(user!.uid).get();
    Map<String, dynamic>? data = documentSnapshot.data();
    List<dynamic>? tempList = data!['Wishlist'];
    List<String>? finalList = tempList!.map((e) => e.toString()).toList();
    localStorage.username = await retrieveUserName(user);
    print(localStorage.username);
    return finalList;
  }

  Future<void> addToWishlist(String docId, String cat) async {
    List<String> finalList = localStorage.wishList;
    List<String> finalListCat = localStorage.wishListCat;
    finalListCat.add(cat);
    finalListCat = finalListCat.toSet().toList();
    finalList.add(docId);
    localStorage.wishListCat = finalListCat;
    localStorage.wishList = finalList;
    await _db
        .collection('Users')
        .doc(user!.uid)
        .update({'Wishlist': finalList, 'Wishlist_Categories': finalListCat});
  }

  Future<void> updateUser(
      String name, String gender, String dob, String number) async {
    await _db.collection("Users").doc(user!.uid).update({
      'name': name,
      'MobileNumber': number,
      'Gender': gender,
      'Dob': dob,
    });
    localStorage.dob = dob;
    localStorage.username = name;
    localStorage.gender = gender;
    localStorage.number = number;
  }

  Future<void> removeFromWishlist(String docId) async {
    List<String> finalList = localStorage.wishList;
    finalList.remove(docId);
    localStorage.wishList = finalList;
    await _db
        .collection('Users')
        .doc(user!.uid)
        .update({'Wishlist': finalList});
  }

  Future<String> retrieveUserName(User user) async {
    DocumentSnapshot<Map<String, dynamic>> snapshot =
        await _db.collection("Users").doc(user.uid).get();
    return snapshot.data()!["name"];
  }

  Future<List<Category>> retrieveCategories() async {
    List<Category> catList = [];
    QuerySnapshot<Map<String, dynamic>> querySnapshot =
        await _db.collection('Services').get();

    querySnapshot.docs.forEach((QueryDocumentSnapshot doc) {
      List<dynamic> subCatList = doc.get('subCategories');
      List<String> finalList = subCatList.map((e) => e.toString()).toList();
      catList.add(Category(
        headline: doc.get('headline'),
        title: doc.get('title'),
        description: doc.get('description'),
        url: doc.get('url'),
        subCategories: finalList,
      ));
    });

    return catList;
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> retrieveOrders() {
    Stream<QuerySnapshot<Map<String, dynamic>>> snapshot = _db
        .collection('Orders')
        .where('userId', isEqualTo: user!.uid)
        .snapshots();
    return snapshot;
  }

  Future<void> orderComplete(String orderId) async {
    await _db.collection('Orders').doc(orderId).update({'status': 'complete'});
  }

  Future<void> rateProduct(String orderId, int rating, String productId) async {
    await _db
        .collection('Orders')
        .doc(orderId)
        .update({'rating': rating, "status": 'rated'});
    DocumentReference<Map<String, dynamic>> productRef =
        _db.collection('Products').doc(productId);
    num initialRating = 0;
    int ordersRated = 0;
    await productRef.get().then((value) {
      initialRating = value.data()!['rating'];
      ordersRated = value.data()!['ordersRated'];
    });
    double finalRating =
        ((initialRating * ordersRated + rating) / (ordersRated + 1));
    await productRef
        .update({'rating': finalRating, 'ordersRated': ordersRated + 1});
  }
}

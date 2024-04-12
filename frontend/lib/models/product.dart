import 'package:cloud_firestore/cloud_firestore.dart';

class ProductModel {
  final String name;
  final String description;
  final String type;
  final String category;
  final int price;
  final String address;
  final String seller;
  final List<dynamic> urls;
  final String docId;
  final bool open;
  final String location;
  String? sellerId;
  final num rating;

  ProductModel.fromDocumentSnapshot(DocumentSnapshot<Map<String, dynamic>> doc)
      : name = doc.data()!['name'],
        description = doc.data()!['description'],
        type = doc.data()!['type'],
        category = doc.data()!['category'],
        price = int.parse(doc.data()!['price']),
        address = doc.data()!['address'],
        seller = doc.data()!['seller'],
        urls = doc.data()!['imgUrl'].map((e) => e.toString()).toList(),
        docId = doc.data()!['docId'],
        open = doc.data()!['open'],
        location = doc.data()!['location'],
        sellerId = doc.data()!['uid'],
        rating = doc.data()!['rating'];

  ProductModel(
      {required this.open,
      required this.name,
      required this.description,
      required this.type,
      required this.category,
      required this.price,
      required this.address,
      required this.seller,
      required this.docId,
      required this.urls,
      required this.location,
      required this.rating, 
      this.sellerId});
}

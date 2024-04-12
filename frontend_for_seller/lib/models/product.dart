class Product {
  final String name;
  final String description;
  final String type;
  final String price;
  final String address;
  final String seller;
  final String category;
  final String? id;
  final List<String> imgUrls;
  final bool open;

  Product( 
      {required this.name,
      required this.description,
      required this.type,
      required this.price,
      required this.address,
      required this.category, 
      required this.seller,
      required this.imgUrls,
      required this.open,
       this.id,
      });


  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      'type': type,
      'price': price,
      'address': address,
      'category': category,
      'seller': seller,
      'imgUrl': imgUrls,
      'open': open,
    };
  }
}
import 'package:frontend/models/category.dart';
import 'package:frontend/models/product.dart';
import 'package:frontend/models/user.dart';

import 'database_services.dart';

class DatabaseRepositoryImpl implements DatabaseRepository {
  DatabaseService service = DatabaseService();

  @override
  Future<void> addUserData(UserI user) {
    return service.addUserData(user);
  }

  @override
  Future<Map<String, dynamic>> retrieveUserData() {
    return service.retrieveUserData();
  }

  @override
  Future<List<Category>> retreiveCategories() {
    return service.retrieveCategories();
  }

  @override
  Future<List<ProductModel?>> retreiveFilteredProducts(String subCat) {
    return service.retrieveFilteredProductsData(subCat);
  }

  @override
  Future<List<String>?> retreiveWishlist() {
    return service.retrieveWishlist();
  }

  @override
  Future<void> addToWishlist(String docId, String cat) {
    return service.addToWishlist(docId, cat);
  }

  @override
  Future<void> removeFromWishlist(String docId) {
    return service.removeFromWishlist(docId);
  }
}

abstract class DatabaseRepository {
  Future<void> addUserData(UserI user);
  Future<void> addToWishlist(String docId, String cat);
  Future<void> removeFromWishlist(String docId);
  Future<Map<String, dynamic>> retrieveUserData();
  Future<List<Category>> retreiveCategories();

  Future<List<String>?> retreiveWishlist();
  Future<List<ProductModel?>> retreiveFilteredProducts(String subCat);
}

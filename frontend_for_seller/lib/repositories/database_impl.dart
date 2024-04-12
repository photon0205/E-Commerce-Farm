
import '../models/product.dart';
import '../models/seller.dart';
import 'database_repository.dart';

class DatabaseRepositoryImpl implements DatabaseRepository {
  DatabaseService service = DatabaseService();

  @override
  Future<void> addSellerData(Seller seller,{String? tagline} ) {
    return service.addSellerData(seller,tagLine:tagline!);
  }

  @override
  Future<Seller> getSellerData() async {
    return service.retrieveSellerData();
  }

  @override
  Future<void> addProductData(Product data) async {
    return service.addProductData(data);
  }

  @override
  Future<List<Product>> getMyProdList() {
    return service.getMyProducts();
  }
}

abstract class DatabaseRepository {
  Future<void> addSellerData(Seller seller,{String? tagline});
  Future<Seller> getSellerData();
  Future<List<Product>> getMyProdList();
  Future<void> addProductData(Product data);
}

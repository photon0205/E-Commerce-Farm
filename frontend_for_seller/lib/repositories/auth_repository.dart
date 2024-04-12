import 'package:firebase_auth/firebase_auth.dart';
import 'package:frontend_for_seller/repositories/database_repository.dart';
import 'package:frontend_for_seller/repositories/local_storage.dart';

import '../models/seller.dart';

class AuthRepository {
  final _firebaseAuth = FirebaseAuth.instance;

  Future<void> signUp(
      {required String name,
      required String shopName,
      required String email,
      required String aadhar,
      required String address,
      required String mobileNo,
      required String password,
      required List<String> services}) async {
    try {
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password)
          .then((value) async {
        localStorage.username = name;
        await DatabaseService().addSellerData(Seller(
          email: email,
          aadhar: aadhar,
          address: address,
          mobileNo: mobileNo,
          password: password,
          sellerName: name,
          shopName: shopName,
          subCatList: services,
        ));
      });
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        throw Exception('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        throw Exception('The account already exists for that email.');
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        throw Exception('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        throw Exception('Wrong password provided for that user.');
      }
    }
  }

  Future<void> signOut() async {
    try {
      await _firebaseAuth.signOut();
    } catch (e) {
      throw Exception(e);
    }
  }
}

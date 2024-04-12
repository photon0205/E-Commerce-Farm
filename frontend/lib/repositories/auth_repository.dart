import 'package:firebase_auth/firebase_auth.dart';
import 'package:frontend/services/database_services.dart';
import '../services/local_storage.dart';

import '../services/database_impl.dart';
import '../models/user.dart';

class AuthRepository {
  final _firebaseAuth = FirebaseAuth.instance;

  Future<void> signUp(
      {required String name,
      required String email,
      required String password}) async {
    try {
      UserCredential user = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      User? userData = _firebaseAuth.currentUser;

      await DatabaseRepositoryImpl().addUserData(UserI(
        id: userData!.uid,
        email: email,
        name: name,
      ));
      // List<String>? s = await DatabaseRepositoryImpl().retreiveWishlist();
      // localStorage.wishList = s!;
      localStorage.username = name;
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
      User? userData = _firebaseAuth.currentUser;
      Map<String, dynamic> user = await DatabaseService().retrieveUserData();
      localStorage.username = user['name'];
      List<dynamic> temp = user['following'];
      localStorage.following = temp.map((e) => e.toString()).toList();
      localStorage.dob = user['Dob'];
      localStorage.gender = user['Gender'];
      localStorage.number = user['Mobile'];
      List<String>? s = await DatabaseRepositoryImpl().retreiveWishlist();
      localStorage.wishList = s!;
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

//   Future<void> signInWithGoogle() async {
//     try {
//       final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

//       final GoogleSignInAuthentication? googleAuth =
//           await googleUser?.authentication;

//       final credential = GoogleAuthProvider.credential(
//         accessToken: googleAuth?.accessToken,
//         idToken: googleAuth?.idToken,
//       );

//       await FirebaseAuth.instance.signInWithCredential(credential);
//     } catch (e) {
//       throw Exception(e.toString());
//     }
// }

}

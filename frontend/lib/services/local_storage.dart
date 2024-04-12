import 'package:shared_preferences/shared_preferences.dart';

class LocalStorage {
  static SharedPreferences? _sharedPrefs;

  init() async {
    _sharedPrefs ??= await SharedPreferences.getInstance();
  }

  String get username => _sharedPrefs?.getString(keyUsername) ?? "";
  String get gender => _sharedPrefs?.getString(keyGender) ?? "";
  String get number => _sharedPrefs?.getString(keyNumber) ?? "";
  String get dob => _sharedPrefs?.getString(keyDob) ?? "";

  set username(String value) {
    _sharedPrefs?.setString(keyUsername, value);
  }

  set gender(String value) {
    _sharedPrefs?.setString(keyGender, value);
  }

  set number(String value) {
    _sharedPrefs?.setString(keyNumber, value);
  }

  set dob(String value) {
    _sharedPrefs?.setString(keyDob, value);
  }

  String get id => _sharedPrefs?.getString(keyId) ?? "";

  List<String> get wishList => _sharedPrefs?.getStringList(keyWishlist) ?? [];

  List<String> get wishListCat =>
      _sharedPrefs?.getStringList(keyWishlistCat) ?? [];

  set id(String value) {
    _sharedPrefs?.setString(keyId, value);
  }

  set wishList(List<String> value) {
    _sharedPrefs?.setStringList(keyWishlist, value);
  }

  set wishListCat(List<String> value) {
    _sharedPrefs?.setStringList(keyWishlistCat, value);
  }

  set following(List<String> value) {
    _sharedPrefs?.setStringList(keyFollowing, value);
  }

  List<String> get following => _sharedPrefs?.getStringList(keyFollowing) ?? [];
}

final localStorage = LocalStorage();
// constants/strings.dart
const String keyUsername = "name";
const String keyId = "id";
const String keyWishlist = "wishList";
const String keyWishlistCat = "wishListCat";
const String keyNumber = "number";
const String keyDob = "Dob";
const String keyGender = "gender";
const String keyFollowing = "Following_";

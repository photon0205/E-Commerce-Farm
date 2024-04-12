import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:frontend/services/local_storage.dart';

import 'app/view/app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await localStorage.init();
  await Firebase.initializeApp();
  runApp(const App());
}

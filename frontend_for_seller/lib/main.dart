import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend_for_seller/newProduct/bloc/new_product_bloc.dart';
import 'package:frontend_for_seller/profile/bloc/profile_bloc.dart';
import 'package:frontend_for_seller/signup/bloc/sign_up_bloc.dart';

import 'auth/auth_bloc.dart';
import 'components/product/bloc/product_bloc.dart';
import 'home/bloc/home_bloc.dart';
import 'home/home_page.dart';
import 'login/bloc/login_bloc.dart';
import 'login/login_page.dart';
import 'profile/pages/profileEdit/bloc/profile_edit_bloc.dart';
import 'repositories/auth_repository.dart';
import 'repositories/local_storage.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await localStorage.init();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return RepositoryProvider(
      create: (context) => AuthRepository(),
      child: MultiBlocProvider(
        providers: [
          BlocProvider<AuthBloc>(
            create: (context) => AuthBloc(
              authRepository: RepositoryProvider.of<AuthRepository>(context),
            ),
          ),
          BlocProvider<LoginBloc>(create: (context) => LoginBloc()),
          BlocProvider<SignUpBloc>(create: (context) => SignUpBloc()),
          BlocProvider<HomeBloc>(create: (context) => HomeBloc()),
          BlocProvider<NewProductBloc>(create: (context) => NewProductBloc()),
          BlocProvider<ProductBloc>(create: (context) => ProductBloc()),
          BlocProvider<ProfileBloc>(create: (context) => ProfileBloc()),
          BlocProvider<ProfileEditBloc>(create: (context) => ProfileEditBloc()),
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          home: StreamBuilder<User?>(
              stream: FirebaseAuth.instance.authStateChanges(),
              builder: (context, snapshot) {
                // If the snapshot has user data, then they're already signed in. So Navigating to the Dashboard.
                if (snapshot.hasData) {
                  return const HomePage();
                }
                return const LoginPage();
              }),
        ),
      ),
    );
  }
}

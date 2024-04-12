import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/home/home.dart';
import 'package:frontend/home/view/bloc/home_view_bloc.dart';
import 'package:frontend/profile/bloc/profile_bloc.dart';
import 'package:frontend/search/bloc/search_bloc.dart';
import 'package:frontend/sign_up/bloc/sign_up_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../auth/bloc/auth_bloc.dart';
import '../../home/bloc/home_bloc.dart';
import '../../login/bloc/login_bloc.dart';
import '../../login/login.dart';
import '../../profile/pages/profieEdit/bloc/profile_edit_bloc.dart';
import '../../repositories/auth_repository.dart';
import '../../search/filters/bloc/filter_bloc.dart';
import '../../search/sort/bloc/sort_by_bloc.dart';

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
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
          BlocProvider<ProfileBloc>(create: (context) => ProfileBloc()),
          BlocProvider<ProfileEditBloc>(create: (context) => ProfileEditBloc()),
          BlocProvider<HomeViewBloc>(create: (context) => HomeViewBloc()),
          BlocProvider<SearchBloc>(create: (context) => SearchBloc()),
          BlocProvider<SortByBloc>(create: (context) => SortByBloc()),
          BlocProvider<FilterBloc>(create: (context) => FilterBloc()),
        ],
        child: MaterialApp(
          theme: ThemeData(fontFamily: 'Poppins'),
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

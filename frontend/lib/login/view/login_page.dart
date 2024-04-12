import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/login/bloc/login_bloc.dart';

import '../../auth/bloc/auth_bloc.dart';
import '../../home/view/home_page.dart';
import 'login_form.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.black,
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is Authenticated) {
            // Navigating to the home page if the user is authenticated
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => const HomePage()));
          }
          if (state is AuthError) {
            // Showing the error message if the user has entered invalid credentials
            BlocProvider.of<LoginBloc>(context)
                .add(const LoginTextChangedEvent("", ""));
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(state.error)));
          }
        },
        child: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            if (state is Loading) {
              // Showing the loading indicator while the user is signing in
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            if (state is UnAuthenticated) {
              // Showing the sign in form if the user is not authenticated
              return Container(
                height: h,
                width: w,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage(
                        "assets/images/appbg.png",
                      ),
                      fit: BoxFit.cover),
                ),
                child: Container(
                  height: h,
                  width: w,
                  decoration:
                      BoxDecoration(color: Colors.black.withOpacity(0.8)),
                  child: const Center(
                      child: Padding(
                    padding: EdgeInsets.all(40.0),
                    child: LoginForm(),
                  )),
                ),
              );
            }
            return Container(
              height: h,
              width: w,
              decoration: const BoxDecoration(
                color: Colors.transparent,
                image: DecorationImage(
                    image: AssetImage(
                      "assets/images/appbg.png",
                    ),
                    fit: BoxFit.cover),
              ),
              child: Container(
                height: h,
                width: w,
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.009),
                ),
                child: const LoginForm(),
              ),
            );
          },
        ),
      ),
    );
  }
}

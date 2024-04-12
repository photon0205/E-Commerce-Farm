import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend_for_seller/constants/appColor.dart';
import 'package:frontend_for_seller/signup/signup_Form.dart';

import '../auth/auth_bloc.dart';
import '../home/home_page.dart';

class SignUpPage extends StatelessWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Color(0xFFC3A9FF),
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is Authenticated) {
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => const HomePage()));
          }
          if (state is AuthError) {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(state.error)));
          }
        },
        child: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            if (state is Loading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            if (state is UnAuthenticated) {
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
                  decoration: BoxDecoration(color: Colors.black.withOpacity(0)),
                  child: const Center(
                      child: Padding(
                    padding: EdgeInsets.all(40.0),
                    child: SignUpForm(),
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
                  color: Colors.black.withOpacity(0.09),
                ),
                child: const SignUpForm(),
              ),
            );
          },
        ),
      ),
    );
  }
}

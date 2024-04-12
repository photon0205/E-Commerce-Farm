import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/sign_up/bloc/sign_up_bloc.dart';
import 'package:frontend/sign_up/view/sign_up_form.dart';
import '../../auth/bloc/auth_bloc.dart';
import '../../home/view/home_page.dart';

class SignUpPage extends StatelessWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is Authenticated) {
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => const HomePage()));
          }
          if (state is AuthError) {
            BlocProvider.of<SignUpBloc>(context)
                .add(const SignUpTextChangedEvent('', '', '', ''));
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
                  decoration:
                      BoxDecoration(color: Colors.white.withOpacity(0.04)),
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
                  color: Colors.black.withOpacity(0.009),
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

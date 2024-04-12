import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../auth/auth_bloc.dart';
import '../constants/appColor.dart';
import '../forgot/forgot_page.dart';
import '../signup/signup.dart';
import 'bloc/login_bloc.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({Key? key}) : super(key: key);

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _paswordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              'assets/images/logo.png',
              height: 200,
            ),
            SizedBox(
              height: 32,
              child: BlocBuilder<LoginBloc, LoginState>(
                builder: (context, state) {
                  if (state is LoginErrorState) {
                    return Text(
                      state.errorMessage,
                      style: const TextStyle(color: Color.fromARGB(255, 255, 185, 185)),
                    );
                  }
                  return Container();
                },
              ),
            ),
            _EmailInput(
              controller: _emailController,
              passController: _paswordController,
            ),
            const SizedBox(height: 16),
            _PasswordInput(
              passController: _paswordController,
              controller: _emailController,
            ),
            const SizedBox(height: 16),
            _ForgotPasswordButton(),
            _LoginButton(
              controller: _emailController,
              passController: _paswordController,
            ),
            const SizedBox(height: 16),
            _SignUpButton(),
          ],
        ),
      ),
    );
  }
}

class _EmailInput extends StatelessWidget {
  final TextEditingController controller;
  final TextEditingController passController;

  const _EmailInput({required this.controller, required this.passController});
  @override
  Widget build(BuildContext context) {
    return TextField(
      style: const TextStyle(
        color: Color.fromARGB(255, 255, 235, 235),
      ),
      controller: controller,
      key: const Key('loginForm_emailInput_textField'),
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        filled: true,
        contentPadding: const EdgeInsets.all(15),
        fillColor: Colors.black.withOpacity(0.5),
        border: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.circular(8.0),
        ),
        hintText: 'Email',
         hintStyle: const TextStyle(
                color: Colors.white),
      ),
    );
  }
}

class _PasswordInput extends StatelessWidget {
  final TextEditingController controller;
  final TextEditingController passController;
  const _PasswordInput(
      {required this.controller, required this.passController});
  @override
  Widget build(BuildContext context) {
    return TextField(
      style: const TextStyle(
        color: Color.fromARGB(255, 255, 235, 235),
      ),
      controller: passController,
      key: const Key('loginForm_passwordInput_textField'),
      onTap: ()=>BlocProvider.of<LoginBloc>(context)
          .add(LoginTextChangedEvent(controller.text, "")),
      onEditingComplete: () => BlocProvider.of<LoginBloc>(context)
          .add(LoginTextChangedEvent(controller.text, passController.text)),
      obscureText: true,
      decoration: InputDecoration(
        filled: true,
        contentPadding: const EdgeInsets.all(15),
        fillColor: Colors.black.withOpacity(0.5),
        border: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.circular(8.0),
        ),
        hintText: "Password",
        hintStyle: const TextStyle(
                color: Colors.white),
      ),
    );
  }
}

class _ForgotPasswordButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => const ForgotPasswordPage(),
      )),
      child: Container(
        alignment: Alignment.center,
        height: 70,
        width: 160,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Forgot Password?",
                  style: TextStyle(
                    color: AppColors.primary,
                    fontSize: 15,
                  ),
                  ),
              ],
            ),
            const SizedBox(height: 7,),
          ],
        ),
      ),
    );
  }
}


class _LoginButton extends StatelessWidget {
  final TextEditingController controller;
  final TextEditingController passController;

  const _LoginButton({required this.controller, required this.passController});
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginBloc, LoginState>(
      builder: (context, state) {
        return state is LoginLoadingState
            ? const CircularProgressIndicator()
            : SizedBox(
                height: 40,
                width: double.maxFinite,
                child: ElevatedButton(
                  key: const Key('loginForm_continue_raisedButton'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    disabledForegroundColor: Colors.transparent,
                    disabledBackgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    foregroundColor: Colors.transparent,
                  ),
                  onPressed: state is LoginValidState
                      ? () {
                          BlocProvider.of<LoginBloc>(context).add(
                              LoginSubmittedEvent(
                                  controller.text, passController.text));
                          BlocProvider.of<AuthBloc>(context).add(
                              SignInRequested(
                                  controller.text, passController.text));
                        }
                      : null,
                  child: Ink(
                      width: double.maxFinite,
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Container(
                        alignment: Alignment.center,
                        constraints: const BoxConstraints(
                          maxWidth: 300.0,
                          minHeight: 50.0,
                        ),
                        child: const Text(
                          'LOGIN',
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        ),
                      )),
                ),
              );
      },
    );
  }
}

class _SignUpButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => const SignUpPage(),
      )),
      child: Container(
        alignment: Alignment.center,
        height: 70,
        width: 160,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "New to this Place?",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                  ),
                  ),
                Text(
                  " Sign up",
                  style: TextStyle(
                    color: AppColors.primary,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                  ),
              ],
            ),
            const SizedBox(height: 7,),
            Container(

              height: 1.5,
              color: AppColors.primary,
            )
          ],
        ),
      ),
    );
  }
}

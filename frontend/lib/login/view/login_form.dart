import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/auth/bloc/auth_bloc.dart';
import 'package:frontend/config/constants.dart';
import 'package:frontend/login/bloc/login_bloc.dart';

import '../../sign_up/view/sign_up_page.dart';

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
              height: 50,
            ),
            const SizedBox(
              height: 30,
            ),
            // SizedBox(
            //   height: 32,
            //   child: BlocBuilder<LoginBloc, LoginState>(
            //     builder: (context, state) {
            //       if (state is LoginErrorState) {
            //         return Text(
            //           state.errorMessage,
            //           style: const TextStyle(color: Colors.red),
            //         );
            //       }
            //       return Container();
            //     },
            //   ),
            // ),
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

class _EmailInput extends StatefulWidget {
  final TextEditingController controller;
  final TextEditingController passController;

  const _EmailInput({required this.controller, required this.passController});

  @override
  State<_EmailInput> createState() => _EmailInputState();
}

class _EmailInputState extends State<_EmailInput> {
  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      key: const Key('loginForm_emailInput_textField'),
      onChanged: (email) {
        setState(() {});
      },
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        filled: true,
        contentPadding: const EdgeInsets.all(15),
        fillColor: Colors.white.withOpacity(0.5),
        border: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.circular(8.0),
        ),
        hintText: 'Email',
        errorStyle: const TextStyle(color: Color.fromARGB(255, 247, 75, 75)),
        errorText: widget.controller.text == ""
            ? null
            : EmailValidator.validate(widget.controller.text)
                ? null
                : "Enter a valid email",
      ),
    );
  }
}

class _PasswordInput extends StatefulWidget {
  final TextEditingController controller;
  final TextEditingController passController;
  const _PasswordInput(
      {required this.controller, required this.passController});

  @override
  State<_PasswordInput> createState() => _PasswordInputState();
}

class _PasswordInputState extends State<_PasswordInput> {
  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.passController,
      key: const Key('loginForm_passwordInput_textField'),
      onChanged: (value) {
        BlocProvider.of<LoginBloc>(context).add(LoginTextChangedEvent(
            widget.controller.text, widget.passController.text));
        setState(() {});
      },
      onEditingComplete: () => BlocProvider.of<LoginBloc>(context).add(
          LoginTextChangedEvent(
              widget.controller.text, widget.passController.text)),
      obscureText: true,
      decoration: InputDecoration(
        filled: true,
        contentPadding: const EdgeInsets.all(15),
        fillColor: Colors.white.withOpacity(0.5),
        border: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.circular(8.0),
        ),
        hintText: 'Password',
        errorText: widget.passController.text == ""
            ? null
            : validatePassword(widget.passController.text),
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
                    primary: Colors.transparent,
                    shadowColor: Colors.transparent,
                    onSurface: Colors.transparent,
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
                        gradient: AppColors.buttonGradient,
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
        width: 161,
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
            const SizedBox(
              height: 7,
            ),
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

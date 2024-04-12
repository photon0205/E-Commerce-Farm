import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/auth/bloc/auth_bloc.dart';
import 'package:frontend/login/bloc/login_bloc.dart';
import 'package:frontend/sign_up/bloc/sign_up_bloc.dart';

import '../../config/constants.dart';

class SignUpForm extends StatefulWidget {
  const SignUpForm({super.key});

  @override
  State<SignUpForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: const Alignment(0, -1 / 3),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset('assets/images/logo.png'),
          const SizedBox(height: 30,),
          // SizedBox(
          //   height: 30,
          //   child: BlocBuilder<SignUpBloc, SignUpState>(
          //     builder: (context, state) {
          //       if (state is SignUpErrorState) {
          //         return Text(
          //           state.errorMessage,
          //           style: const TextStyle(color: Colors.red),
          //         );
          //       }
          //       return Container();
          //     },
          //   ),
          // ),
          _NameInput(
            confirmPasswordController: _confirmPasswordController,
            emailController: _emailController,
            nameController: _nameController,
            passwordController: _passwordController,
          ),
          const SizedBox(height: 16),
          _EmailInput(
            confirmPasswordController: _confirmPasswordController,
            emailController: _emailController,
            nameController: _nameController,
            passwordController: _passwordController,
          ),
          const SizedBox(height: 16),
          _PasswordInput(
            confirmPasswordController: _confirmPasswordController,
            emailController: _emailController,
            nameController: _nameController,
            passwordController: _passwordController,
          ),
          const SizedBox(height: 20),
          _ConfirmPasswordInput(
            confirmPasswordController: _confirmPasswordController,
            emailController: _emailController,
            nameController: _nameController,
            passwordController: _passwordController,
          ),
          const SizedBox(height: 20),
          _SignUpButton(
            confirmPasswordController: _confirmPasswordController,
            emailController: _emailController,
            nameController: _nameController,
            passwordController: _passwordController,
          ),
        ],
      ),
    );
  }
}

class _NameInput extends StatefulWidget {
  final TextEditingController nameController;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final TextEditingController confirmPasswordController;

  const _NameInput(
      {required this.nameController,
      required this.emailController,
      required this.passwordController,
      required this.confirmPasswordController});

  @override
  State<_NameInput> createState() => _NameInputState();
}

class _NameInputState extends State<_NameInput> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignUpBloc, SignUpState>(builder: (context, state) {
      return TextField(
        controller: widget.nameController,
        key: const Key('signUpForm_nameInput_textField'),
        onChanged:((value) =>  setState(() {
          
        })),
        keyboardType: TextInputType.name,
        decoration: InputDecoration(
          filled: true,
          contentPadding: const EdgeInsets.all(15),
          fillColor: Colors.black.withOpacity(0.09),
          border: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(8.0),
          ),
          hintText: 'Name',
          errorText: widget.nameController.text==""? "Name is required":null,
        ),
      );
    });
  }
}

class _EmailInput extends StatefulWidget {
  final TextEditingController nameController;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final TextEditingController confirmPasswordController;

  const _EmailInput(
      {required this.nameController,
      required this.emailController,
      required this.passwordController,
      required this.confirmPasswordController});

  @override
  State<_EmailInput> createState() => _EmailInputState();
}

class _EmailInputState extends State<_EmailInput> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignUpBloc, SignUpState>(
      builder: (context, state) {
        return TextField(
          controller: widget.emailController,
          style: const TextStyle(),
          key: const Key('signUpForm_emailInput_textField'),
          onChanged: (name) =>setState(() {
            
          }),
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
            filled: true,
            contentPadding: const EdgeInsets.all(15),
            fillColor: Colors.black.withOpacity(0.09),
            border: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.circular(8.0),
            ),
            hintText: 'Email',
            errorText: widget.emailController.text==""||EmailValidator.validate(widget.emailController.text)?null:'Enter a valid email',
          ),
        );
      },
    );
  }
}

class _PasswordInput extends StatefulWidget {
  final TextEditingController nameController;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final TextEditingController confirmPasswordController;

  const _PasswordInput(
      {required this.nameController,
      required this.emailController,
      required this.passwordController,
      required this.confirmPasswordController});

  @override
  State<_PasswordInput> createState() => _PasswordInputState();
}

class _PasswordInputState extends State<_PasswordInput> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignUpBloc, SignUpState>(
      builder: (context, state) {
        return TextField(
          controller: widget.passwordController,
          key: const Key('signUpForm_passwordInput_textField'),
          onChanged: (name) {
            setState(() {});
          },
          obscureText: true,
          decoration: InputDecoration(
              filled: true,
              contentPadding: const EdgeInsets.all(15),
              fillColor: Colors.black.withOpacity(0.09),
              border: OutlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: BorderRadius.circular(8.0),
              ),
              hintText: 'Password',
              errorText: widget.passwordController.text == ""
                  ? null
                  : validatePassword(widget.passwordController.text)),
        );
      },
    );
  }
}

class _ConfirmPasswordInput extends StatefulWidget {
  final TextEditingController nameController;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final TextEditingController confirmPasswordController;

  const _ConfirmPasswordInput(
      {required this.nameController,
      required this.emailController,
      required this.passwordController,
      required this.confirmPasswordController});

  @override
  State<_ConfirmPasswordInput> createState() => _ConfirmPasswordInputState();
}

class _ConfirmPasswordInputState extends State<_ConfirmPasswordInput> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignUpBloc, SignUpState>(
      builder: (context, state) {
        return TextField(
          controller: widget.confirmPasswordController,
          key: const Key('signUpForm_confirmedPasswordInput_textField'),
          onChanged: (name) {
            BlocProvider.of<SignUpBloc>(context).add(SignUpTextChangedEvent(
              widget.emailController.text,
              widget.passwordController.text,
              widget.nameController.text,
              widget.confirmPasswordController.text,
            ));
            setState(() {
              
            });
          },
          obscureText: true,
          decoration: InputDecoration(
              filled: true,
              contentPadding: const EdgeInsets.all(15),
              fillColor: Colors.black.withOpacity(0.09),
              border: OutlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: BorderRadius.circular(8.0),
              ),
              hintText: 'Confirm Password',
              errorText: widget.passwordController.text ==
                      widget.confirmPasswordController.text
                  ? null
                  : "Password does not match"),
        );
      },
    );
  }
}

class _SignUpButton extends StatelessWidget {
  final TextEditingController nameController;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final TextEditingController confirmPasswordController;

  const _SignUpButton(
      {required this.nameController,
      required this.emailController,
      required this.passwordController,
      required this.confirmPasswordController});
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignUpBloc, SignUpState>(
      builder: (context, state) {
        return state is SignUpLoadingState
            ? const CircularProgressIndicator()
            : SizedBox(
                height: 40,
                width: double.maxFinite,
                child: ElevatedButton(
                  key: const Key('signUpForm_continue_raisedButton'),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.transparent,
                    onSurface: Colors.white,
                    shadowColor: Colors.transparent,
                  ),
                  onPressed: state is SignUpValidState
                      ? () {
                          BlocProvider.of<SignUpBloc>(context)
                              .add(SignUpSubmittedEvent(
                            emailController.text,
                            passwordController.text,
                            nameController.text,
                          ));
                          BlocProvider.of<AuthBloc>(context)
                              .add(SignUpRequested(
                            emailController.text,
                            passwordController.text,
                            nameController.text,
                          ));
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
                          minHeight: 40.0,
                        ),
                        child: const Text(
                          'SIGN UP',
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        )),
                  ),
                ),
              );
      },
    );
  }
}

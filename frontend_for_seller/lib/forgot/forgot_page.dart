import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../constants/appColor.dart';
import '../login/login_page.dart';

class ForgotPasswordPage extends StatelessWidget {
  const ForgotPasswordPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor:  Color(0xFFC3A9FF),
      body: Container(
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
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.5),
          ),
          child: const Center(
            child: Padding(
              padding: EdgeInsets.all(40.0),
              child: ForgotForm(),
            ),
          ),
        ),
      ),
    );
  }
}

class ForgotForm extends StatefulWidget {
  const ForgotForm({Key? key}) : super(key: key);
  @override
  // ignore: library_private_types_in_public_api
  State<ForgotForm> createState() => _ForgotFormState();
}

class _ForgotFormState extends State<ForgotForm> {
  final TextEditingController _emailController = TextEditingController();

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
            const SizedBox(height: 32),
            _EmailInput(controller: _emailController),
            const SizedBox(height: 16),
            _SubmitButton(controller: _emailController)
          ],
        ),
      ),
    );
  }
}

class _EmailInput extends StatelessWidget {
  final TextEditingController controller;

  const _EmailInput({required this.controller});
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
        fillColor: Colors.white.withOpacity(0.5),
        border: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.circular(8.0),
        ),
        hintText: 'Email',
      ),
    );
  }
}

class _SubmitButton extends StatelessWidget {
  final TextEditingController controller;

  const _SubmitButton({required this.controller});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      width: double.maxFinite,
      child: ElevatedButton(
        key: const Key('loginForm_continue_raisedButton'),
        style: ElevatedButton.styleFrom(
          primary: Colors.transparent,
          shadowColor: Colors.transparent,
          onSurface: Colors.transparent,
        ),
        onPressed: () => _submit(context),
        child: Ink(
            width: double.maxFinite,
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Container(
              alignment: Alignment.center,
              constraints: const BoxConstraints(
                maxWidth: 300.0,
                minHeight: 50.0,
              ),
              child: const Text(
                'Submit',
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
            )),
      ),
    );
  }

  void _submit(BuildContext context) {
    FirebaseAuth.instance
        .sendPasswordResetEmail(email: controller.text)
        .then((_) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Password Reset"),
            content:
                const Text("A password reset link has been sent to your email"),
            actions: [
              ElevatedButton(
                child: const Text("OK"),
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LoginPage(),
                    ),
                  );
                },
              ),
            ],
          );
        },
      );
    }).catchError((error) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Error"),
            content: Text(error.toString()),
            actions: [
              ElevatedButton(
                child: const Text("OK"),
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.pushNamed(context, "/login");
                },
              ),
            ],
          );
        },
      );
    });
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:frontend_for_seller/components/multiSelect/multiSelect.dart';
import 'package:frontend_for_seller/repositories/database_repository.dart';
import '../auth/auth_bloc.dart';
import '../constants/appColor.dart';
import '../home/home_page.dart';
import 'bloc/sign_up_bloc.dart';

class SignUpForm extends StatefulWidget {
  const SignUpForm({super.key});

  @override
  State<SignUpForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _shopNameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _aadharController = TextEditingController();
  final TextEditingController _mobileNoController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  List<String> selectedCategories = [];
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: const Alignment(0, -1 / 3),
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: FutureBuilder(
            future: DatabaseService().retrieveCategories(),
            builder: (context, AsyncSnapshot<List<String>> snapshot) {
              if (!snapshot.hasData &&
                  snapshot.connectionState == ConnectionState.none) {
                return const Center(
                  child: Text('Sorry, something went wrong'),
                );
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset('assets/images/logo.png',
                  height: 200,),
                  const Padding(
                    padding: EdgeInsets.all(5),
                    child: Text(
                      "Turn On GPS for location",
                      style: TextStyle(
                        color: Colors.red,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 30,
                    child: BlocBuilder<SignUpBloc, SignUpState>(
                      builder: (context, state) {
                        if (state is SignUpErrorState) {
                          return Text(
                            state.errorMessage,
                            style: const TextStyle(color: Colors.red),
                          );
                        }
                        return Container();
                      },
                    ),
                  ),
                  _NameInput(
                    aadharController: _aadharController,
                    addressController: _addressController,
                    mobileNoController: _mobileNoController,
                    shopNameController: _shopNameController,
                    confirmPasswordController: _confirmPasswordController,
                    emailController: _emailController,
                    nameController: _nameController,
                    passwordController: _passwordController,
                    selected: selectedCategories,
                  ),
                  const SizedBox(height: 16),
                  _ShopNameInput(
                    aadharController: _aadharController,
                    addressController: _addressController,
                    mobileNoController: _mobileNoController,
                    shopNameController: _shopNameController,
                    confirmPasswordController: _confirmPasswordController,
                    emailController: _emailController,
                    nameController: _nameController,
                    passwordController: _passwordController,
                    selected: selectedCategories,
                  ),
                  const SizedBox(height: 16),
                  _AddressInput(
                    aadharController: _aadharController,
                    addressController: _addressController,
                    mobileNoController: _mobileNoController,
                    shopNameController: _shopNameController,
                    confirmPasswordController: _confirmPasswordController,
                    emailController: _emailController,
                    nameController: _nameController,
                    passwordController: _passwordController,
                    selected: selectedCategories,
                  ),
                  const SizedBox(height: 16),
                  _AadharInput(
                    aadharController: _aadharController,
                    addressController: _addressController,
                    mobileNoController: _mobileNoController,
                    shopNameController: _shopNameController,
                    confirmPasswordController: _confirmPasswordController,
                    emailController: _emailController,
                    nameController: _nameController,
                    passwordController: _passwordController,
                    selected: selectedCategories,
                  ),
                  const SizedBox(height: 16),
                  _MobileNoInput(
                    aadharController: _aadharController,
                    addressController: _addressController,
                    mobileNoController: _mobileNoController,
                    shopNameController: _shopNameController,
                    confirmPasswordController: _confirmPasswordController,
                    emailController: _emailController,
                    nameController: _nameController,
                    passwordController: _passwordController,
                    selected: selectedCategories,
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 50,
                    child: MultiSelect(
                      choices: snapshot.data!,
                      selected: selectedCategories,
                    ),
                  ),
                  _EmailInput(
                    aadharController: _aadharController,
                    addressController: _addressController,
                    mobileNoController: _mobileNoController,
                    shopNameController: _shopNameController,
                    confirmPasswordController: _confirmPasswordController,
                    emailController: _emailController,
                    nameController: _nameController,
                    passwordController: _passwordController,
                    selected: selectedCategories,
                  ),
                  const SizedBox(height: 16),
                  _PasswordInput(
                    aadharController: _aadharController,
                    addressController: _addressController,
                    mobileNoController: _mobileNoController,
                    shopNameController: _shopNameController,
                    confirmPasswordController: _confirmPasswordController,
                    emailController: _emailController,
                    nameController: _nameController,
                    passwordController: _passwordController,
                    selected: selectedCategories,
                  ),
                  const SizedBox(height: 20),
                  _ConfirmPasswordInput(
                    aadharController: _aadharController,
                    addressController: _addressController,
                    mobileNoController: _mobileNoController,
                    shopNameController: _shopNameController,
                    confirmPasswordController: _confirmPasswordController,
                    emailController: _emailController,
                    nameController: _nameController,
                    passwordController: _passwordController,
                    selected: selectedCategories,
                  ),
                  const SizedBox(height: 20),
                  _SignUpButton(
                    aadharController: _aadharController,
                    addressController: _addressController,
                    mobileNoController: _mobileNoController,
                    shopNameController: _shopNameController,
                    confirmPasswordController: _confirmPasswordController,
                    emailController: _emailController,
                    nameController: _nameController,
                    passwordController: _passwordController,
                    selected: selectedCategories,
                  ),
                ],
              );
            }),
      ),
    );
  }
}

class _NameInput extends StatelessWidget {
  final TextEditingController nameController;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final TextEditingController confirmPasswordController;
  final TextEditingController shopNameController;
  final TextEditingController addressController;
  final TextEditingController aadharController;
  final TextEditingController mobileNoController;
  List<String> selected;

  _NameInput(
      {required this.nameController,
      required this.emailController,
      required this.passwordController,
      required this.confirmPasswordController,
      required this.addressController,
      required this.shopNameController,
      required this.aadharController,
      required this.mobileNoController,
      required this.selected});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignUpBloc, SignUpState>(builder: (context, state) {
      return TextField(
        style: const TextStyle(
          color: Color.fromARGB(255, 255, 255, 255),
        ),
        controller: nameController,
        key: const Key('signUpForm_nameInput_textField'),
        keyboardType: TextInputType.name,
        decoration: InputDecoration(
          filled: true,
          contentPadding: const EdgeInsets.all(15),
          fillColor: Colors.black.withOpacity(0.5),
          border: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(8.0),
          ),
          hintText: 'Name',
          hintStyle:
              const TextStyle(color: Colors.white, fontWeight: FontWeight.w100),
        ),
      );
    });
  }
}

class _ShopNameInput extends StatelessWidget {
  final TextEditingController nameController;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final TextEditingController confirmPasswordController;
  final TextEditingController shopNameController;
  final TextEditingController addressController;
  final TextEditingController aadharController;
  final TextEditingController mobileNoController;
  List<String> selected;
  _ShopNameInput(
      {required this.nameController,
      required this.emailController,
      required this.passwordController,
      required this.confirmPasswordController,
      required this.shopNameController,
      required this.addressController,
      required this.aadharController,
      required this.mobileNoController,
      required this.selected});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignUpBloc, SignUpState>(builder: (context, state) {
      return TextField(
        style: const TextStyle(
          color: Color.fromARGB(255, 255, 235, 235),
        ),
        controller: shopNameController,
        key: const Key('shopName'),
        onTap: () {
          BlocProvider.of<SignUpBloc>(context).add(SignUpTextChangedEvent(
            "hello@gmail.com",
            "abcd1234@",
            nameController.text,
            "abcd1234@",
            "shopName",
            "addressController.text",
            "123412341324",
            "2586525689",
            selected,
          ));
        },
        keyboardType: TextInputType.name,
        decoration: InputDecoration(
          filled: true,
          contentPadding: const EdgeInsets.all(15),
          fillColor: Colors.black.withOpacity(0.5),
          border: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(8.0),
          ),
          hintText: 'Shop Name',
          hintStyle:
              const TextStyle(color: Colors.white, fontWeight: FontWeight.w100),
        ),
      );
    });
  }
}

class _AddressInput extends StatelessWidget {
  final TextEditingController nameController;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final TextEditingController confirmPasswordController;
  final TextEditingController shopNameController;
  final TextEditingController addressController;
  final TextEditingController aadharController;
  final TextEditingController mobileNoController;
  List<String> selected;
  Future<void> getLocation() async {
    bool serviceEnabled;
    LocationPermission permission;
    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    Position postion = await Geolocator.getCurrentPosition();
    List<Placemark> placemarks =
        await placemarkFromCoordinates(postion.latitude, postion.longitude);
    addressController.text = '${placemarks[0].subLocality}';
  }

  _AddressInput(
      {required this.nameController,
      required this.emailController,
      required this.passwordController,
      required this.confirmPasswordController,
      required this.shopNameController,
      required this.addressController,
      required this.aadharController,
      required this.mobileNoController,
      required this.selected});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignUpBloc, SignUpState>(builder: (context, state) {
      return TextField(
        style: const TextStyle(
          color: Color.fromARGB(255, 255, 235, 235),
        ),
        controller: addressController,
        readOnly: true,
        key: const Key('address'),
        onTap: () {
          BlocProvider.of<SignUpBloc>(context).add(SignUpTextChangedEvent(
            "hello@gmail.com",
            "abcd1234@",
            nameController.text,
            "abcd1234@",
            shopNameController.text,
            "addressController.text",
            "123412341324",
            "2586525689",
            selected,
          ));
        },
        keyboardType: TextInputType.streetAddress,
        decoration: InputDecoration(
          suffixIcon: TextButton(
            style: ButtonStyle(
                foregroundColor:
                    MaterialStatePropertyAll(Colors.white.withOpacity(0.6))),
            onPressed: () {
              getLocation();
            },
            child: const Text("Get Location"),
          ),
          filled: true,
          contentPadding: const EdgeInsets.all(15),
          fillColor: Colors.black.withOpacity(0.5),
          border: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(8.0),
          ),
          hintText: 'Address',
          hintStyle:
              const TextStyle(color: Colors.white, fontWeight: FontWeight.w100),
        ),
      );
    });
  }
}

class _AadharInput extends StatelessWidget {
  final TextEditingController nameController;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final TextEditingController confirmPasswordController;
  final TextEditingController shopNameController;
  final TextEditingController addressController;
  final TextEditingController aadharController;
  final TextEditingController mobileNoController;
  List<String> selected;

  _AadharInput(
      {required this.nameController,
      required this.emailController,
      required this.passwordController,
      required this.confirmPasswordController,
      required this.shopNameController,
      required this.addressController,
      required this.aadharController,
      required this.mobileNoController,
      required this.selected});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignUpBloc, SignUpState>(builder: (context, state) {
      return TextField(
        style: const TextStyle(
          color: Color.fromARGB(255, 255, 235, 235),
        ),
        maxLength: 12,
        controller: aadharController,
        key: const Key('aadhar'),
        onTap: () {
          BlocProvider.of<SignUpBloc>(context).add(SignUpTextChangedEvent(
            "hello@gmail.com",
            "abcd1234@",
            nameController.text,
            "abcd1234@",
            shopNameController.text,
            addressController.text,
            "123412341324",
            "2586525689",
            selected,
          ));
        },
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          counterText: "",
          filled: true,
          contentPadding: const EdgeInsets.all(15),
          fillColor: Colors.black.withOpacity(0.5),
          border: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(8.0),
          ),
          hintText: 'Aadhar Number',
          hintStyle:
              const TextStyle(color: Colors.white, fontWeight: FontWeight.w100),
        ),
      );
    });
  }
}

class _MobileNoInput extends StatelessWidget {
  final TextEditingController nameController;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final TextEditingController confirmPasswordController;
  final TextEditingController shopNameController;
  final TextEditingController addressController;
  final TextEditingController aadharController;
  final TextEditingController mobileNoController;
  List<String> selected;

  _MobileNoInput(
      {required this.nameController,
      required this.emailController,
      required this.passwordController,
      required this.confirmPasswordController,
      required this.shopNameController,
      required this.addressController,
      required this.aadharController,
      required this.mobileNoController,
      required this.selected});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignUpBloc, SignUpState>(builder: (context, state) {
      return TextField(
        style: const TextStyle(
          color: Color.fromARGB(255, 255, 235, 235),
        ),
        maxLength: 10,
        controller: mobileNoController,
        key: const Key('mobileno'),
        onTap: () {
          BlocProvider.of<SignUpBloc>(context).add(SignUpTextChangedEvent(
            "hello@gmail.com",
            "abcd1234@",
            nameController.text,
            "abcd1234@",
            shopNameController.text,
            addressController.text,
            aadharController.text,
            "2586525689",
            selected,
          ));
        },
        keyboardType: TextInputType.phone,
        decoration: InputDecoration(
          counterText: "",
          filled: true,
          contentPadding: const EdgeInsets.all(15),
          fillColor: Colors.black.withOpacity(0.5),
          border: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(8.0),
          ),
          hintText: 'Mobile Number',
          hintStyle:
              const TextStyle(color: Colors.white, fontWeight: FontWeight.w100),
        ),
      );
    });
  }
}

class _EmailInput extends StatelessWidget {
  final TextEditingController nameController;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final TextEditingController confirmPasswordController;
  final TextEditingController shopNameController;
  final TextEditingController addressController;
  final TextEditingController aadharController;
  final TextEditingController mobileNoController;
  List<String> selected;

  _EmailInput(
      {required this.nameController,
      required this.emailController,
      required this.passwordController,
      required this.confirmPasswordController,
      required this.shopNameController,
      required this.addressController,
      required this.aadharController,
      required this.mobileNoController,
      required this.selected});
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignUpBloc, SignUpState>(
      builder: (context, state) {
        return TextField(
          style: const TextStyle(
            color: Color.fromARGB(255, 255, 235, 235),
          ),
          controller: emailController,
          key: const Key('signUpForm_emailInput_textField'),
          onTap: () {
            BlocProvider.of<SignUpBloc>(context).add(SignUpTextChangedEvent(
              "hello@gmail.com",
              "abcd1234@",
              nameController.text,
              "abcd1234@",
              shopNameController.text,
              addressController.text,
              aadharController.text,
              mobileNoController.text,
              selected,
            ));
          },
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
                color: Colors.white, fontWeight: FontWeight.w100),
          ),
        );
      },
    );
  }
}

class _PasswordInput extends StatelessWidget {
  final TextEditingController nameController;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final TextEditingController confirmPasswordController;
  final TextEditingController shopNameController;
  final TextEditingController addressController;
  final TextEditingController aadharController;
  final TextEditingController mobileNoController;
  List<String> selected;

  _PasswordInput(
      {required this.nameController,
      required this.emailController,
      required this.passwordController,
      required this.confirmPasswordController,
      required this.shopNameController,
      required this.addressController,
      required this.aadharController,
      required this.mobileNoController,
      required this.selected});
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignUpBloc, SignUpState>(
      builder: (context, state) {
        return TextField(
          style: const TextStyle(
            color: Color.fromARGB(255, 255, 235, 235),
          ),
          controller: passwordController,
          key: const Key('signUpForm_passwordInput_textField'),
          onTap: () {
            BlocProvider.of<SignUpBloc>(context).add(SignUpTextChangedEvent(
              emailController.text,
              "abcd1234@",
              nameController.text,
              "abcd1234@",
              shopNameController.text,
              addressController.text,
              aadharController.text,
              mobileNoController.text,
              selected,
            ));
          },
          onEditingComplete: () {
            BlocProvider.of<SignUpBloc>(context).add(SignUpTextChangedEvent(
              emailController.text,
              passwordController.text,
              nameController.text,
              confirmPasswordController.text,
              shopNameController.text,
              addressController.text,
              aadharController.text,
              mobileNoController.text,
              selected,
            ));
          },
          obscureText: true,
          decoration: InputDecoration(
            filled: true,
            contentPadding: const EdgeInsets.all(15),
            fillColor: Colors.black.withOpacity(0.5),
            border: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.circular(8.0),
            ),
            hintText: 'Password',
            hintStyle: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.w100),
          ),
        );
      },
    );
  }
}

class _ConfirmPasswordInput extends StatelessWidget {
  final TextEditingController nameController;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final TextEditingController confirmPasswordController;
  final TextEditingController shopNameController;
  final TextEditingController addressController;
  final TextEditingController aadharController;
  final TextEditingController mobileNoController;
  List<String> selected;

  _ConfirmPasswordInput(
      {required this.nameController,
      required this.emailController,
      required this.passwordController,
      required this.confirmPasswordController,
      required this.shopNameController,
      required this.addressController,
      required this.aadharController,
      required this.mobileNoController,
      required this.selected});
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignUpBloc, SignUpState>(
      builder: (context, state) {
        return TextField(
          style: const TextStyle(
            color: Color.fromARGB(255, 255, 235, 235),
          ),
          controller: confirmPasswordController,
          key: const Key('signUpForm_confirmedPasswordInput_textField'),
          onTap: () {
            BlocProvider.of<SignUpBloc>(context).add(SignUpTextChangedEvent(
              emailController.text,
              passwordController.text,
              nameController.text,
              "abcd1234@",
              shopNameController.text,
              addressController.text,
              aadharController.text,
              mobileNoController.text,
              selected,
            ));
          },
          onChanged: (e) {
            BlocProvider.of<SignUpBloc>(context).add(SignUpTextChangedEvent(
              emailController.text,
              passwordController.text,
              nameController.text,
              confirmPasswordController.text,
              shopNameController.text,
              addressController.text,
              aadharController.text,
              mobileNoController.text,
              selected,
            ));
          },
          obscureText: true,
          decoration: InputDecoration(
            filled: true,
            contentPadding: const EdgeInsets.all(15),
            fillColor: Colors.black.withOpacity(0.5),
            border: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.circular(8.0),
            ),
            hintText: 'Confirm Password',
            hintStyle: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.w100),
          ),
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
  final TextEditingController shopNameController;
  final TextEditingController addressController;
  final TextEditingController aadharController;
  final TextEditingController mobileNoController;
  List<String> selected;

  _SignUpButton(
      {required this.nameController,
      required this.emailController,
      required this.passwordController,
      required this.confirmPasswordController,
      required this.shopNameController,
      required this.addressController,
      required this.aadharController,
      required this.mobileNoController,
      required this.selected});
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
                    backgroundColor: Colors.transparent,
                    disabledForegroundColor: Colors.white.withOpacity(0.38),
                    shadowColor: Colors.transparent,
                  ),
                  onPressed: (() => _showTermsModal(context, state)),
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

  Future<void> _showTermsModal(context, state) async {
    await showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.black.withOpacity(0.1),
          title: const Text('Terms and Conditions',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 23.5,
                  fontWeight: FontWeight.bold)),
          content: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Text('Last updated 26 July, 2022',
                    style: TextStyle(color: AppColors.primary, fontSize: 14),
                    textAlign: TextAlign.left),
                const Text('Acknowledgement',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                const Text(
                    'text text text text text text text text text text text text  text text text text text text text text text text text text  text text text text text text text text text text text text  text text text text text text text text text text text text  text text text text text.',
                    style: TextStyle(color: Colors.white, fontSize: 13)),
              ],
            ),
          ),
          actions: <Widget>[
            Container(
                decoration: const BoxDecoration(color: Colors.transparent),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    disabledForegroundColor: Colors.transparent,
                    disabledBackgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    foregroundColor: Colors.transparent,
                  ),
                  onPressed: () {},
                  child: _Accept(
                    aadharController: aadharController,
                    addressController: addressController,
                    mobileNoController: mobileNoController,
                    shopNameController: shopNameController,
                    confirmPasswordController: confirmPasswordController,
                    emailController: emailController,
                    nameController: nameController,
                    passwordController: passwordController,
                    selected: selected,
                  ),
                )),
          ],
        );
      },
    );
  }
}

// ignore: must_be_immutable
class _Accept extends StatelessWidget {
  final TextEditingController nameController;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final TextEditingController confirmPasswordController;
  final TextEditingController shopNameController;
  final TextEditingController addressController;
  final TextEditingController aadharController;
  final TextEditingController mobileNoController;
  List<String> selected;

  _Accept(
      {required this.nameController,
      required this.emailController,
      required this.passwordController,
      required this.confirmPasswordController,
      required this.shopNameController,
      required this.addressController,
      required this.aadharController,
      required this.mobileNoController,
      required this.selected});
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
                    backgroundColor: Colors.transparent,
                    disabledForegroundColor: Colors.transparent,
                    disabledBackgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    foregroundColor: Colors.transparent,
                  ),
                      onPressed: state is !SignUpValidState
                          ? () async {
                              BlocProvider.of<SignUpBloc>(context)
                                  .add(SignUpSubmittedEvent(
                                emailController.text,
                                passwordController.text,
                                nameController.text,
                                shopNameController.text,
                                addressController.text,
                                aadharController.text,
                                mobileNoController.text,
                                selected,
                              ));
                              BlocProvider.of<AuthBloc>(context)
                                  .add(SignUpRequested(
                                nameController.text,
                                shopNameController.text,
                                emailController.text,
                                aadharController.text,
                                addressController.text,
                                mobileNoController.text,
                                passwordController.text,
                                selected,
                              ));
                              _showSuccessModal(context);
                            }
                          : null,
                      child: Ink(
                        width: 300.0,
                        decoration: BoxDecoration(
                        color: Color(0xFFC3A9FF),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Container(
                            alignment: Alignment.center,
                            constraints: const BoxConstraints(
                              maxWidth: 300.0,
                              minHeight: 40.0,
                            ),
                            child: const Text(
                              'ACCEPT',
                              style:
                                  TextStyle(color: Colors.black, fontSize: 18),
                            )),
                      ),
                    ),
              );
      },
    );
  }
}

Future<void> _showSuccessModal(context) async {
  await showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Success'),
        content: const Text('You have successfully signed up'),
        actions: <Widget>[
          ElevatedButton(
            child: const Text('OK'),
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const HomePage(),
                ),
              );
            },
          ),
        ],
      );
    },
  );
}

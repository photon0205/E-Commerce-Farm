import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';
import 'package:frontend/config/constants.dart';
import 'package:frontend/profile/bloc/profile_bloc.dart';
import 'package:frontend/services/database_services.dart';
import 'package:frontend/services/local_storage.dart';

import '../../../models/user.dart';
import 'bloc/profile_edit_bloc.dart';

class ProfileEditPage extends StatefulWidget {
  const ProfileEditPage({Key? key, required this.initial}) : super(key: key);
  final String initial;

  @override
  State<ProfileEditPage> createState() => _ProfileEditPageState();
}

class _ProfileEditPageState extends State<ProfileEditPage> {
  String? gender = !(localStorage.gender == "") ? localStorage.gender : null;

  final TextEditingController _nameController =
      TextEditingController(text: localStorage.username);
  final TextEditingController _dobController =
      TextEditingController(text: localStorage.dob);
  final TextEditingController _numberController =
      TextEditingController(text: localStorage.number);
  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    return SizedBox(
      height: h,
      width: w,
      child: Column(
        children: [
          Container(
            alignment: Alignment.bottomCenter,
            color: Colors.black,
            height: h * 0.15,
            child: SizedBox(
              height: h * 0.1,
              child: Row(
                children: [
                  const SizedBox(
                    width: 20,
                  ),
                  InkWell(
                    onTap: () {
                      BlocProvider.of<ProfileBloc>(context).add(BackEvent());
                    },
                    child: const Icon(
                      Icons.arrow_back_ios,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  const Text(
                    "Profile",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 30, right: 30),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(
                    height: 25,
                  ),
                  Container(
                    alignment: Alignment.center,
                    height: 90,
                    width: 90,
                    decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(45)),
                    child: Text(
                      widget.initial,
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 25,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                  //  ),
                  const SizedBox(
                    height: 25,
                  ),
                  TextField(
                    onChanged: ((value) {
                      BlocProvider.of<ProfileEditBloc>(context).add(
                          ProfileDataChanged(
                              value,
                              gender == null ? "" : gender!,
                              "dob",
                              "mobileNumber"));
                    }),
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: "Full Name",
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  DropdownButton<String>(
                      value: gender,
                      isExpanded: true,
                      hint: const Text('Select Gender'),
                      items: [
                        DropdownMenuItem<String>(
                          onTap: () {
                            setState(() {
                              gender = "Male";
                            });
                          },
                          value: 'Male',
                          child: const Text('Male'),
                        ),
                        DropdownMenuItem<String>(
                          onTap: () {
                            setState(() {
                              gender = "Female";
                            });
                          },
                          value: 'Female',
                          child: const Text('Female'),
                        ),
                      ],
                      onChanged: (e) {}),
                  const SizedBox(
                    height: 10,
                  ),
                  TextField(
                    controller: _dobController,
                    readOnly: true,
                    decoration: InputDecoration(
                      hintText: "Date of Birth",
                      suffixIcon: InkWell(
                          onTap: () {
                            DatePicker.showDatePicker(
                              context,
                              showTitleActions: true,
                              minTime: DateTime(1899),
                              maxTime: DateTime(2022),
                              onConfirm: (d) {
                                setState(() {
                                  String formattedDate =
                                      DateFormat('dd/MM/yyyy').format(d);
                                  _dobController.text = formattedDate;
                                });
                              },
                            );
                          },
                          child: const Icon(Icons.calendar_month)),
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  TextField(
                    textAlign: TextAlign.start,
                    controller: _numberController,
                    keyboardType: TextInputType.phone,
                    decoration: const InputDecoration(
                      prefixText: '+91 ',
                      prefixStyle: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                      labelText: "Mobile Number",
                    ),
                  ),
                  const SizedBox(
                    height: 35,
                  ),
                  ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all<Color>(Colors.black),
                        fixedSize: MaterialStateProperty.all<Size>(
                            const Size(200, 42)),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ))),
                    onPressed: () {
                      BlocProvider.of<ProfileEditBloc>(context)
                          .add(UpdationStarts());
                      DatabaseService().updateUser(
                        _nameController.text,
                        gender!,
                        _dobController.text,
                        _numberController.text,
                      );
                      BlocProvider.of<ProfileEditBloc>(context)
                          .add(UpdationComplete());
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: Text(
                        'Profile Updated Successfully',
                      )));
                    },
                    child: BlocBuilder<ProfileEditBloc, ProfileEditState>(
                      builder: (context, state) {
                        if (state is Loading) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }

                        return const Text(
                          "Save Changes",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CheckPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint0 = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill
      ..strokeWidth = 0;

    Path path0 = Path();
    path0.moveTo(size.width * 0.35, size.height * 0.37);
    path0.cubicTo(size.width * 0.38, size.height * 0.44, size.width * 0.37,
        size.height * 0.46, size.width * 0.39, size.height * 0.47);
    path0.cubicTo(size.width * 0.40, size.height * 0.47, size.width * 0.53,
        size.height * 0.36, size.width * 0.55, size.height * 0.35);
    path0.cubicTo(size.width * 0.56, size.height * 0.34, size.width * 0.55,
        size.height * 0.32, size.width * 0.54, size.height * 0.33);
    path0.cubicTo(size.width * 0.53, size.height * 0.34, size.width * 0.41,
        size.height * 0.44, size.width * 0.39, size.height * 0.44);
    path0.cubicTo(size.width * 0.38, size.height * 0.43, size.width * 0.37,
        size.height * 0.36, size.width * 0.36, size.height * 0.36);
    path0.cubicTo(size.width * 0.36, size.height * 0.35, size.width * 0.36,
        size.height * 0.35, size.width * 0.35, size.height * 0.37);
    path0.close();

    canvas.drawPath(path0, paint0);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

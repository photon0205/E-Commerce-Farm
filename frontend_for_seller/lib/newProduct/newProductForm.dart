import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:frontend_for_seller/constants/appColor.dart';
import 'package:frontend_for_seller/repositories/local_storage.dart';

import '../components/singleSelect/singleSelect.dart';
import 'bloc/new_product_bloc.dart';

enum ProductType { negotiable, fixed }

class ProductForm extends StatefulWidget {
  const ProductForm({Key? key}) : super(key: key);

  @override
  State<ProductForm> createState() => _ProductFormState();
}

class _ProductFormState extends State<ProductForm> {
  ProductType? prodType = ProductType.negotiable;
  final TextEditingController _prodNameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _aboutProductController = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  List<int> index = [];
  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    return Container(
      child: Column(children: [
        const SizedBox(
          height: 30,
        ),
        SizedBox(
          height: 45,
          child: Image.asset("assets/images/logo.png"),
        ),
        const SizedBox(
          height: 30,
        ),
        Container(
          width: w * 0.85,
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.18),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              children: [
                SizedBox(
                  height: 20,
                  child: BlocBuilder<NewProductBloc, NewProductState>(
                    builder: (context, state) {
                      if (state is ErrorState) {
                        return Text(
                          state.errorMessage,
                          style:
                              const TextStyle(color: Colors.red, fontSize: 10),
                        );
                      } else {
                        return Container();
                      }
                    },
                  ),
                ),
                TextField(
                  controller: _prodNameController,
                  onChanged: (email) => BlocProvider.of<NewProductBloc>(context)
                      .add(TextChanged(
                          _prodNameController.text,
                          _priceController.text,
                          prodType == ProductType.fixed
                              ? "Fixed"
                              : "Negotiable",
                          _aboutProductController.text)),
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    filled: true,
                    contentPadding: const EdgeInsets.all(15),
                    fillColor: Colors.white.withOpacity(0.7),
                    border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    hintText: 'Product Name',
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                TextField(
                  controller: _priceController,
                  onChanged: (email) => BlocProvider.of<NewProductBloc>(context)
                      .add(TextChanged(
                          _prodNameController.text,
                          _priceController.text,
                          prodType == ProductType.fixed
                              ? "Fixed"
                              : "Negotiable",
                          _aboutProductController.text)),
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    filled: true,
                    prefixIcon: const Icon(Icons.currency_rupee),
                    contentPadding: const EdgeInsets.all(15),
                    fillColor: Colors.white.withOpacity(0.7),
                    border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    hintText: 'Price',
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                SizedBox(
                  height: 40,
                  width: 300,
                  child: Row(children: [
                    SizedBox(
                      width: 150,
                      child: ListTile(
                        contentPadding: const EdgeInsets.only(left: -10),
                        title: const Text(
                          'Negotiable',
                          style: TextStyle(color: Colors.black),
                        ),
                        leading: Radio<ProductType>(
                          fillColor: MaterialStateProperty.resolveWith<Color>(
                              (states) {
                            if (states.contains(MaterialState.disabled)) {
                              return AppColors.primary.withOpacity(0.3);
                            }
                            return AppColors.primary.withOpacity(0.8);
                          }),
                          value: ProductType.negotiable,
                          groupValue: prodType,
                          onChanged: (ProductType? value) {
                            setState(() {
                              prodType = value;
                            });
                          },
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 150,
                      child: ListTile(
                        contentPadding: const EdgeInsets.only(left: -15),
                        title: const Text('Fixed'),
                        leading: Radio<ProductType>(
                          fillColor: MaterialStateProperty.resolveWith<Color>(
                              (states) {
                            if (states.contains(MaterialState.disabled)) {
                              return AppColors.primary.withOpacity(0.3);
                            }
                            return AppColors.primary.withOpacity(0.8);
                          }),
                          value: ProductType.fixed,
                          groupValue: prodType,
                          onChanged: (ProductType? value) {
                            setState(() {
                              prodType = value;
                            });
                          },
                        ),
                      ),
                    ),
                  ]),
                ),
                const SizedBox(
                  height: 10,
                ),
                SizedBox(
                  height: 50,
                  child: SingleSelect(
                      choices: localStorage.services, selected: index),
                ),
                const SizedBox(
                  height: 10,
                ),
                TextField(
                  maxLength: 35,
                  controller: _aboutProductController,
                  onChanged: (email) => BlocProvider.of<NewProductBloc>(context)
                      .add(TextChanged(
                          _prodNameController.text,
                          _priceController.text,
                          prodType == ProductType.fixed
                              ? "Customization"
                              : "No Customization",
                          _aboutProductController.text)),
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    filled: true,
                    contentPadding: const EdgeInsets.all(15),
                    fillColor: Colors.white.withOpacity(0.7),
                    border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    hintText: 'About Product',
                  ),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: GestureDetector(
                    onTap: () async {
                      final img = await _picker.pickMultiImage();
                      BlocProvider.of<NewProductBloc>(context)
                          .add(ImageReceived(img));
                    },
                    child: BlocBuilder<NewProductBloc, NewProductState>(
                      builder: (context, state) {
                        return Container(
                          decoration: BoxDecoration(
                              color: state is ImageGetState
                                  ? Colors.transparent
                                  : AppColors.primary.withOpacity(0.4),
                              borderRadius: BorderRadius.circular(9)),
                          child: state is ImageGetState
                              ? SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Row(
                                    children: [
                                      ...List.generate(
                                        state.img!.length,
                                        (index) => Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: SizedBox(
                                            height: 150,
                                            width: 150,
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                              child: Image.file(
                                                File(state.img![index].path),
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              : SizedBox(
                                  height: 30,
                                  width: 140,
                                  child: Row(
                                    children: const [
                                      Icon(
                                        Icons.add_circle,
                                        color: Colors.white,
                                      ),
                                      Text(
                                        "Add Images",
                                        style: TextStyle(
                                            fontSize: 11,
                                            fontWeight: FontWeight.w500),
                                      )
                                    ],
                                  ),
                                ),
                        );
                      },
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: SizedBox(
                    height: 40,
                    width: double.maxFinite,
                    child: ElevatedButton(
                      key: const Key('loginForm_continue_raisedButton'),
                      style: ElevatedButton.styleFrom(
                        primary: Colors.transparent,
                        shadowColor: Colors.transparent,
                        onSurface: Colors.transparent,
                      ),
                      onPressed: () {
                        if (index == []) {
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content:
                                      Text('Please pick product category')));
                        } else {
                          BlocProvider.of<NewProductBloc>(context).add(
                              SubmittedEvent(
                                  _prodNameController.text,
                                  _aboutProductController.text,
                                  _priceController.text,
                                  prodType == ProductType.fixed
                                      ? "Customization"
                                      : "No Customization",
                                  localStorage.services[index[0]]));
                        }
                      },
                      child: Ink(
                          width: double.maxFinite,
                          decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Container(
                            height: 50,
                            width: 300,
                            alignment: Alignment.center,
                            child: BlocBuilder<NewProductBloc, NewProductState>(
                              builder: (context, state) {
                                if (state is LoadingState) {
                                  return const Center(
                                      child: CircularProgressIndicator());
                                }
                                return const Text(
                                  'ADD',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 18),
                                );
                              },
                            ),
                          )),
                    ),
                  ),
                ),
              ],
            ),
          ),
        )
      ]),
    );
  }
}

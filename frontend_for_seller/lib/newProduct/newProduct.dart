import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend_for_seller/newProduct/newProductForm.dart';

import 'bloc/new_product_bloc.dart';

class NewProduct extends StatefulWidget {
  const NewProduct({Key? key}) : super(key: key);

  @override
  State<NewProduct> createState() => _NewProductState();
}

class _NewProductState extends State<NewProduct> {
  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    return Container(
      height: h,
      width: w,
      decoration: const BoxDecoration(
        image: DecorationImage(image: AssetImage("assets/images/appbg.png")),
      ),
      child: Center(child: BlocBuilder<NewProductBloc, NewProductState>(
        builder: (context, state) {
          if (state is AddedState) {
            return const Text('Product Added Successfully');
          }
          return const ProductForm();
        },
      )),
    );
  }
}

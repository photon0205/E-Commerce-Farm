import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend_for_seller/components/product/bloc/product_bloc.dart';
import 'package:frontend_for_seller/constants/appColor.dart';
import 'package:frontend_for_seller/repositories/database_repository.dart';

import '../../models/product.dart';

enum ProductType { negotiable, fixed }

class ProductTile extends StatefulWidget {
  const ProductTile({Key? key, required this.product}) : super(key: key);
  final Product product;

  @override
  State<ProductTile> createState() => _ProductTileState();
}

class _ProductTileState extends State<ProductTile> {
  @override
  Widget build(BuildContext context) {
    ProductType? prodType = widget.product.type == "Negotiable"
        ? ProductType.negotiable
        : ProductType.fixed;
    return InkWell(
      onTap: () {
        showDialog(
            context: context,
            builder: (build) {
              final TextEditingController prodName =
                  TextEditingController(text: widget.product.name);
              final TextEditingController prodPrice =
                  TextEditingController(text: widget.product.price);
              final TextEditingController prodDescription =
                  TextEditingController(text: widget.product.description);
              final TextEditingController prodCategory =
                  TextEditingController(text: widget.product.category);
              return Dialog(
                backgroundColor: Colors.black,
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(12))),
                child: BlocListener<ProductBloc, ProductState>(
                  listener: (ncontext, state) {
                    if (state is ErrorState) {
                      ScaffoldMessenger.of(build)
                          .showSnackBar(SnackBar(content: Text(state.error)));
                    }
                  },
                  child: SingleChildScrollView(
                    child: SizedBox(
                      height: 600,
                      width: double.maxFinite,
                      child: Column(children: [
                        Container(
                          height: 50,
                          padding: const EdgeInsets.all(12),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              IconButton(
                                icon: const Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                ),
                                onPressed: () {
                                  showDialog(
                                      context: build,
                                      builder: (newContext) {
                                        return Dialog(
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8)),
                                          child: SizedBox(
                                            height: 300,
                                            child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  Container(
                                                    alignment:
                                                        Alignment.centerRight,
                                                    padding:
                                                        const EdgeInsets.only(
                                                            right: 10),
                                                    height: 50,
                                                    child: IconButton(
                                                      icon: const Icon(
                                                        Icons.cancel,
                                                        color: Colors.black,
                                                      ),
                                                      onPressed: () {
                                                        Navigator.of(newContext)
                                                            .pop();
                                                      },
                                                    ),
                                                  ),
                                                  Container(
                                                    alignment: Alignment.center,
                                                    height: 175,
                                                    child: const Text(
                                                      "ARE YOU SURE TO DELETE\n THIS PRODUCT?",
                                                      style: TextStyle(
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                      ),
                                                    ),
                                                  ),
                                                  Container(
                                                    height: 1,
                                                    color: Colors.black,
                                                  ),
                                                  SizedBox(
                                                    height: 74,
                                                    width: 312,
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        InkWell(
                                                          onTap: () {
                                                            Navigator.of(
                                                                    newContext)
                                                                .pop();
                                                          },
                                                          child: Container(
                                                            alignment: Alignment
                                                                .center,
                                                            width: 155.5,
                                                            height: 74,
                                                            decoration:
                                                                const BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius.only(
                                                                      bottomLeft:
                                                                          Radius.circular(
                                                                              8)),
                                                            ),
                                                            child: const Text(
                                                              "NO",
                                                              style: TextStyle(
                                                                fontSize: 18,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        Container(
                                                          width: 1,
                                                          color: Colors.black,
                                                        ),
                                                        InkWell(
                                                          onTap: () async {
                                                            await DatabaseService()
                                                                .deleteProduct(
                                                                    widget
                                                                        .product
                                                                        .id!);
                                                            Navigator.of(
                                                                    newContext)
                                                                .pop();
                                                          },
                                                          child: Container(
                                                            alignment: Alignment
                                                                .center,
                                                            height: 74,
                                                            width: 155,
                                                            decoration:
                                                                const BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius.only(
                                                                      bottomRight:
                                                                          Radius.circular(
                                                                              8)),
                                                            ),
                                                            child: const Text(
                                                              "YES",
                                                              style: TextStyle(
                                                                fontSize: 18,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ]),
                                          ),
                                        );
                                      });
                                },
                              ),
                              InkWell(
                                onTap: () => Navigator.pop(build),
                                child: Container(
                                  height: 27,
                                  width: 27,
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Color(0xff5DF12B),
                                  ),
                                  child: const Icon(Icons.arrow_back,
                                      color: Colors.black),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          height: 480,
                          width: double.maxFinite,
                          padding: const EdgeInsets.only(left: 20, right: 20),
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                Container(
                                  height: 220,
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                        image: NetworkImage(
                                            widget.product.imgUrls[0]),
                                        fit: BoxFit.cover),
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                ),
                                TextField(
                                  controller: prodName,
                                  onChanged: (e) {
                                    BlocProvider.of<ProductBloc>(build)
                                        .add(ProdChangedEvent(Product(
                                      name: prodName.text,
                                      description: prodDescription.text,
                                      type: prodType == ProductType.negotiable
                                          ? 'Negotiable'
                                          : 'Fixed',
                                      price: prodPrice.text,
                                      address: widget.product.address,
                                      category: widget.product.category,
                                      seller: widget.product.seller,
                                      imgUrls: widget.product.imgUrls,
                                      open: widget.product.open,
                                    )));
                                  },
                                  style: const TextStyle(
                                      fontSize: 18, color: Colors.white),
                                  decoration: const InputDecoration(
                                    contentPadding:
                                        EdgeInsets.only(left: 5, top: 8),
                                    enabledBorder: UnderlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Color(0xff2EA914)),
                                    ),
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Color(0xff2EA914)),
                                    ),
                                  ),
                                ),
                                TextField(
                                  onSubmitted: (e) {
                                    BlocProvider.of<ProductBloc>(build)
                                        .add(ProdChangedEvent(Product(
                                      name: prodName.text,
                                      description: prodDescription.text,
                                      type: prodType == ProductType.negotiable
                                          ? 'Negotiable'
                                          : 'Fixed',
                                      price: prodPrice.text,
                                      address: widget.product.address,
                                      category: widget.product.category,
                                      seller: widget.product.seller,
                                      imgUrls: widget.product.imgUrls,
                                      open: widget.product.open,
                                    )));
                                  },
                                  controller: prodPrice,
                                  style: const TextStyle(
                                      fontSize: 18, color: Colors.white),
                                  decoration: const InputDecoration(
                                    contentPadding:
                                        EdgeInsets.only(left: 5, top: 8),
                                    enabledBorder: UnderlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Color(0xff2EA914)),
                                    ),
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Color(0xff2EA914)),
                                    ),
                                  ),
                                ),
                                TextField(
                                  onSubmitted: (e) {
                                    BlocProvider.of<ProductBloc>(build)
                                        .add(ProdChangedEvent(Product(
                                      name: prodName.text,
                                      description: prodDescription.text,
                                      type: prodType == ProductType.negotiable
                                          ? 'Negotiable'
                                          : 'Fixed',
                                      price: prodPrice.text,
                                      address: widget.product.address,
                                      category: widget.product.category,
                                      seller: widget.product.seller,
                                      imgUrls: widget.product.imgUrls,
                                      open: widget.product.open,
                                    )));
                                  },
                                  controller: prodDescription,
                                  style: const TextStyle(
                                      fontSize: 18, color: Colors.white),
                                  decoration: const InputDecoration(
                                    contentPadding:
                                        EdgeInsets.only(left: 5, top: 8),
                                    enabledBorder: UnderlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Color(0xff2EA914)),
                                    ),
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Color(0xff2EA914)),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 40,
                                  child: Row(children: [
                                    SizedBox(
                                      width: 140,
                                      child: ListTile(
                                        contentPadding:
                                            const EdgeInsets.only(left: -10),
                                        title: const Text(
                                          'Negotiable',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 15),
                                        ),
                                        leading: Radio<ProductType>(
                                          fillColor: MaterialStateProperty
                                              .resolveWith<Color>((states) {
                                            if (states.contains(
                                                MaterialState.disabled)) {
                                              return AppColors.primary
                                                  .withOpacity(0.3);
                                            }
                                            return AppColors.primary
                                                .withOpacity(0.8);
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
                                      width: 125,
                                      child: ListTile(
                                        contentPadding:
                                            const EdgeInsets.only(left: -15),
                                        title: const Text(
                                          'Fixed',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 15),
                                        ),
                                        leading: Radio<ProductType>(
                                          fillColor: MaterialStateProperty
                                              .resolveWith<Color>((states) {
                                            if (states.contains(
                                                MaterialState.disabled)) {
                                              return AppColors.primary
                                                  .withOpacity(0.3);
                                            }
                                            return AppColors.primary
                                                .withOpacity(0.8);
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
                                TextField(
                                  controller: prodCategory,
                                  readOnly: true,
                                  style: const TextStyle(
                                      fontSize: 18, color: Colors.white),
                                  decoration: const InputDecoration(
                                    contentPadding:
                                        EdgeInsets.only(left: 5, top: 8),
                                    enabledBorder: UnderlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Color(0xff2EA914)),
                                    ),
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Color(0xff2EA914)),
                                    ),
                                  ),
                                ),
                                Container(
                                  alignment: Alignment.centerLeft,
                                  child: SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        ...List.generate(
                                          widget.product.imgUrls.length,
                                          (index) => Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: SizedBox(
                                              height: 150,
                                              width: 150,
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                                child: Image.network(widget
                                                    .product.imgUrls[index]),
                                              ),
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            BlocProvider.of<ProductBloc>(build)
                                .add(ProductSubmittedEvent(Product(
                              name: prodName.text,
                              description: prodDescription.text,
                              type: prodType == ProductType.negotiable
                                  ? 'Negotiable'
                                  : 'Fixed',
                              price: prodPrice.text,
                              address: widget.product.address,
                              category: widget.product.category,
                              seller: widget.product.seller,
                              imgUrls: widget.product.imgUrls,
                              open: widget.product.open,
                              id: widget.product.id,
                            )));
                            ScaffoldMessenger.of(build)
                                .showSnackBar(const SnackBar(
                              content: Text("Product Updated Successfully"),
                            ));
                            Navigator.pop(build);
                          },
                          child: Container(
                            alignment: Alignment.center,
                            height: 70,
                            decoration:
                                const BoxDecoration(color: Color(0xff39C61C)),
                            child: const Text(
                              "SAVE CHANGES",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        )
                      ]),
                    ),
                  ),
                ),
              );
            });
      },
      child: Container(
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                  height: 200,
                  width: double.maxFinite,
                  child: Image.network(
                    widget.product.imgUrls[0],
                    fit: BoxFit.fitWidth,
                  )),
              Container(
                padding: const EdgeInsets.only(left: 10, top: 5),
                alignment: Alignment.centerLeft,
                child: Text(
                  widget.product.name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.only(left: 12, top: 5),
                alignment: Alignment.centerLeft,
                child: Text(
                  '₹ ${widget.product.price}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          )),
    );
  }
}

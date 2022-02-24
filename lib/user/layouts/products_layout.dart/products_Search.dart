import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pazar/admin/models/product_model.dart';
import 'package:pazar/shared/components/components.dart';
import 'package:pazar/shared/components/constants.dart';
import 'package:pazar/shared/styles/colors.dart';
import 'package:pazar/user/layouts/home_layout/home_layout.dart';
import 'package:pazar/user/layouts/products_layout.dart/product_details.dart';
import 'package:pazar/user/layouts/products_layout.dart/products_screen.dart';
import 'package:pazar/user/users_cubit/user_cubit.dart';
import 'package:pazar/user/users_cubit/user_states.dart';

class SearchProducts extends StatelessWidget {
  TextEditingController searchText = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<UserCubits, UserStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var cubit = UserCubits().get(context);
        return Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: Text(
              'Search Products',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            leading: IconButton(
                onPressed: () {
                  navigateTo(context, HomeLayout());
                  searchText.text = '';
                },
                icon: Icon(
                  Icons.arrow_back,
                )),
          ),
          body: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                defaultTextField(
                    onChange: (value) {
                      cubit.searchProducts(value);
                    },
                    type: TextInputType.emailAddress,
                    validate: (value) {
                      if (value.toString().isEmpty) {
                        return 'please enter text for search';
                      }
                      return null;
                    },
                    controller: searchText,
                    hintText: 'Search Products',
                    prefixIcon: Icons.search,
                    iconColor: defaultColor,
                    borderColor: defaultColor),
                SizedBox(
                  height: 20,
                ),
                searchText.text == '' || cubit.productsResult!.length == 0
                    ? Expanded(
                        child: ListView.separated(
                            itemBuilder: (context, ind) {
                              return buildSearchProduct(
                                  context, cubit.allProducts![ind], ind);
                            },
                            separatorBuilder: (context, ind) => SizedBox(
                                  height: 20,
                                ),
                            itemCount: cubit.allProducts!.length))
                    : Expanded(
                        child: ListView.separated(
                            itemBuilder: (context, index) {
                              return buildSearchProduct(
                                  context, cubit.productsResult![index], index);
                            },
                            separatorBuilder: (context, index) => SizedBox(
                                  height: 20,
                                ),
                            itemCount: cubit.productsResult!.length))
              ],
            ),
          ),
        );
      },
    );
  }

  Widget buildSearchProduct(context, ProductModel productModel, index) {
    var userCubit = UserCubits().get(context);
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            height: MediaQuery.of(context).size.height * 0.2,
            child: InkWell(
              onTap: () {
                navigateTo(
                    context,
                    ProductDetails(
                      productModel,
                      userCubit.favID![index],
                      index,
                    ));
              },
              child: Card(
                clipBehavior: Clip.antiAliasWithSaveLayer,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRect(
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      child: Image(
                        height: MediaQuery.of(context).size.height * 0.2,
                        image: NetworkImage('${productModel.image}'),
                        width: MediaQuery.of(context).size.width * 0.35,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Expanded(
                      child: Container(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10.0, vertical: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${productModel.name}',
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                '${productModel.description}',
                                style: TextStyle(
                                    fontSize: 14, color: Colors.black54),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                              ),
                              Spacer(),
                              Row(
                                children: [
                                  Text(
                                    '${productModel.price}\$',
                                    style: TextStyle(
                                        fontSize: 14, color: defaultColor),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 2,
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  if (productModel.discount != 0)
                                    Text(
                                      '500\$',
                                      style: TextStyle(
                                          fontSize: 10,
                                          color: Colors.grey,
                                          decoration:
                                              TextDecoration.lineThrough),
                                    ),
                                  Spacer(),
                                  InkWell(
                                    onTap: () {
                                      print(index);

                                      if (searchText.text == '') {
                                        userCubit.handleFavProducts(
                                            userCubit.productID[index]);
                                      } else {
                                        userCubit.handleFavProducts(
                                            userCubit.productsResultID![index]);
                                      }
                                    },
                                    child: Container(
                                      child: CircleAvatar(
                                        child: productModel
                                                    .favourites![userID] !=
                                                true
                                            ? Icon(
                                                Icons.favorite_outline_outlined,
                                                color: Colors.grey,
                                              )
                                            : Icon(
                                                Icons.favorite_outlined,
                                                color: Colors.red,
                                              ),
                                        backgroundColor: Colors.white,
                                      ),
                                    ),
                                  ),
                                ],
                              ),

                              // defaultButton(
                              //   height: 20,
                              //   textColor: Colors.white,
                              //   function: () {},
                              //   background: defaultColor,
                              //   text: 'Add to cart',
                              // )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:pazar/admin/models/product_model.dart';
import 'package:pazar/shared/components/components.dart';
import 'package:pazar/shared/components/constants.dart';
import 'package:pazar/shared/styles/colors.dart';
import 'package:pazar/user/users_cubit/user_cubit.dart';
import 'package:pazar/user/users_cubit/user_states.dart';

class ProductDetails extends StatelessWidget {
  ProductModel? model;
  int index;
  String productId;
  ProductDetails(this.model, this.productId, this.index);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<UserCubits, UserStates>(
      listener: (context, state) {
        if (state is UserUpdateCartProductsSuccessStates) {
          showToast(text: 'Added Successfully', states: ToastStates.SUCCESS);
        }
        if (state is UserUpdateCartProductsErrorStates) {
          showToast(text: 'an error occured', states: ToastStates.SUCCESS);
        }
      },
      builder: (context, state) {
        var userCubit = UserCubits().get(context);
        return Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: Text(
              '${model!.name}',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  children: [
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      width: double.infinity,
                      height: 250,
                      child: Center(
                        child: Stack(
                          alignment: AlignmentDirectional.bottomEnd,
                          children: [
                            Hero(
                              tag: productId,
                              child:
                                  Image(image: NetworkImage('${model!.image}')),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(right: 15, bottom: 10),
                              child: InkWell(
                                onTap: () {
                                  userCubit.handleFavProducts(productId);
                                },
                                child: Container(
                                  child: CircleAvatar(
                                    child: userCubit.allProducts![index]
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
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),

                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  '${model!.name}',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              Spacer(),
                              Text(
                                '${model!.price}\$',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Text(
                            'Description',
                            style: TextStyle(
                                color: defaultColor,
                                fontSize: 22,
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            '${model!.description}',
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 14,
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 20),
                    child: defaultButton(
                      function: () {
                        userCubit.handleCartProducts(productId);
                      },
                      text: userCubit.allProducts![index].carts![userID] != true
                          ? 'ADD TO CART'
                          : 'REMOVE FROM CART',
                      background: defaultColor,
                      textColor: Colors.white,
                    ),
                  ),
                ),
                // Container(
                //   width: double.infinity,
                //   decoration: BoxDecoration(
                //     borderRadius: BorderRadius.circular(25),
                //     color: Colors.red,
                //   ),
                //   child: MaterialButton(
                //       onPressed: () {},
                //       child: Text(
                //         'ADD TO CART',
                //         style: TextStyle(color: Colors.white, fontSize: 18),
                //       )),
                // ),
              ],
            ),
          ),
        );
      },
    );
  }
}

import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pazar/admin/models/product_model.dart';
import 'package:pazar/shared/components/components.dart';
import 'package:pazar/shared/components/constants.dart';
import 'package:pazar/shared/styles/colors.dart';
import 'package:pazar/user/layouts/favourites_layout.dart/favourite_search.dart';
import 'package:pazar/user/layouts/products_layout.dart/product_details.dart';
import 'package:pazar/user/modules/drawer/user_drawer.dart';
import 'package:pazar/user/users_cubit/user_cubit.dart';
import 'package:pazar/user/users_cubit/user_states.dart';

class FavouriteScreen extends StatelessWidget {
  const FavouriteScreen({Key? key}) : super(key: key);

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
                'Favourites',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              actions: [
                InkWell(
                  onTap: () {
                    navigateTo(context, SearchFavouriteProducts());
                  },
                  child: Icon(
                    Icons.search,
                    color: Colors.black,
                    size: 32,
                  ),
                ),
                SizedBox(
                  width: 20,
                )
              ],
            ),
            backgroundColor: Colors.grey[100],
            drawer: UserSideDrawer(),
            body: cubit.allFavourites!.length != 0
                ? ConditionalBuilder(
                    condition: state is! UserGetFavProductsLoadingStates,
                    builder: (context) {
                      return Column(
                        children: [
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.05,
                          ),
                          Expanded(
                            child: ListView.separated(
                                itemBuilder: (context, index) =>
                                    buildProductItem(context,
                                        cubit.allFavourites![index], index),
                                separatorBuilder: (context, index) => SizedBox(
                                      height: 5,
                                    ),
                                itemCount: cubit.allFavourites!.length),
                          ),
                        ],
                      );
                    },
                    fallback: (context) => Center(
                      child: CircularProgressIndicator(
                        color: defaultColor,
                      ),
                    ),
                  )
                : Center(
                    child: Text(
                    'No favourite product added yet',
                    style: TextStyle(fontSize: 20),
                  )));
      },
    );
  }

  Widget buildProductItem(context, ProductModel productModel, index) {
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
                                      userCubit.removeFromFav(
                                          userCubit.favID![index]);
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

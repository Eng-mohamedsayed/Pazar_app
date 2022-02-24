import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:pazar/admin/models/product_model.dart';
import 'package:pazar/shared/components/components.dart';
import 'package:pazar/shared/components/constants.dart';
import 'package:pazar/shared/styles/colors.dart';
import 'package:pazar/user/users_cubit/user_cubit.dart';
import 'package:pazar/user/users_cubit/user_states.dart';

class CategoriesDetails extends StatelessWidget {
  final String categoryName;
  CategoriesDetails(this.categoryName);
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<UserCubits, UserStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var cubit = UserCubits().get(context);
        return Scaffold(
            backgroundColor: Colors.grey[100],
            appBar: AppBar(
              centerTitle: true,
              title: Text(
                '${categoryName}',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            body: cubit.productCategories!.length > 0
                ? ConditionalBuilder(
                    condition: state is! UserGetProductsOfCategoryLoadingStates,
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
                                        cubit.productCategories![index], index),
                                separatorBuilder: (context, index) => SizedBox(
                                      height: 5,
                                    ),
                                itemCount: cubit.productCategories!.length),
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
                      'Products Added Soon',
                      style: TextStyle(fontSize: 20),
                    ),
                  ));
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
                                        decoration: TextDecoration.lineThrough),
                                  ),
                                Spacer(),
                                InkWell(
                                  onTap: () {
                                    userCubit.handleFavProducts(
                                        userCubit.productCategoriesID![index]);
                                  },
                                  child: Container(
                                    child: CircleAvatar(
                                      child: productModel.favourites![userID] !=
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
        ],
      ),
    );
  }
}

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:conditional_builder/conditional_builder.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:pazar/admin/models/category_model.dart';
import 'package:pazar/admin/models/product_model.dart';
import 'package:pazar/shared/components/components.dart';
import 'package:pazar/shared/components/constants.dart';
import 'package:pazar/shared/network/local/cashe_helper.dart';
import 'package:pazar/shared/styles/colors.dart';
import 'package:pazar/user/layouts/categories_layout.dart/specfic_category.dart';
import 'package:pazar/user/layouts/products_layout.dart/product_details.dart';
import 'package:pazar/user/layouts/products_layout.dart/products_Search.dart';
import 'package:pazar/user/modules/drawer/user_drawer.dart';
import 'package:pazar/user/modules/login/login_screen.dart';
import 'package:pazar/user/users_cubit/user_cubit.dart';
import 'package:pazar/user/users_cubit/user_states.dart';

class ProductsScreen extends StatelessWidget {
  List<AssetImage> banners = [
    AssetImage('assets/images/banner1.jpeg'),
    AssetImage('assets/images/banner2.jpeg'),
    AssetImage('assets/images/banner3.jpeg'),
    AssetImage('assets/images/banner4.jpeg'),
  ];

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<UserCubits, UserStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var cubit = UserCubits().get(context);

        return ConditionalBuilder(
          condition: cubit.allProducts!.length > 0 &&
              cubit.allCategories!.length > 0 &&
              state is! UserGetAllCategoriesLoadingStates &&
              state is! UserGetAllProductsLoadingStates,
          builder: (context) => Scaffold(
            appBar: AppBar(
              centerTitle: true,
              title: Text(
                'DISCOVERY',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              actions: [
                InkWell(
                  onTap: () {
                    navigateTo(context, SearchProducts());
                  },
                  child: Icon(
                    Icons.search_outlined,
                    color: Colors.black,
                    size: 32,
                  ),
                ),
                SizedBox(
                  width: 15,
                )
              ],
            ),
            drawer: UserSideDrawer(),
            body: productBuilder(context, cubit.allProducts),
          ),
          fallback: (context) => Center(
            child: CircularProgressIndicator(
              color: defaultColor,
            ),
          ),
        );
      },
    );
  }

  Widget productBuilder(context, List<ProductModel>? productModel) {
    var userCubit = UserCubits().get(context);

    int? discount;
    int? oldPrice;
    double? offer;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CarouselSlider(
              items: List.generate(banners.length, (index) {
                return Image(
                  image: banners[index],
                  fit: BoxFit.cover,
                  width: double.infinity,
                );
              }),
              options: CarouselOptions(
                height: 250,
                initialPage: 0,
                enableInfiniteScroll: true,
                reverse: false,
                viewportFraction: 1,
                autoPlay: true,
                autoPlayInterval: Duration(seconds: 3),
                autoPlayAnimationDuration: Duration(seconds: 1),
                autoPlayCurve: Curves.fastOutSlowIn,
                scrollDirection: Axis.horizontal,
              )),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Categories',
                  style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: defaultColor),
                ),
                SizedBox(
                  height: 15,
                ),
                Container(
                  height: 40,
                  child: ListView.separated(
                    itemBuilder: (context, index) => buildCategoriesItem(
                        context, userCubit.allCategories![index], index),
                    separatorBuilder: (context, index) => SizedBox(
                      width: 10,
                    ),
                    itemCount: userCubit.allCategories!.length,
                    scrollDirection: Axis.horizontal,
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                Text(
                  'Products',
                  style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: defaultColor),
                ),
                SizedBox(
                  height: 15,
                ),
                GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  mainAxisSpacing: 1,
                  crossAxisSpacing: 10,
                  childAspectRatio: 1 / 1.85,
                  children:
                      List.generate(userCubit.allProducts!.length, (index) {
                    discount = userCubit.allProducts![index].discount;
                    oldPrice = userCubit.allProducts![index].oldPrice;
                    offer = ((discount!.round() / oldPrice!.round()) * 100);
                    return Container(
                      color: Colors.white,
                      child: InkWell(
                        onTap: () {
                          navigateTo(
                              context,
                              ProductDetails(
                                productModel![index],
                                userCubit.productID[index],
                                index,
                              ));
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Stack(
                              alignment: AlignmentDirectional.topStart,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 0.0),
                                  child: Hero(
                                    tag: userCubit.productID[index],
                                    child: CachedNetworkImage(
                                      imageUrl: '${productModel![index].image}',
                                      imageBuilder: (context, imageProvider) =>
                                          ClipRRect(
                                        borderRadius: BorderRadius.circular(20),
                                        child: Image(
                                          height: 160,
                                          width: double.infinity,
                                          image: imageProvider,
                                          fit: BoxFit.fill,
                                        ),
                                      )
                                      //     Container(
                                      //   width: double.infinity,
                                      //   height: 180.0,
                                      //   decoration: BoxDecoration(
                                      //     borderRadius:
                                      //         BorderRadius.circular(10),
                                      //     color: Colors.red,
                                      //     image: DecorationImage(
                                      //       //fit: BoxFit.cover,
                                      //       image: imageProvider,

                                      //     ),
                                      //   ),
                                      // ),
                                      ,
                                      placeholder: (context, url) =>
                                          CircularProgressIndicator(
                                              color: defaultColor),
                                      errorWidget: (context, url, error) =>
                                          Icon(Icons.error),
                                    ),
                                  ),
                                  //  Container(
                                  //   width: double.infinity,
                                  //   height: 180,
                                  //   decoration: BoxDecoration(
                                  //     borderRadius: BorderRadius.circular(10),
                                  //     color: Colors.red,
                                  //     image: DecorationImage(
                                  //       fit: BoxFit.cover,
                                  //       image: NetworkImage(
                                  //           '${productModel![index].image}'),
                                  //     ),
                                  //   ),
                                  // )
                                ),
                                if (productModel[index].discount != 0)
                                  Positioned(
                                    bottom: 135,
                                    left: 8,
                                    child: Container(
                                      decoration: BoxDecoration(
                                          color: Colors.red,
                                          borderRadius:
                                              BorderRadius.circular(20)),
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 4,
                                      ),
                                      child: Text(
                                        '-${offer!.round()}%',
                                        style: TextStyle(
                                            fontSize: 16, color: Colors.white),
                                      ),
                                    ),
                                  ),
                                Positioned(
                                  bottom: 0,
                                  right: 0,
                                  child: InkWell(
                                    onTap: () {
                                      userCubit.handleFavProducts(
                                          userCubit.productID[index]);
                                    },
                                    child: Container(
                                      child: CircleAvatar(
                                        child: productModel[index]
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
                            Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '${productModel[index].name}',
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        fontSize: 18,
                                        height: 1.3,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    '${productModel[index].description}',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        fontSize: 12,
                                        height: 1.3,
                                        color: Colors.grey),
                                  ),
                                  SizedBox(height: 5),
                                  Row(
                                    children: [
                                      Text(
                                        '${productModel[index].price}\$',
                                        style: TextStyle(
                                            fontSize: 12, color: defaultColor),
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      productModel[index].discount != 0
                                          ? Text(
                                              '${productModel[index].oldPrice}\$',
                                              style: TextStyle(
                                                  fontSize: 10,
                                                  color: Colors.grey,
                                                  decoration: TextDecoration
                                                      .lineThrough),
                                            )
                                          : Text(''),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildCategoriesItem(context, CategoryModel model, index) {
    var cubit = UserCubits().get(context);
    return InkWell(
      onTap: () {
        cubit.getPeoductsOfCtegory(cubit.catID[index]);
        navigateTo(context, CategoriesDetails(model.name.toString()));
      },
      child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.black.withOpacity(0.8),
          ),
          child: Center(
              child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Text(
              '${model.name!.toUpperCase()}',
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w500),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ))),
    );
  }
}

import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:pazar/admin/models/product_model.dart';
import 'package:pazar/shared/components/components.dart';
import 'package:pazar/shared/components/constants.dart';
import 'package:pazar/shared/styles/colors.dart';
import 'package:pazar/user/layouts/card_layout.dart/carts_search.dart';
import 'package:pazar/user/layouts/orders_layout/orders_screen.dart';
import 'package:pazar/user/modules/drawer/user_drawer.dart';
import 'package:pazar/user/users_cubit/user_cubit.dart';
import 'package:pazar/user/users_cubit/user_states.dart';

class CardsScreen extends StatelessWidget {
  const CardsScreen({Key? key}) : super(key: key);

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
                'Carts',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              actions: [
                InkWell(
                  onTap: () {
                    navigateTo(context, CartsSearch());
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
            body: cubit.allCarts!.length != 0
                ? ConditionalBuilder(
                    condition: state is! UserGetCartsProductsLoadingStates,
                    builder: (context) {
                      return Column(
                        children: [
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.05,
                          ),
                          Expanded(
                            child: ListView.separated(
                                itemBuilder: (context, index) =>
                                    buildProductItem(
                                        context, cubit.allCarts![index], index),
                                separatorBuilder: (context, index) => SizedBox(
                                      height: 5,
                                    ),
                                itemCount: cubit.allCarts!.length),
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
                    'No Carts added yet',
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
            height: MediaQuery.of(context).size.height * 0.24,
            child: Card(
              clipBehavior: Clip.antiAliasWithSaveLayer,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRect(
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    child: Image(
                      height: MediaQuery.of(context).size.height * 0.24,
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
                            SizedBox(
                              height: 10,
                            ),
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
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: [
                                OutlineButton(
                                  onPressed: () {
                                    navigateTo(
                                        context,
                                        OrderScreen(productModel,
                                            userCubit.cartID![index]));
                                  },
                                  child: Text('Order now'),
                                  textColor: Colors.red,
                                  padding: EdgeInsets.zero,
                                  borderSide: BorderSide(color: Colors.red),
                                ),
                                Spacer(),
                                InkWell(
                                  onTap: () {
                                    userCubit.removeFromCart(
                                        userCubit.cartID![index]);
                                  },
                                  child: Container(
                                    child: CircleAvatar(
                                      child: Icon(
                                        MdiIcons.cartRemove,
                                        color: Colors.red,
                                      ),
                                      backgroundColor: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            )
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

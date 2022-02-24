import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:pazar/admin/models/product_model.dart';
import 'package:pazar/shared/components/components.dart';
import 'package:pazar/shared/styles/colors.dart';
import 'package:pazar/user/layouts/home_layout/home_layout.dart';
import 'package:pazar/user/layouts/products_layout.dart/product_details.dart';
import 'package:pazar/user/users_cubit/user_cubit.dart';
import 'package:pazar/user/users_cubit/user_states.dart';

class CartsSearch extends StatelessWidget {
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
                      cubit.searchCartProducts(value);
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
                searchText.text == '' || cubit.cartProductsResult!.length == 0
                    ? Expanded(
                        child: ListView.separated(
                            itemBuilder: (context, index) {
                              return buildProductItem(
                                  context, cubit.allCarts![index], index);
                            },
                            separatorBuilder: (context, index) => SizedBox(
                                  height: 20,
                                ),
                            itemCount: cubit.allCarts!.length))
                    : Expanded(
                        child: ListView.separated(
                            itemBuilder: (context, index) {
                              return buildProductItem(context,
                                  cubit.cartProductsResult![index], index);
                            },
                            separatorBuilder: (context, index) => SizedBox(
                                  height: 20,
                                ),
                            itemCount: cubit.cartProductsResult!.length))
              ],
            ),
          ),
        );
      },
    );
  }

  Widget buildProductItem(context, ProductModel productModel, index) {
    var userCubit = UserCubits().get(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          height: MediaQuery.of(context).size.height * 0.22,
          child: Card(
            clipBehavior: Clip.antiAliasWithSaveLayer,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRect(
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  child: Image(
                    height: MediaQuery.of(context).size.height * 0.22,
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
                            style:
                                TextStyle(fontSize: 14, color: Colors.black54),
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
                                onPressed: () {},
                                child: Text('Order now'),
                                textColor: Colors.red,
                                padding: EdgeInsets.zero,
                                borderSide: BorderSide(color: Colors.red),
                              ),
                              Spacer(),
                              InkWell(
                                onTap: () {
                                  userCubit
                                      .removeFromCart(userCubit.cartID![index]);
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
    );
  }
}

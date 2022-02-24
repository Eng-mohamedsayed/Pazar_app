import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:pazar/admin/models/category_model.dart';
import 'package:pazar/admin/models/product_model.dart';
import 'package:pazar/shared/components/components.dart';
import 'package:pazar/shared/components/constants.dart';
import 'package:pazar/shared/styles/colors.dart';
import 'package:pazar/user/layouts/categories_layout.dart/specfic_category.dart';
import 'package:pazar/user/layouts/home_layout/home_layout.dart';
import 'package:pazar/user/layouts/products_layout.dart/product_details.dart';
import 'package:pazar/user/users_cubit/user_cubit.dart';
import 'package:pazar/user/users_cubit/user_states.dart';

class SearchCategory extends StatelessWidget {
  TextEditingController searchText = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<UserCubits, UserStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var cubit = UserCubits().get(context);
        return Scaffold(
          backgroundColor: Colors.grey[200],
          appBar: AppBar(
            centerTitle: true,
            title: Text(
              'Search Categories',
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
                      cubit.searchCategories(value);
                    },
                    type: TextInputType.emailAddress,
                    validate: (value) {
                      if (value.toString().isEmpty) {
                        return 'please enter text for search';
                      }
                      return null;
                    },
                    controller: searchText,
                    hintText: 'Search Categories',
                    prefixIcon: Icons.search,
                    iconColor: defaultColor,
                    borderColor: defaultColor),
                SizedBox(
                  height: 20,
                ),
                searchText.text == '' || cubit.categoriesResult!.length == 0
                    ? Expanded(
                        child: ListView.separated(
                            itemBuilder: (context, index) {
                              return buildSearchCategory(
                                  context, cubit.allCategories![index], index);
                            },
                            separatorBuilder: (context, index) => SizedBox(
                                  height: 20,
                                ),
                            itemCount: cubit.allCategories!.length))
                    : Expanded(
                        child: ListView.separated(
                            itemBuilder: (context, index) {
                              return buildSearchCategory(context,
                                  cubit.categoriesResult![index], index);
                            },
                            separatorBuilder: (context, index) => SizedBox(
                                  height: 20,
                                ),
                            itemCount: cubit.categoriesResult!.length))
              ],
            ),
          ),
        );
      },
    );
  }

  Widget buildSearchCategory(context, CategoryModel model, index) {
    var cubit = UserCubits().get(context);

    String? formattedDate =
        DateFormat('yyyy-MM-dd').format(DateTime.parse(model.dateTime!));
    var bottomSheetController;

    return Container(
        margin: EdgeInsets.symmetric(horizontal: 10),
        child: Container(
          height: 120,
          child: ClipRRect(
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(20),
                bottomRight: Radius.circular(20)),
            child: InkWell(
              onTap: () {
                navigateTo(context, CategoriesDetails(model.name.toString()));
              },
              child: Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(8.0))),
                child: Row(
                  children: [
                    Expanded(
                        child: Padding(
                      padding: const EdgeInsets.only(left: 20),
                      child: Text(
                        '${model.name}',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w800),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    )),
                    CachedNetworkImage(
                      imageUrl: '${model.image}',
                      imageBuilder: (context, imageProvider) => Container(
                        width: 160.0,
                        height: 120.0,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                              image: imageProvider, fit: BoxFit.cover),
                        ),
                      ),
                      placeholder: (context, url) => Center(
                          child: CircularProgressIndicator(
                        color: defaultColor,
                      )),
                      errorWidget: (context, url, error) => Icon(Icons.error),
                    ),
                    // Image(
                    //   fit: BoxFit.cover,
                    //   width: 160,
                    //   height:120,
                    //   image: NetworkImage('${model.image}')
                    //   )
                  ],
                ),
              ),
            ),
          ),
        ));
  }
}

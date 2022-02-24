import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:pazar/admin/categories/edit_categories.dart';
import 'package:pazar/admin/models/category_model.dart';
import 'package:pazar/shared/components/components.dart';
import 'package:pazar/shared/styles/colors.dart';
import 'package:pazar/user/layouts/categories_layout.dart/category_search.dart';
import 'package:pazar/user/layouts/categories_layout.dart/specfic_category.dart';
import 'package:pazar/user/modules/drawer/user_drawer.dart';
import 'package:pazar/user/users_cubit/user_cubit.dart';
import 'package:pazar/user/users_cubit/user_states.dart';

class CategorisScreen extends StatelessWidget {
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
                'Categories',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              actions: [
                InkWell(
                  onTap: () {
                    navigateTo(context, SearchCategory());
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
            drawer: UserSideDrawer(),
            body: ConditionalBuilder(
                condition: state is! UserGetAllCategoriesLoadingStates &&
                    cubit.allCategories!.length > 0,
                builder: (context) => Column(
                      children: [
                        SizedBox(
                          height: 20,
                        ),
                        Expanded(
                          child: ListView.separated(
                              itemBuilder: (context, index) {
                                var catModel = cubit.allCategories![index];
                                return InkWell(
                                  onTap: () {
                                    cubit.getPeoductsOfCtegory(
                                        cubit.catID[index]);
                                    navigateTo(
                                        context,
                                        CategoriesDetails(
                                            catModel.name.toString()));
                                  },
                                  child: buildCategoryItems(
                                      catModel, context, cubit.catID[index]),
                                );
                              },
                              separatorBuilder: (context, index) => SizedBox(
                                    height: 5,
                                  ),
                              itemCount: cubit.allCategories!.length),
                        ),
                      ],
                    ),
                fallback: (context) => Center(
                      child: CircularProgressIndicator(),
                    )));
      },
    );
  }

  Widget buildCategoryItems(CategoryModel model, context, String catID) {
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
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
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
        ));
  }
}

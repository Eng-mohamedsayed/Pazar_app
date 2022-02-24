import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:pazar/admin/admin_panel.dart/drawer.dart';
import 'package:pazar/admin/categories/add_category.dart';
import 'package:pazar/admin/categories/all_categories.dart';
import 'package:pazar/admin/products/add_products.dart';
import 'package:pazar/admin/products/delete_products.dart';
import 'package:pazar/admin/products/edit_products.dart';
import 'package:pazar/admin/products/see_all_products.dart';
import 'package:pazar/shared/components/components.dart';
import 'package:pazar/shared/styles/colors.dart';

class ProductLayout extends StatelessWidget {
  List<GridModel> list = [
    GridModel(title: 'Add Products', count: 10, icon: MdiIcons.shapeCirclePlus),
    GridModel(
        title: 'Edit Products', count: 4, icon: MdiIcons.circleEditOutline),
    GridModel(title: 'Delete Products', count: 150, icon: MdiIcons.delete),
    GridModel(
        title: 'See All Products', count: 38, icon: MdiIcons.shoppingOutline),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            'Manage Products',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        drawer: SideDrawer(),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              GridView.count(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  mainAxisSpacing: 1,
                  crossAxisSpacing: 1,
                  childAspectRatio: 1 / 1.6,
                  children: List.generate(
                      list.length,
                      (index) => InkWell(
                          onTap: () {
                            if (list[index].title == 'Add Products') {
                              navigateTo(context, AddProducts());
                            } else if (list[index].title == 'Edit Products') {
                              navigateTo(context, AllProducts());
                            } else if (list[index].title == 'Delete Products') {
                              navigateTo(context, AllProducts());
                            } else {
                              navigateTo(context, AllProducts());
                            }
                          },
                          child: buildGridItem(list[index])))),
            ],
          ),
        ));
  }

  Widget buildGridItem(GridModel model) {
    return Card(
        elevation: 5,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              model.icon,
              color: defaultColor,
              size: 34,
            ),
            SizedBox(
              height: 15,
            ),
            Text(
              '${model.title}',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ],
        ));
  }
}

class GridModel {
  String? title;
  int? count;
  IconData? icon;
  GridModel({
    this.title,
    this.icon,
    this.count,
  });
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:pazar/admin/admin_cubit/admin_cubits.dart';
import 'package:pazar/admin/admin_cubit/admin_states.dart';
import 'package:pazar/admin/admin_panel.dart/drawer.dart';
import 'package:pazar/shared/styles/colors.dart';
import 'package:pazar/user/users_cubit/user_cubit.dart';

class AdminPanel extends StatelessWidget {
  GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AdminCubits, AdminStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var adminCubits = AdminCubits.get(context);
        int productsCount = adminCubits.allProducts!.length;
        int categoriesCount = adminCubits.allCategory!.length;
        int usersCount = adminCubits.allUsers!.length;
        int orderCount = adminCubits.allOrders!.length;

        List<GridModel> list = [
          GridModel(title: 'Users', count: usersCount, icon: Icons.person),
          GridModel(
              title: 'Categories',
              count: categoriesCount,
              icon: Icons.category),
          GridModel(
              title: 'Products',
              count: productsCount,
              icon: Icons.card_giftcard),
          GridModel(
              title: 'Orders', count: orderCount, icon: MdiIcons.cartOutline),
        ];
        return Scaffold(
            key: scaffoldKey,
            appBar: AppBar(
              centerTitle: true,
              title: Text(
                'ADMIN HOME',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            drawer: SideDrawer(),
            body: SingleChildScrollView(
              child: Padding(
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
                        children: List.generate(list.length,
                            (index) => buildGridItem(list[index], context))),
                  ],
                ),
              ),
            ));
      },
    );
  }

  Widget buildGridItem(GridModel model, context) {
    var adminCubits = AdminCubits.get(context);
    return Card(
      elevation: 5,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                model.icon,
                color: defaultColor,
                size: 34,
              ),
              SizedBox(
                width: 5,
              ),
              Text(
                '${model.title}',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          SizedBox(
            height: 20,
          ),
          Text(
            '${model.count}',
            style: TextStyle(
                color: defaultColor, fontSize: 22, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
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

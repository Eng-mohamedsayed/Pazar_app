import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:pazar/admin/admin_panel.dart/admin_panel.dart';
import 'package:pazar/admin/categories/manage_all_category.dart';
import 'package:pazar/admin/products/manage_products.dart';
import 'package:pazar/shared/components/components.dart';
import 'package:pazar/shared/network/local/cashe_helper.dart';
import 'package:pazar/shared/styles/colors.dart';
import 'package:pazar/user/modules/login/login_screen.dart';

class SideDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          Stack(
            alignment: AlignmentDirectional.topEnd,
            children: [
              DrawerHeader(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image(
                      height: 60,
                      width: 60,
                      image: AssetImage('assets/images/cart2.png'),
                    ),
                    Text(
                      'MANAGE',
                      style: TextStyle(
                          color: defaultColor,
                          fontSize: 22,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 25, right: 10),
                child: IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(MdiIcons.closeThick)),
              ),
            ],
          ),
          ListTile(
            leading: Icon(
              Icons.home,
              color: defaultColor,
            ),
            title: Text('Home'),
            onTap: () => {navigateTo(context, AdminPanel())},
          ),
          ListTile(
            leading: Icon(
              Icons.shopping_cart,
              color: defaultColor,
            ),
            title: Text('Products'),
            onTap: () => {navigateTo(context, ProductLayout())},
          ),
          ListTile(
            leading: Icon(
              Icons.category,
              color: defaultColor,
            ),
            title: Text('Categories'),
            onTap: () => {navigateTo(context, ManageAllCategories())},
          ),
          ListTile(
            leading: Icon(
              MdiIcons.locationExit,
              color: defaultColor,
            ),
            title: Text('Logout'),
            onTap: () => {
              CasheHelper.removeData(key: 'adminID')
                  .then((value) => {navigateTo(context, LoginScreen())})
            },
          ),
        ],
      ),
    );
  }
}

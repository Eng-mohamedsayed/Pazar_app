import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:pazar/admin/admin_panel.dart/admin_panel.dart';
import 'package:pazar/shared/components/components.dart';
import 'package:pazar/shared/network/local/cashe_helper.dart';
import 'package:pazar/shared/styles/colors.dart';
import 'package:pazar/user/layouts/products_layout.dart/products_screen.dart';
import 'package:pazar/user/modules/login/login_screen.dart';
import 'package:pazar/user/users_cubit/user_cubit.dart';
import 'package:pazar/user/users_cubit/user_states.dart';

class UserSideDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<UserCubits, UserStates>(
        builder: (context, state) {
          var cubit = UserCubits().get(context);
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
                            image: AssetImage('assets/images/cartHome.jpg'),
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
                  onTap: () => {navigateTo(context, ProductsScreen())},
                ),
                ListTile(
                  leading: Icon(
                    Icons.shopping_cart,
                    color: defaultColor,
                  ),
                  title: Row(
                    children: [
                      Text('Theme Color'),
                      SizedBox(
                        width: 10,
                      ),
                      Switch(
                          activeColor: defaultColor,
                          value: cubit.isSwitched,
                          onChanged: (bool value) {
                            cubit.toggleTheme(value);
                            CasheHelper.saveData(
                                key: 'theme', value: cubit.isSwitched);
                          })
                    ],
                  ),
                  onTap: () => {Navigator.pop(context)},
                ),
                ListTile(
                  leading: Icon(
                    Icons.category,
                    color: defaultColor,
                  ),
                  title: Text('Setting'),
                  onTap: () => {Navigator.pop(context)},
                ),
                ListTile(
                  leading: Icon(
                    MdiIcons.locationExit,
                    color: defaultColor,
                  ),
                  title: Text('Logout'),
                  onTap: () => {
                    CasheHelper.removeData(key: 'userID')
                        .then((value) => {navigateTo(context, LoginScreen())})
                  },
                ),
              ],
            ),
          );
        },
        listener: (context, state) {});
  }
}

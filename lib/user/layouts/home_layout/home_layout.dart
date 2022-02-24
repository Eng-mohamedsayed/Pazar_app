import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:pazar/shared/components/components.dart';
import 'package:pazar/shared/network/local/cashe_helper.dart';
import 'package:pazar/shared/styles/colors.dart';
import 'package:pazar/user/modules/drawer/user_drawer.dart';
import 'package:pazar/user/modules/login/login_screen.dart';
import 'package:pazar/user/users_cubit/user_cubit.dart';
import 'package:pazar/user/users_cubit/user_states.dart';

class HomeLayout extends StatelessWidget {
  const HomeLayout({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<UserCubits, UserStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var userCubit = UserCubits().get(context);
        return Scaffold(
          // appBar: AppBar(
          //   actions: [
          //     IconButton(onPressed: (){
          //       CasheHelper.removeData(key: 'userID').then((value) {
          //         navigateTo(context, LoginScreen());
          //       });
          //     }, icon: Icon(Icons.exit_to_app))
          //   ],
          // ),

          body: userCubit.screens[userCubit.currentIndex],

          bottomNavigationBar: BottomNavigationBar(
              backgroundColor: Colors.white,
              selectedItemColor: defaultColor,
              unselectedItemColor: Colors.grey,
              currentIndex: userCubit.currentIndex,
              onTap: (index) {
                userCubit.changeBottomNav(index);
              },
              items: [
                BottomNavigationBarItem(
                    icon: Icon(MdiIcons.home), label: 'Home'),
                BottomNavigationBarItem(
                    icon: Icon(MdiIcons.apps), label: 'Categories'),
                BottomNavigationBarItem(
                    icon: Icon(Icons.favorite_outlined), label: 'Favourite'),
                BottomNavigationBarItem(
                    icon: Icon(MdiIcons.cart), label: 'Carts'),
              ]),
        );
      },
    );
  }
}

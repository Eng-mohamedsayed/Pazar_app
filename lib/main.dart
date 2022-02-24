import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pazar/admin/admin_cubit/admin_cubits.dart';
import 'package:pazar/admin/admin_panel.dart/admin_panel.dart';
import 'package:pazar/admin/categories/add_category.dart';
import 'package:pazar/admin/categories/all_categories.dart';
import 'package:pazar/admin/categories/edit_categories.dart';
import 'package:pazar/admin/products/add_products.dart';
import 'package:pazar/admin/products/edit_products.dart';
import 'package:pazar/admin/products/manage_products.dart';
import 'package:pazar/shared/components/constants.dart';
import 'package:pazar/shared/network/bloc_observer.dart';
import 'package:pazar/shared/network/local/cashe_helper.dart';
import 'package:pazar/shared/styles/colors.dart';
import 'package:pazar/user/layouts/home_layout/home_layout.dart';
import 'package:pazar/user/modules/login/login_screen.dart';
import 'package:pazar/user/modules/onBoarding/onBoarding_screen.dart';
import 'package:pazar/user/users_cubit/user_cubit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await CasheHelper.init();
  Bloc.observer = MyBlocObserver();
  bool isBoarding = CasheHelper.getData(key: 'onboarding');
  Widget widget;
  userID = CasheHelper.getData(key: 'userID');
  print(userID);
  bool adminID = CasheHelper.getData(key: 'adminID');
  if (isBoarding == true) {
    if (userID != null) {
      widget = HomeLayout();
    } else {
      if (adminID != null) {
        print('admin');

        widget = AdminPanel();
      } else {
        widget = LoginScreen();
      }
    }
  } else {
    widget = OnBoardingScreen();
  }

  runApp(MyApp(widget));
}

class MyApp extends StatelessWidget {
  Widget startWidget;
  MyApp(this.startWidget);
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider(
              create: (context) => AdminCubits()
                ..getCategory()
                ..getAllProducts()
                ..getAllUsers()
                ..getAllOrders()),
          BlocProvider(
              create: (context) => UserCubits()
                ..getAllCategories()
                ..getAllProducts()
                ..getFavouriteProducts()
                ..getCartsProducts()),
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Flutter Demo',
          theme: ThemeData(
            scaffoldBackgroundColor: Colors.white,
            appBarTheme: AppBarTheme(
                backwardsCompatibility: false,
                systemOverlayStyle: SystemUiOverlayStyle(
                  statusBarColor: Colors.white,
                ),
                elevation: 0,
                backgroundColor: Colors.white,
                iconTheme: IconThemeData(color: Colors.black),
                titleTextStyle: TextStyle(color: Colors.black)),
            primarySwatch: Colors.blue,
          ),
          home: startWidget,
        ));
  }
}

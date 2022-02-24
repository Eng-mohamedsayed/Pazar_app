import 'dart:ffi';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pazar/admin/models/category_model.dart';
import 'package:pazar/admin/models/product_model.dart';
import 'package:pazar/shared/components/constants.dart';
import 'package:pazar/shared/network/local/cashe_helper.dart';
import 'package:pazar/user/layouts/card_layout.dart/cards_screen.dart';
import 'package:pazar/user/layouts/categories_layout.dart/categories_screen.dart';
import 'package:pazar/user/layouts/favourites_layout.dart/favourite_screen.dart';
import 'package:pazar/user/layouts/products_layout.dart/products_screen.dart';
import 'package:pazar/user/models/favourite_model.dart';
import 'package:pazar/user/models/orders_model.dart';
import 'package:pazar/user/models/user_model.dart';
import 'package:pazar/user/users_cubit/user_states.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

class UserCubits extends Cubit<UserStates> {
  UserCubits() : super(UserInitialStates());

  UserCubits get(context) => BlocProvider.of(context);

  // All Objects
  int currentIndex = 0;
  CategoryModel? categoryModel;

  List<CategoryModel>? allCategories = [];
  List<ProductModel>? allProducts = [];
  List<String> productID = [];
  List<String> catID = [];
  bool isFav = false;
  int counter = 1;

  bool isSwitched = false;

  // **********************************************  //

  List<Widget> screens = [
    ProductsScreen(),
    CategorisScreen(),
    FavouriteScreen(),
    CardsScreen()
  ];

  void changeBottomNav(int index) {
    currentIndex = index;
    emit(UserChangeBottomNavSuccessStates());
  }

  void incrementCount() {
    counter++;
    emit(UserIncrementCountStates());
  }

  void toggleTheme(value) {
    isSwitched = value;

    emit(UserToggleThemeData());
  }

  void decrementCount() {
    if (counter != 0) {
      counter--;
      emit(UserDecrementCountStates());
    }
  }

  void getUserLocation() async {}

  // *********************************   //

  /* Categories Cubits */

  void getAllCategories() {
    emit(UserGetAllCategoriesLoadingStates());

    FirebaseFirestore.instance
        .collection('category')
        .snapshots()
        .listen((event) {
      allCategories = [];
      catID = [];

      event.docs.forEach((element) {
        allCategories!.add(CategoryModel.fromJson(element.data()));
        catID.add(element.id);
      });
      emit(UserGetAllCategoriesSuccessStates());
    });
  }

  /* Products Cubits */

  void getAllProducts() {
    emit(UserGetAllProductsLoadingStates());

    FirebaseFirestore.instance
        .collection('products')
        .orderBy('dateTime', descending: true)
        .snapshots()
        .listen((event) {
      allProducts = [];
      productID = [];

      event.docs.forEach((element) {
        allProducts!.add(ProductModel.fromJson(element.data()));
        productID.add(element.id);
      });

      emit(UserGetAllProductssSuccessStates());
    });
  }

  void updateFavProducts(productID) {
    emit(UserUpdateFavProductsLoadingStates());

    FirebaseFirestore.instance
        .collection('products')
        .doc(productID)
        .update({'in_favorites': isFav}).then((value) {
      getAllProducts();
      emit(UserUpdateFavProductsSuccessStates());
    }).catchError((error) {
      isFav = !isFav;
      emit(UserUpdateFavProductsErrorStates());
    });
  }

  Map<String, bool> addFav = new Map();

  void addFavProduct(productId) {
    isFav = !isFav;
    addFav = {userID: isFav};

    emit(UserAddFavProductsLoadingStates());

    FirebaseFirestore.instance
        .collection('products')
        .doc(productId)
        .update({'fav': addFav}).then((value) {
      // updateFavProducts(productID);

      emit(UserAddFavProductsSuccessStates());
    }).catchError((error) {
      isFav = !isFav;
      emit(UserAddFavProductsErrorStates());
    });

    
  }

  bool isCart = false;

  void updateCartProducts(productID) {
    isCart = !isCart;

    emit(UserUpdateCartProductsLoadingStates());

    FirebaseFirestore.instance
        .collection('products')
        .doc(productID)
        .update({'in_cart': isCart}).then((value) {
      getAllProducts();
      emit(UserUpdateCartProductsSuccessStates());
    }).catchError((error) {
      isCart = !isCart;
      emit(UserUpdateCartProductsErrorStates());
    });
  }

  List<ProductModel>? productCategories = [];
  List<String>? productCategoriesID = [];

  void getPeoductsOfCtegory(categoryID) {
    emit(UserGetProductsOfCategoryLoadingStates());

    FirebaseFirestore.instance
        .collection('products')
        .where('categoryID', isEqualTo: categoryID)
        .orderBy('dateTime', descending: true)
        .snapshots()
        .listen((event) {
      productCategories = [];
      productCategoriesID = [];

      event.docs.forEach((element) {
        productCategories!.add(ProductModel.fromJson(element.data()));
        productCategoriesID!.add(element.id);
      });

      emit(UserGetProductsOfCategorySuccessStates());
    });
  }

  Map favourites = new Map();
  bool isFavouite = false;
  bool _isFavouite = false;
  void handleFavProducts(productId) {
    _isFavouite = !_isFavouite;
    if (_isFavouite == true) {
      FirebaseFirestore.instance
          .collection('products')
          .doc(productId)
          .update({'favourites.$userID': false}).then((value) {
        favourites[userID] = false;
        isFavouite = false;
        emit(UserAddFavProductsSuccessStates());
      });
    } else {
      FirebaseFirestore.instance
          .collection('products')
          .doc(productId)
          .update({'favourites.$userID': true}).then((value) {
        print(userID);

        favourites[userID] = true;
        isFavouite = true;
        emit(UserAddFavProductsSuccessStates());
      });
    }
  }

  void removeFromFav(productId) {
    FirebaseFirestore.instance
        .collection('products')
        .doc(productId)
        .update({'favourites.$userID': false}).then((value) {
      favourites[userID] = false;
      isFavouite = false;
      emit(UserRemoveFromFavStates());
    });
  }

  List<ProductModel>? allFavourites = [];
  List<String>? favID = [];

  void getFavouriteProducts() {
    emit(UserGetFavProductsLoadingStates());

    FirebaseFirestore.instance
        .collection('products')
        .where('favourites.$userID', isEqualTo: true)
        .snapshots()
        .listen((event) {
      allFavourites = [];
      favID = [];
      event.docs.forEach((element) {
        allFavourites!.add(ProductModel.fromJson(element.data()));
        favID!.add(element.id);
      });
      emit(UserGetFavProductsSuccessStates());
    });
  }

//***************************** */

  Map carts = new Map();
  bool inCart = false;
  void handleCartProducts(productId) {
    bool _inCarts = carts[userID] == true;
    emit(UserAddCartProductsLoadingStates());

    if (_inCarts == true) {
      FirebaseFirestore.instance
          .collection('products')
          .doc(productId)
          .update({'carts.$userID': false}).then((value) {
        carts[userID] = false;
        inCart = false;
        emit(UserAddCartProductsSuccessStates());
      });
    } else {
      FirebaseFirestore.instance
          .collection('products')
          .doc(productId)
          .update({'carts.$userID': true}).then((value) {
        carts[userID] = true;
        inCart = true;
        emit(UserAddCartProductsSuccessStates());
      });
    }
  }

  void removeFromCart(productId) {
    FirebaseFirestore.instance
        .collection('products')
        .doc(productId)
        .update({'carts.$userID': false}).then((value) {
      carts[userID] = false;
      inCart = false;
      emit(UserRemoveFromCartsStates());
    });
  }

  List<ProductModel>? allCarts = [];
  List<String>? cartID = [];

  void getCartsProducts() {
    emit(UserGetCartsProductsLoadingStates());

    FirebaseFirestore.instance
        .collection('products')
        .where('carts.$userID', isEqualTo: true)
        .snapshots()
        .listen((event) {
      allCarts = [];
      cartID = [];
      event.docs.forEach((element) {
        allCarts!.add(ProductModel.fromJson(element.data()));
        cartID!.add(element.id);
      });
      emit(UserGetCartsProductsSuccessStates());
    });
  }

  List<ProductModel>? productsResult = [];
  List<String>? productsResultID = [];

  void searchProducts(String s) {
    emit(UserSearchProductsLoadingStates());

    FirebaseFirestore.instance
        .collection('products')
        .where('searchKeywords', arrayContains: s)
        .snapshots()
        .listen((event) {
      productsResult = [];
      productsResultID = [];
      event.docs.forEach((element) {
        productsResult!.add(ProductModel.fromJson(element.data()));
        productsResultID!.add(element.id);
      });
      emit(UserSearchProductsSuccessStates());
    });
  }

  List<CategoryModel>? categoriesResult = [];
  List<String>? categoriesResultID = [];

  void searchCategories(String s) {
    emit(UserSearchCategoriesLoadingStates());

    FirebaseFirestore.instance
        .collection('category')
        .where('searchKeywords', arrayContains: s)
        .snapshots()
        .listen((event) {
      categoriesResult = [];
      categoriesResultID = [];
      event.docs.forEach((element) {
        categoriesResult!.add(CategoryModel.fromJson(element.data()));
        categoriesResultID!.add(element.id);
      });
      emit(UserSearchCategoriesSuccessStates());
    });
  }

  List<ProductModel>? favProductsResult = [];
  List<String>? favProductsResultID = [];

  void searchFavProducts(String s) {
    emit(UserSearchFavProductsLoadingStates());

    FirebaseFirestore.instance
        .collection('products')
        .where('favourites.$userID', isEqualTo: true)
        .where('searchKeywords', arrayContains: s)
        .snapshots()
        .listen((event) {
      favProductsResult = [];
      favProductsResultID = [];
      event.docs.forEach((element) {
        favProductsResult!.add(ProductModel.fromJson(element.data()));
        favProductsResultID!.add(element.id);
      });
      emit(UserSearchFavSuccessStates());
    });
  }

  List<ProductModel>? cartProductsResult = [];
  List<String>? cartProductsResultID = [];

  void searchCartProducts(String s) {
    emit(UserSearchFavProductsLoadingStates());

    FirebaseFirestore.instance
        .collection('products')
        .where('carts.$userID', isEqualTo: true)
        .where('searchKeywords', arrayContains: s)
        .snapshots()
        .listen((event) {
      cartProductsResult = [];
      cartProductsResultID = [];
      event.docs.forEach((element) {
        cartProductsResult!.add(ProductModel.fromJson(element.data()));
        cartProductsResultID!.add(element.id);
      });
      emit(UserSearchFavSuccessStates());
    });
  }

  UsersModel? oneUserModel;
  void getOneUser() {
    emit(UserGetOneUserLoadingStates());
  }

  OrderModel? orderModel;
  void makeOrder(totalPrice, countOfPieces, productID, address, productName) {
    emit(UserMakeOrderLoadingStates());

    FirebaseFirestore.instance
        .collection('users')
        .where('userID', isEqualTo: userID)
        .snapshots()
        .listen((event) {
      String username = event.docs[0].data()['username'];
      String email = event.docs[0].data()['email'];
      String phone = event.docs[0].data()['phone'];

      orderModel = OrderModel(
          username,
          email,
          phone,
          userID,
          address,
          'location',
          totalPrice,
          countOfPieces,
          productID,
          DateTime.now().toString(),
          productName);
      FirebaseFirestore.instance
          .collection('orders')
          .doc(userID)
          .collection('Products')
          .add(orderModel!.toMap())
          .then((value) {
        emit(UserMakeOrderSuccessStates());
      }).catchError((error) {
        emit(UserMakeOrderErrorStates());
      });

      emit(UserGetOneUserSuccessStates());
    });
  }


}




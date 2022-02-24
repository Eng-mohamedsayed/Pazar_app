import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pazar/admin/admin_cubit/admin_states.dart';
import 'package:pazar/admin/models/category_model.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:pazar/admin/models/product_model.dart';
import 'package:pazar/shared/components/components.dart';
import 'package:pazar/shared/components/constants.dart';
import 'package:pazar/user/models/orders_model.dart';
import 'package:pazar/user/models/user_model.dart';

class AdminCubits extends Cubit<AdminStates> {
  AdminCubits() : super(AdminInitialStates());

  static AdminCubits get(context) => BlocProvider.of(context);

  // ***************************************************  //

  /*  Category Cubit  */

  // Add Category

  File? categoryImage;
  var picker = ImagePicker();
  Future<void> pickImage() async {
    final pickedImage = await picker.getImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      categoryImage = File(pickedImage.path);

      emit(AdminPickCategoryImageSuccessStates());
    } else {
      print('No Image Selected');
      emit(AdminPickCategoryImageErrorStates('Can\'t Upload Image'));
    }
  }

  List<String> textCat = [];

  List<String>? catKeyword = [];
  bool found = false;
  void uploadCategoryImage({
    String? dateTime,
    String? categoryName,
  }) {
    textCat = categoryName!.split(' ');
    for (int i = 0; i < textCat.length; i++) {
      for (int j = i; j < textCat[i].length + i; j++) {
        catKeyword!.add(textCat[i].substring(0, j).toLowerCase());
      }
    }
    emit(AdminAddCategoryLoadingStates());

    for (int i = 0; i < allCategory!.length; i++) {
      if (allCategory![i].name!.contains(categoryName.toString())) {
        found = true;
      }
    }
    if (found == true) {
      emit(AdminAddExistCategoryErrorStates('This Category Is Exist'));
    } else {
      firebase_storage.FirebaseStorage.instance
          .ref()
          .child('category/${Uri.file(categoryImage!.path).pathSegments.last}')
          .putFile(categoryImage!)
          .then((value) {
        value.ref.getDownloadURL().then((value) {
          addCategory(
              name: categoryName.toLowerCase(),
              image: value,
              dateTime: dateTime,
              searchKeywords: catKeyword);
        });
      });
    }
  }

  CategoryModel? categoryModel;
  void addCategory(
      {required String? name,
      required String? image,
      required String? dateTime,
      required List<String>? searchKeywords}) {
    emit(AdminAddCategoryLoadingStates());

    categoryModel = CategoryModel(
        image: image,
        name: name!.toLowerCase(),
        dateTime: dateTime,
        searchKeywords: searchKeywords);
    FirebaseFirestore.instance
        .collection('category')
        .add(categoryModel!.toMap())
        .then((value) {
      emit(AdminAddCategorySuccessStates());
    }).catchError((error) {
      emit(AdminAddCategoryErrorStates());
    });
  }

  // ***************************************************  //

  /*  Get All Categories */

  List<CategoryModel>? allCategory = [];
  List<String> catID = [];
  void getCategory() {
    emit(AdminGetAllCategoryLoadingStates());

    FirebaseFirestore.instance
        .collection('category')
        .snapshots()
        .listen((event) {
      allCategory = [];
      catID = [];
      event.docs.forEach((element) {
        allCategory!.add(CategoryModel.fromJson(element.data()));
        catID.add(element.id);
      });
      emit(AdminGetAllCategorySuccessStates());
    });
  }

  // ***************************************************  //

  /*  Edit Category  */

  void editCategory({String? catID, String? name, String? dateTime}) {
    emit(AdminEditCategoryLoadingStates());
    firebase_storage.FirebaseStorage.instance
        .ref()
        .child('category/${Uri.file(categoryImage!.path).pathSegments.last}')
        .putFile(categoryImage!)
        .then((value) {
      value.ref.getDownloadURL().then((value) {
        categoryModel = CategoryModel(
            image: value, name: name!.toLowerCase(), dateTime: dateTime);
        FirebaseFirestore.instance
            .collection('category')
            .doc(catID!)
            .update(categoryModel!.toMap())
            .then((value) {
          emit(AdminEditCategorySuccessStates());
          categoryImage = null;
        }).catchError((error) {
          print(error.toString());
          emit(AdminEditCategoryErrorStates());
        });
      }).catchError((error) {
        emit(AdminEditCategoryErrorStates());
      });
    });
  }

  // ***************************************************  //

  /*  Products Cubit  */

  // Add Products

  File? productImage;

  var pickerProduct = ImagePicker();
  Future<void> pickProductImage() async {
    final productPickedImage =
        await pickerProduct.getImage(source: ImageSource.gallery);
    if (productPickedImage != null) {
      productImage = File(productPickedImage.path);

      emit(AdminPickProductImageSuccessStates());
    } else {
      print('No Image Selected');
      emit(AdminPickProductImageErrorStates('Can\'t Upload Image'));
    }
  }

  ProductModel? productModel;
  List<String> text = [];

  List<String>? searchKeyword = [];
  void uploadProduct({
    int? price,
    String? name,
    String? description,
    String? categoryName,
  }) {
    text = name!.split(' ');
    for (int i = 0; i < text.length; i++) {
      for (int j = i; j < text[i].length + i; j++) {
        searchKeyword!.add(text[i].substring(0, j).toLowerCase());
      }
    }
    emit(AdminAddProductLoadingStates());

    firebase_storage.FirebaseStorage.instance
        .ref()
        .child('products/${Uri.file(productImage!.path).pathSegments.last}')
        .putFile(productImage!)
        .then((value) {
      value.ref.getDownloadURL().then((image) {
        FirebaseFirestore.instance
            .collection('category')
            .where('name', isEqualTo: categoryName)
            .get()
            .then((value) {
          String categoyID = value.docs[0].id;
          print(categoyID);
          productModel = ProductModel(
              categoryID: value.docs[0].id,
              categoryName: categoryName,
              description: description,
              dateTime: DateTime.now().toString(),
              discount: 0,
              image: image,
              inCart: false,
              inFavorites: false,
              name: name,
              oldPrice: 0,
              price: price,
              favourites: {},
              carts: {},
              searchKeywords: searchKeyword);

          FirebaseFirestore.instance
              .collection('products')
              .add(productModel!.toMap())
              .then((value) {
            searchKeyword = [];

            emit(AdminAddProductSuccessStates());
          }).catchError((error) {
            emit(AdminAddProductErrorStates());
          });
        });
      });
    });
  }

  List<ProductModel>? allProducts = [];
  List<String> productID = [];

  void getAllProducts() {
    emit(AdminGetAllProductsLoadingStates());

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
      emit(AdminGetAllProductsSuccessStates());
    });
  }

  void editProduct(
      {String? productID,
      String? productName,
      String? desc,
      String? categoryName,
      int? price,
      int? oldPrice,
      int? discount,
      String? prodImage}) {
    emit(AdminEditProductLoadingStates());

    firebase_storage.FirebaseStorage.instance
        .ref()
        .child('products/${Uri.file(productImage!.path).pathSegments.last}')
        .putFile(productImage!)
        .then((value) {
      value.ref.getDownloadURL().then((image) {
        emit(SocialUploadProductImageSuccessState());
        editProuctData(
            categoryName: categoryName,
            desc: desc,
            discount: discount,
            oldPrice: oldPrice,
            price: price,
            productID: productID,
            productName: productName,
            prodImage: image);
      });
    });
  }

  ProductModel? model;
  void editProuctData(
      {String? productID,
      String? productName,
      String? desc,
      String? categoryName,
      int? price,
      int? oldPrice,
      int? discount,
      String? prodImage}) {
    FirebaseFirestore.instance
        .collection('category')
        .where('name', isEqualTo: categoryName)
        .get()
        .then((value) {
      model = ProductModel(
          categoryID: value.docs[0].id,
          categoryName: categoryName,
          dateTime: DateTime.now().toString(),
          description: desc,
          discount: discount,
          inCart: false,
          inFavorites: false,
          name: productName,
          oldPrice: oldPrice,
          price: price,
          image: prodImage ?? productModel!.image);

      FirebaseFirestore.instance
          .collection('products')
          .doc(productID!)
          .update(model!.toMap())
          .then((value) {
        emit(AdminEditProductSuccessStates());
      }).catchError((error) {
        print(error.toString());
        emit(AdminEditCategoryErrorStates());
      });
    });
  }

  List<UsersModel>? allUsers = [];

  List<String>? usersID = [];

  void getAllUsers() {
    FirebaseFirestore.instance.collection('users').snapshots().listen((event) {
      allUsers = [];
      usersID = [];
      event.docs.forEach((element) {
        allUsers!.add(UsersModel.fromJson(element.data()));
        usersID!.add(element.id);
      });
      emit(AdminGetAllUsersSuccessStates());
    });
  }

  List<OrderModel>? allOrders = [];

  List<String>? ordersID = [];

  void getAllOrders() {
    FirebaseFirestore.instance
        .collection('orders')
        .doc(userID)
        .collection('Products')
        .snapshots()
        .listen((event) {
      allOrders = [];
      ordersID = [];
      event.docs.forEach((element) {
        allOrders!.add(OrderModel.fromJson(element.data()));

        ordersID!.add(element.id);
      });
      print(allOrders!.length);
      emit(AdminGetAllOrdersSuccessStates());
    });
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:pazar/admin/models/product_model.dart';
import 'package:pazar/shared/components/components.dart';
import 'package:pazar/shared/styles/colors.dart';
import 'package:pazar/user/layouts/card_layout.dart/cards_screen.dart';
import 'package:pazar/user/layouts/home_layout/home_layout.dart';
import 'package:pazar/user/users_cubit/user_cubit.dart';
import 'package:pazar/user/users_cubit/user_states.dart';

class OrderScreen extends StatelessWidget {
  ProductModel? productModel;
  String? productID;
  OrderScreen(this.productModel, this.productID);

  TextEditingController addressController = TextEditingController();

  var formKey = GlobalKey<FormState>();
  var bottomSheetController;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<UserCubits, UserStates>(
      listener: (context, state) {
        if (state is UserMakeOrderSuccessStates) {
          showToast(text: 'Successful purchase', states: ToastStates.SUCCESS);
          addressController.text = '';
          UserCubits().get(context).counter = 1;
          Navigator.of(context).pop();
        }
      },
      builder: (context, state) {
        var cubit = UserCubits().get(context);
        int totalPrice = (productModel!.price)! * (cubit.counter);
        return Scaffold(
            appBar: AppBar(
              centerTitle: true,
              title: Text(
                'Order Product',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              leading: IconButton(
                  onPressed: () {
                    UserCubits().get(context).counter = 1;

                    navigateTo(context, HomeLayout());
                  },
                  icon: Icon(
                    Icons.arrow_back,
                  )),
            ),
            body: SingleChildScrollView(
              child: Column(
                children: [
                  Image(
                    height: MediaQuery.of(context).size.height * 0.5,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    image: NetworkImage('${productModel!.image}'),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              '${productModel!.name}',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  fontSize: 22, fontWeight: FontWeight.bold),
                            ),
                            Spacer(),
                            Text(
                              '${productModel!.price}\$',
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w800,
                                  color: defaultColor),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          '${productModel!.description}',
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              color: Colors.grey,
                              fontSize: 14,
                              fontWeight: FontWeight.w500),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            Text(
                              'Count',
                              style: TextStyle(
                                  fontSize: 22, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              width: 40,
                            ),
                            IconButton(
                              onPressed: () {
                                cubit.decrementCount();
                              },
                              icon: Icon(
                                MdiIcons.minusCircle,
                                size: 32,
                                color: defaultColor,
                              ),
                            ),
                            Text(
                              '${cubit.counter}',
                              style: TextStyle(
                                  fontSize: 22, fontWeight: FontWeight.w800),
                            ),
                            IconButton(
                              onPressed: () {
                                cubit.incrementCount();
                              },
                              icon: Icon(
                                MdiIcons.plusCircle,
                                size: 32,
                                color: defaultColor,
                              ),
                            ),
                          ],
                        ),
                        Divider(
                          color: defaultColor,
                          thickness: 1,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            Text(
                              'Total Price',
                              style: TextStyle(
                                  fontSize: 22, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              width: 30,
                            ),
                            Text(
                              '$totalPrice\$',
                              style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: defaultColor),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        defaultButton(
                          background: defaultColor,
                          function: () {
                            showCustomDialog(
                                context, productModel, totalPrice, productID);
                          },
                          text: 'Check Out',
                          textColor: Colors.white,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ));
      },
    );
  }

  void showCustomDialog(
      context, ProductModel? model, int totalPrice, String? productID) {
    var cubit = UserCubits().get(context);
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return Dialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Container(
                width: double.infinity,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('${model!.name}',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        )),
                    SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      maxLines: null,
                      keyboardType: TextInputType.multiline,
                      controller: addressController,
                      decoration: InputDecoration(
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: defaultColor),
                          ),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: defaultColor),
                          ),
                          focusColor: defaultColor,
                          hintText: 'Enter your adress',
                          prefixIcon: Icon(Icons.location_on_outlined,
                              color: defaultColor)),
                    ),
                    // defaultTextField(
                    //     borderColor: defaultColor,
                    //     hintText: 'Your Adress',
                    //     controller: addressController,
                    //     iconColor: defaultColor,
                    //     type: TextInputType.text,
                    //     prefixIcon: Icons.location_on_outlined),
                    SizedBox(
                      height: 10,
                    ),
                    Text('Or'),
                    OutlineButton(
                      onPressed: () {},
                      child: Text('Current Location'),
                      textColor: Colors.red,
                      borderSide: BorderSide(color: Colors.red),
                    ),
                    // Divider(
                    //   color: Colors.black,
                    //   thickness: 1,
                    // ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: [
                        Text(
                          'Total Price',
                          style: TextStyle(
                              fontSize: 22, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          width: 30,
                        ),
                        Text(
                          '$totalPrice\$',
                          style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: defaultColor),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            cubit.makeOrder(
                                totalPrice,
                                cubit.counter,
                                productID,
                                addressController.text.trim(),
                                model.name);
                          },
                          style: ElevatedButton.styleFrom(
                            primary: Colors.red, // background
                            onPrimary: Colors.white, // foreground
                          ),
                          child: Text('Confirm'),
                        ),
                        Spacer(),
                        OutlineButton(
                          onPressed: () {
                            addressController.text = '';
                            Navigator.of(context).pop();
                          },
                          child: Text('Cancel'),
                          textColor: Colors.red,
                          borderSide: BorderSide(color: Colors.red),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          );
        });
  }
}


/* 
   return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: MediaQuery.of(context).size.height * 0.3,
                child: Column(
                  children: [
                    defaultTextField(
                        borderColor: defaultColor,
                        hintText: 'Adress',
                        controller: addressController,
                        iconColor: defaultColor,
                        type: TextInputType.text,
                        prefixIcon: Icons.location_on_outlined)
                  ],
                ),
              ),
            ),
          );
      
      

*/
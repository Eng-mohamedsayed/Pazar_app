import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:pazar/admin/admin_cubit/admin_cubits.dart';
import 'package:pazar/admin/admin_cubit/admin_states.dart';
import 'package:pazar/admin/categories/all_categories.dart';
import 'package:pazar/shared/components/components.dart';
import 'package:pazar/shared/components/constants.dart';
import 'package:pazar/shared/styles/colors.dart';

class AddProducts extends StatefulWidget {
  @override
  _AddProductsState createState() => _AddProductsState();
}

class _AddProductsState extends State<AddProducts> {
  TextEditingController nameController = TextEditingController();

  TextEditingController descController = TextEditingController();

  TextEditingController priceController = TextEditingController();

  String? drobdownValue;

  List<String> catName = [];
  var bottomSheetController;

  var formKey = GlobalKey<FormState>();

  var date = DateTime.now();
  String categoryName = 'select category';

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AdminCubits, AdminStates>(
      listener: (context, state) {
        if (state is AdminAddProductSuccessStates) {
          showToast(
              text: 'Product Added Successfully', states: ToastStates.SUCCESS);
          nameController.text = '';

          descController.text = '';

          priceController.text = '';
          categoryName = 'select category';

          AdminCubits.get(context).productImage = null;
        } else if (state is AdminAddProductErrorStates) {
          showToast(
              text: 'There is an error occured', states: ToastStates.ERROR);
        }
      },
      builder: (context, state) {
        var cubit = AdminCubits.get(context);

        return Scaffold(
          appBar: AppBar(
            title: Text(
              'Add Products',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.all(20.0),
            child: SingleChildScrollView(
              child: Form(
                key: formKey,
                child: Column(
                  children: [
                    //SizedBox(height: MediaQuery.of(context).size.height/22,),
                    Stack(
                      alignment: AlignmentDirectional.bottomEnd,
                      children: [
                        Image(
                            width: 150,
                            height: 180,
                            image: cubit.productImage == null
                                ? AssetImage('assets/images/no_image.jpg')
                                : FileImage(cubit.productImage!)
                                    as ImageProvider),
                        IconButton(
                          onPressed: () {
                            cubit.pickProductImage();
                          },
                          icon: CircleAvatar(
                            radius: 20,
                            backgroundColor: defaultColor,
                            child: Icon(
                              MdiIcons.camera,
                              size: 22,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),

                    defaultTextField(
                        borderColor: defaultColor,
                        controller: nameController,
                        hintText: 'Enter name of Product',
                        iconColor: defaultColor,
                        prefixIcon: Icons.category_outlined,
                        type: TextInputType.text,
                        validate: (value) {
                          if (value.toString().isEmpty) {
                            return 'please enter name of product';
                          }
                          return null;
                        }),
                    SizedBox(
                      height: 10,
                    ),
                    defaultTextField(
                        borderColor: defaultColor,
                        controller: descController,
                        hintText: 'Enter description of Product',
                        iconColor: defaultColor,
                        prefixIcon: Icons.info_outline,
                        type: TextInputType.text,
                        validate: (value) {
                          if (value.toString().isEmpty) {
                            return 'please enter Description of product';
                          }
                          return null;
                        }),

                    SizedBox(
                      height: 10,
                    ),
                    defaultTextField(
                        borderColor: defaultColor,
                        controller: priceController,
                        hintText: 'Enter price of Product',
                        iconColor: defaultColor,
                        prefixIcon: MdiIcons.cash,
                        type: TextInputType.text,
                        validate: (value) {
                          if (value.toString().isEmpty) {
                            return 'please enter price of product';
                          }
                          return null;
                        }),

                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      height: 50,
                      width: double.infinity,
                      child: TextButton(
                          child: Text(categoryName.toUpperCase(),
                              style: TextStyle(
                                  fontSize: 22, fontWeight: FontWeight.bold)),
                          style: ButtonStyle(
                              padding: MaterialStateProperty.all<EdgeInsets>(
                                  EdgeInsets.all(15)),
                              foregroundColor: MaterialStateProperty.all<Color>(
                                  defaultColor),
                              shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(25.0),
                                      side: BorderSide(color: defaultColor)))),
                          onPressed: () {
                            bottomSheetController = showModalBottomSheet(
                                context: context,
                                builder: (context) {
                                  return ListView.separated(
                                      itemBuilder: (context, index) {
                                        return Padding(
                                          padding: const EdgeInsets.all(20.0),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              InkWell(
                                                onTap: () {
                                                  setState(() {
                                                    categoryName = cubit
                                                        .allCategory![index]
                                                        .name!;
                                                  });
                                                  Navigator.pop(context);
                                                },
                                                child: Row(
                                                  children: [
                                                    Text(
                                                      '${cubit.allCategory![index].name}',
                                                      style: TextStyle(
                                                          fontSize: 22,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                  ],
                                                ),
                                              )
                                            ],
                                          ),
                                        );
                                      },
                                      separatorBuilder: (context, index) =>
                                          Divider(
                                            indent: 10,
                                            endIndent: 10,
                                            color: defaultColor,
                                          ),
                                      itemCount: cubit.allCategory!.length);
                                });
                          }),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    defaultButton(
                      background: defaultColor,
                      text: 'Add Product',
                      function: () {
                        if (formKey.currentState!.validate()) {
                          cubit.uploadProduct(
                              categoryName: categoryName,
                              name: nameController.text.trim(),
                              description: descController.text.trim(),
                              price: int.parse(priceController.text.trim()));
                        }
                      },
                      width: double.infinity,
                      textColor: Colors.white,
                      textFontSize: 22,
                    ),
                    SizedBox(height: 15),
                    if (state is AdminAddProductLoadingStates)
                      LinearProgressIndicator(
                        color: defaultColor,
                        backgroundColor: Colors.deepOrange[200],
                      )
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

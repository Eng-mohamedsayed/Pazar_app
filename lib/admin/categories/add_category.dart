import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pazar/admin/admin_cubit/admin_cubits.dart';
import 'package:pazar/admin/admin_cubit/admin_states.dart';
import 'package:pazar/shared/components/components.dart';
import 'package:pazar/shared/styles/colors.dart';

class AddCategories extends StatelessWidget {
  TextEditingController nameController = TextEditingController();
  var formKey = GlobalKey<FormState>();
  var date = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AdminCubits, AdminStates>(
      listener: (context, state) {
        if (state is AdminAddCategorySuccessStates) {
          showToast(text: 'Upload Successfully', states: ToastStates.SUCCESS);
          nameController.text = '';
          AdminCubits.get(context).categoryImage = null;
        } else if (state is AdminAddCategoryErrorStates) {
          showToast(
              text: 'There is an error occured', states: ToastStates.ERROR);
        } else if (state is AdminAddExistCategoryErrorStates) {
          showToast(text: 'This category is exist', states: ToastStates.ERROR);
          nameController.text = '';
          AdminCubits.get(context).categoryImage = null;
          AdminCubits.get(context).found = false;
        }
      },
      builder: (context, state) {
        var cubit = AdminCubits.get(context);
        return Scaffold(
          appBar: AppBar(),
          body: Padding(
            padding: const EdgeInsets.all(20.0),
            child: SingleChildScrollView(
              child: Form(
                key: formKey,
                child: Column(
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height / 22,
                    ),
                    Image(
                        width: double.infinity,
                        height: 200,
                        image: cubit.categoryImage == null
                            ? AssetImage('assets/images/no_image.jpg')
                            : FileImage(cubit.categoryImage!) as ImageProvider),
                    SizedBox(
                      height: 20,
                    ),
                    defaultTextField(
                        borderColor: defaultColor,
                        controller: nameController,
                        hintText: 'Enter name of category',
                        iconColor: defaultColor,
                        prefixIcon: Icons.category_outlined,
                        type: TextInputType.text,
                        validate: (value) {
                          if (value.toString().isEmpty) {
                            return 'please enter name of category';
                          }
                          return null;
                        }),
                    SizedBox(
                      height: 15,
                    ),
                    Container(
                      width: double.infinity,
                      child: TextButton(
                          child: Text("upload image".toUpperCase(),
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
                            cubit.pickImage();
                          }),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    defaultButton(
                      background: defaultColor,
                      text: 'Add Category',
                      function: () {
                        if (formKey.currentState!.validate()) {
                          cubit.uploadCategoryImage(
                              categoryName: nameController.text.trim(),
                              dateTime: date.toString());
                        }
                      },
                      width: double.infinity,
                      textColor: Colors.white,
                      textFontSize: 22,
                    ),
                    SizedBox(height: 15),
                    if (state is AdminAddCategoryLoadingStates)
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

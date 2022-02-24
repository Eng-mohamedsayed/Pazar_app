import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:pazar/shared/components/components.dart';
import 'package:pazar/shared/styles/colors.dart';
import 'package:pazar/user/modules/register/registerCubit/register_cubit.dart';
import 'package:pazar/user/modules/register/registerCubit/register_states.dart';

// ignore: must_be_immutable
class RegisterScreen extends StatelessWidget {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController usernameController = TextEditingController();

  var formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RegisterCubits(),
      child: BlocConsumer<RegisterCubits, RegisterStates>(
        listener: (context, state) {
          if (state is RegisterCreateUserSuccessStates ||
              state is RegisterSuccessStates) {
            showToast(
                text: 'Register Successfully', states: ToastStates.SUCCESS);
          } else if (state is RegisterCreateUserErrorStates ||
              state is RegisterErrorStates) {
            showToast(text: 'Register Failed', states: ToastStates.ERROR);
          }
        },
        builder: (context, state) {
          var registerCubit = RegisterCubits.get(context);
          return Scaffold(
              appBar: AppBar(),
              body: Center(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: SingleChildScrollView(
                    child: Form(
                      key: formKey,
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image(
                                height: 60,
                                width: 60,
                                image: AssetImage('assets/images/logo1.png'),
                              ),
                              Text(
                                'Pazar',
                                style: TextStyle(
                                    color: defaultColor,
                                    fontSize: 48,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Pacifico'),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 50,
                          ),
                          defaultTextField(
                              type: TextInputType.text,
                              validate: (value) {
                                if (value.toString().isEmpty) {
                                  return 'please enter your username';
                                }
                                return null;
                              },
                              controller: usernameController,
                              hintText: 'Enter your username',
                              prefixIcon: Icons.person,
                              iconColor: defaultColor,
                              borderColor: defaultColor),
                          SizedBox(
                            height: 20,
                          ),
                          defaultTextField(
                              type: TextInputType.emailAddress,
                              validate: (value) {
                                if (value.toString().isEmpty) {
                                  return 'please enter your email';
                                }
                                return null;
                              },
                              controller: emailController,
                              hintText: 'Enter your email',
                              prefixIcon: Icons.email,
                              iconColor: defaultColor,
                              borderColor: defaultColor),
                          SizedBox(
                            height: 20,
                          ),
                          defaultTextField(
                              type: TextInputType.visiblePassword,
                              validate: (value) {
                                if (value.toString().isEmpty) {
                                  return 'please enter your password';
                                }
                                return null;
                              },
                              isPassword: registerCubit.isVisable,
                              suffixIcon: registerCubit.suffix,
                              suffixPressed: () {
                                registerCubit.changeVisability();
                              },
                              controller: passwordController,
                              hintText: 'Enter your Password',
                              prefixIcon: Icons.lock,
                              iconColor: defaultColor,
                              borderColor: defaultColor),
                          SizedBox(
                            height: 20,
                          ),
                          defaultTextField(
                              type: TextInputType.number,
                              validate: (value) {
                                if (value.toString().isEmpty) {
                                  return 'please enter your phone';
                                }
                                return null;
                              },
                              controller: phoneController,
                              hintText: 'Enter your phone',
                              prefixIcon: Icons.phone,
                              iconColor: defaultColor,
                              borderColor: defaultColor),
                          SizedBox(
                            height: 25,
                          ),
                          ConditionalBuilder(
                            condition: state is! RegisterLoadingStates,
                            builder: (context) {
                              return defaultButton(
                                  function: () {
                                    if (formKey.currentState!.validate()) {
                                      registerCubit.registerUser(
                                          email: emailController.text.trim(),
                                          password:
                                              passwordController.text.trim(),
                                          username:
                                              usernameController.text.trim(),
                                          phone: phoneController.text.trim());
                                    }
                                  },
                                  background: defaultColor,
                                  text: 'Register',
                                  textColor: Colors.white);
                            },
                            fallback: (context) => Center(
                              child: CircularProgressIndicator(
                                color: defaultColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ));
        },
      ),
    );
  }
}

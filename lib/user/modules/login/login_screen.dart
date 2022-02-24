import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pazar/admin/admin_panel.dart/admin_panel.dart';
import 'package:pazar/shared/components/components.dart';
import 'package:pazar/shared/network/local/cashe_helper.dart';
import 'package:pazar/shared/styles/colors.dart';
import 'package:pazar/user/layouts/home_layout/home_layout.dart';
import 'package:pazar/user/modules/login/loginCubit/login_states.dart';
import 'package:pazar/user/modules/register/register_screen.dart';

import 'loginCubit/login_cubits.dart';

class LoginScreen extends StatelessWidget {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  var formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoginCubits(),
      child: BlocConsumer<LoginCubits, LoginStates>(
        listener: (context, state) {
          if (state is LoginErrorStates) {
            showToast(text: state.error, states: ToastStates.ERROR);
          }
          if (state is LoginSuccessStates) {
            CasheHelper.saveData(key: 'userID', value: state.uID).then((value) {
              navigateAndFinish(context, HomeLayout());
            });
          }
        },
        builder: (context, state) {
          var loginCubit = LoginCubits.get(context);
          return Scaffold(
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
                        height: 80,
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
                          isPassword: loginCubit.isVisable,
                          suffixIcon: loginCubit.suffix,
                          suffixPressed: () {
                            loginCubit.changeVisability();
                          },
                          controller: passwordController,
                          hintText: 'Enter your Password',
                          prefixIcon: Icons.lock,
                          iconColor: defaultColor,
                          borderColor: defaultColor),
                      SizedBox(
                        height: 25,
                      ),
                      ConditionalBuilder(
                        condition: state is! LoginLoadingStates,
                        builder: (context) {
                          return defaultButton(
                              function: () {
                                if (formKey.currentState!.validate()) {
                                  if (emailController.text.trim() ==
                                          'admin@gmail.com' &&
                                      passwordController.text.trim() ==
                                          '123456789') {
                                    CasheHelper.saveData(
                                        key: 'adminID', value: true);
                                    navigateAndFinish(context, AdminPanel());
                                  } else {
                                    loginCubit.loginUser(
                                        email: emailController.text.trim(),
                                        password:
                                            passwordController.text.trim());
                                  }
                                }
                              },
                              background: defaultColor,
                              text: 'LOGIN',
                              textColor: Colors.white);
                        },
                        fallback: (context) => Center(
                          child: CircularProgressIndicator(
                            color: defaultColor,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('don\'t have an accout ?'),
                          TextButton(
                              onPressed: () {
                                navigateTo(context, RegisterScreen());
                              },
                              child: Text(
                                'Register',
                                style: TextStyle(color: defaultColor),
                              )),
                        ],
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

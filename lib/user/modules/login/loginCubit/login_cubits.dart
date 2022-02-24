

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pazar/user/modules/login/loginCubit/login_states.dart';

class LoginCubits extends Cubit<LoginStates>{

 LoginCubits():super(LoginInitialStates());


 static LoginCubits get(context)=>BlocProvider.of(context);


bool isVisable=true;
  IconData suffix = Icons.visibility_outlined;
 void changeVisability(){
   isVisable=!isVisable;
    if(isVisable==true){
      suffix=Icons.visibility_outlined;
    }else{
            suffix=Icons.visibility_off_outlined ;

    }
    emit(LoginChangeVisabilityStates());




 }




 void loginUser({
   required String email,
   required String password
 }){
   emit(LoginLoadingStates());

  FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password)
  .then((value) {
    emit(LoginSuccessStates(value.user.uid));
  })
  .catchError((error){
    print(error.toString());
    emit(LoginErrorStates(error.toString()));
  });

 }





}
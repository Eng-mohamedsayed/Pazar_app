

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pazar/user/models/user_model.dart';
import 'package:pazar/user/modules/register/registerCubit/register_states.dart';
import 'package:services/models/UserModel.dart';

class RegisterCubits extends Cubit<RegisterStates>{

 RegisterCubits():super(RegisterInitialStates());


 static RegisterCubits get(context)=>BlocProvider.of(context);


bool isVisable=true;
  IconData suffix = Icons.visibility_outlined;
 void changeVisability(){
   isVisable=!isVisable;
    if(isVisable==true){
      suffix=Icons.visibility_outlined;
    }else{
            suffix=Icons.visibility_off_outlined ;

    }
    emit(RegisterChangeVisabilityStates());

 }






void registerUser(
  {
    required String email,
    required String password,
    required String username,
    required String phone,
    String? userID
  }
){
  
  emit(RegisterLoadingStates());
  FirebaseAuth.instance.createUserWithEmailAndPassword(email:email , password: password).then((value) {
    createUser(email: email, username: username, phone: phone,userID: value.user.uid);
   emit(RegisterSuccessStates());
   
 }).catchError((error){
   print(error.toString());
   emit(RegisterErrorStates());
 });

}


void createUser(
  {
        required String email,
    required String username,
    required String phone,
    String? userID
  }
){
   UsersModel usersModel = UsersModel(username,email,phone,userID);
    FirebaseFirestore.instance.collection('users').doc(userID!).set(usersModel.toMap())
    .then((value) {
      emit(RegisterCreateUserSuccessStates());

    })
    .catchError((error){
            print(error.toString());
            emit(RegisterCreateUserErrorStates());

    });
}

}



import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:pazar/admin/admin_cubit/admin_cubits.dart';
import 'package:pazar/admin/admin_cubit/admin_states.dart';
import 'package:pazar/admin/models/product_model.dart';
import 'package:pazar/shared/components/components.dart';
import 'package:pazar/shared/styles/colors.dart';

class EditProducts extends StatefulWidget {
  ProductModel? model; 
  String? productID;
EditProducts(
  this.model,
  this.productID
);

  @override
  _EditProductsState createState() => _EditProductsState(model,productID);
}

class _EditProductsState extends State<EditProducts> {


    ProductModel? model; 
  String? productID;
_EditProductsState(
  this.model,
  this.productID
);
TextEditingController productNameController = TextEditingController();


  TextEditingController descController = TextEditingController();

 TextEditingController priceController = TextEditingController();


  int? oldPrice;
  int? discount;


 String? drobdownValue;
      var bottomSheetController;
 var formKey = GlobalKey<FormState>();
   var date = DateTime.now();
   String categoryName='';

   var title='';
String? catName;



 @override
 void initState() {
   super.initState();
     productNameController.text=model!.name.toString();
      descController.text=model!.description.toString();
       priceController.text=model!.price.toString();
        catName=model!.categoryName.toString();
    
 }
  @override
  Widget build(BuildContext context) {
      return BlocConsumer<AdminCubits , AdminStates>(
      listener: (context,state){
          if(state is AdminEditCategorySuccessStates ){
           showToast(text: 'Edited Successfully', states: ToastStates.SUCCESS);
            title=AdminCubits.get(context).model!.name!;

           productNameController.text='';
           
         }else if(state is AdminEditCategoryErrorStates ){
            showToast(text: 'There is an error occured', states: ToastStates.ERROR);
         }
      },
      builder: (context,state){
       var cubit = AdminCubits.get(context);
     

        return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title:title ==''?Text('${productNameController.text}',style: TextStyle(fontSize: 20,fontWeight: FontWeight.w800,color: defaultColor),):
        Text(title,style: TextStyle(fontSize: 20,fontWeight: FontWeight.w800,color: defaultColor),)
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            
            children: [
              //SizedBox(height: MediaQuery.of(context).size.height/22,),
              Stack(
                alignment: AlignmentDirectional.bottomEnd,
                children: [
                  Image(
                    width: 150,
                    height: 180,
                    image:cubit.productImage==null?NetworkImage('${model!.image}'):
                     FileImage(cubit.productImage!)as ImageProvider
                    ),
                   
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
                 SizedBox(height: 20,),

              defaultTextField(
                
                borderColor: defaultColor,
                
                controller: productNameController,
              
                hintText: 'Enter name of Product',
                iconColor: defaultColor,
                prefixIcon: Icons.category_outlined,
               
                type: TextInputType.text,
                validate: (value){
                  if(value.toString().isEmpty){
                    return 'please enter name of product';
                  }
                  return null;
                }
                
                ),
                 SizedBox(height: 10,),
                    defaultTextField(
                borderColor: defaultColor,
                controller: descController,
                hintText: 'Enter description of Product',
                iconColor: defaultColor,
                prefixIcon: Icons.info,
                type: TextInputType.text,
                validate: (value){
                  if(value.toString().isEmpty){
                    return 'please enter Description of product';
                  }
                  return null;
                }
                
                ),
                  
                SizedBox(height: 10,),
                    defaultTextField(
                borderColor: defaultColor,
                controller: priceController,
                hintText: 'Enter price of Product',
                iconColor: defaultColor,
                prefixIcon: Icons.price_change_outlined,
                type: TextInputType.text,
                validate: (value){
                  if(value.toString().isEmpty){
                    return 'please enter price of product';
                  }
                  return null;
                }
                
                ),
               

                                    SizedBox(height: 10,),
                  Container(
                    height: 50,

                   width: double.infinity,
                   child: TextButton(
                     
                    child: Text(
                      categoryName==''?model!.categoryName!:categoryName.toUpperCase(),
                      style: TextStyle(fontSize: 22,fontWeight: FontWeight.bold)
                    ),
                    style: ButtonStyle(
                      padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.all(15)),
                      foregroundColor: MaterialStateProperty.all<Color>(defaultColor),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25.0),
                          
                          side: BorderSide(color: defaultColor)
                        )
                      )
                    ),
                    onPressed: () {
                      
                         bottomSheetController=showModalBottomSheet(
                      
                           
                           context: context, 
                           builder: (context){
                             return ListView.separated(
                               itemBuilder: (context,index){
                                 return Padding(
                                   padding: const EdgeInsets.all(20.0),
                                   child: Column(
                                     crossAxisAlignment: CrossAxisAlignment.start,
                                     children: [
                                       
                                          InkWell(
                                            onTap: (){
                                           setState(() {
                                             categoryName=cubit.allCategory![index].name!;
                                           });
                                             Navigator.pop(context);
                                         },
                                            child: Row(
                                              children: [
                                                Text('${cubit.allCategory![index].name}',
                                                   style: TextStyle(fontSize: 22,fontWeight: FontWeight.bold),),
                                              ],
                                            ),
                                          )
                                         
                                     ],
                                   ),
                                 );
                               },
                                separatorBuilder: (context,index)=>Divider(indent: 10,endIndent: 10,color: defaultColor,),
                                 itemCount: cubit.allCategory!.length
                                 );
                           }
                           );


                      
                    }
                ),
                 ),
                SizedBox(height: 10,),
             defaultButton(
               background: defaultColor,
               text: 'Edit Product',
               function: (){

                 if(int.parse(priceController.text)!=model!.price){
                  setState(() {
                    oldPrice = model!.price;
                    discount= int.parse(priceController.text)- oldPrice!;
                  });
                 }else{
                   setState(() {
                      oldPrice = 0;
                    discount= 0;
                   });

                 }
              
                
                  if(cubit.productImage!=null){
                    cubit.editProduct(
                      productName: productNameController.text,
                   desc: descController.text,
                   categoryName: categoryName.toString().toLowerCase(),
                   discount: discount!.abs(),
                   oldPrice: oldPrice,
                   productID: productID,
                   price: int.parse(priceController.text),
                    );

                

                  }else{
                     cubit.editProuctData(
                   productName: productNameController.text,
                   desc: descController.text,
                   categoryName: categoryName==''?model!.categoryName:categoryName.toString().toLowerCase(),
                   discount: discount!.abs(),
                   oldPrice: oldPrice,
                   productID: productID,
                   price: int.parse(priceController.text),
                   prodImage: model!.image

                   
                 );
                    setState(() {
                      cubit.getAllProducts();
                    });
                     
                  }
        
                     
                              
 
                

               },
               width: double.infinity,
               textColor: Colors.white,
               textFontSize: 22,

             ),
             SizedBox(height:15),
             if(state is AdminEditProductLoadingStates)
             LinearProgressIndicator(color: defaultColor,backgroundColor: Colors.deepOrange[200],)
            ],
          ),
        ),
      ),);
      },
    );
  }
}
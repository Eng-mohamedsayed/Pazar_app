

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:pazar/admin/admin_cubit/admin_cubits.dart';
import 'package:pazar/admin/admin_cubit/admin_states.dart';
import 'package:pazar/admin/categories/edit_categories.dart';
import 'package:pazar/admin/models/category_model.dart';
import 'package:pazar/admin/models/product_model.dart';
import 'package:pazar/admin/products/edit_products.dart';
import 'package:pazar/shared/components/components.dart';
import 'package:pazar/shared/styles/colors.dart';

class AllProducts extends StatelessWidget {


  Widget build(BuildContext context) {

    return BlocConsumer<AdminCubits,AdminStates>
    (
    listener: (context,state){},
    builder: (context,state){
      var cubit  =AdminCubits.get(context);
      return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('All Products',style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
      ),
      body: ConditionalBuilder(
        condition: state is! AdminGetAllProductsLoadingStates && cubit.allProducts!.length>0 , 
        builder: (context)=>ListView.separated(
        itemBuilder: (context,index){
          var productModel = cubit.allProducts![index];
          return buildCategoryItems(productModel,context,cubit.productID[index]);
        }, 
        separatorBuilder: (context,index)=>SizedBox(height: 1,), 
        itemCount: cubit.allProducts!.length
        ),
        fallback: (context)=>Center(child: CircularProgressIndicator(),)
        )
    );
    },
    );
  }

  Widget buildCategoryItems(ProductModel model , context , String productID)
{
   String? formattedDate = DateFormat('yyyy-MM-dd').format(DateTime.parse(model.dateTime!));
   var bottomSheetController;

   return Container(
                    margin:EdgeInsets.all(8.0),
                    child: Card(
                      color: Colors.grey[200],
                      elevation: 5,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8.0))),
                        child: Padding(
                         padding: EdgeInsets.only(top: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                           
                               children: [
                                   Center(
                                     child: ClipRRect(
                                       borderRadius: BorderRadius.only(
                                         topLeft: Radius.circular(8.0),
                                         topRight: Radius.circular(8.0),
                                       ),
                                       child: Image.network(
                                         '${model.image}',
                                         width: 300,
                                         height: 150,
                                         fit:BoxFit.fill  
                        
                                       ),
                                     ),
                                   ),
                                   SizedBox(height: 10,),
                                   Padding(
                                     padding: const EdgeInsets.symmetric(horizontal: 20),
                                     child: Column(
                                       crossAxisAlignment: CrossAxisAlignment.start,
                                       children: [
                                         Text('${model.name}',style: TextStyle(fontSize: 22,fontWeight: FontWeight.bold,color: defaultColor),maxLines: 1,overflow: TextOverflow.ellipsis,),
                                                                                     SizedBox(height: 10,),

                                         Text('${model.categoryName}',style: TextStyle(fontSize: 18,fontWeight: FontWeight.w600),maxLines: 1,overflow: TextOverflow.ellipsis,),
                                          SizedBox(height: 10,),
                                         Text('${model.description}',
                                         style: TextStyle(fontSize: 14,fontWeight: FontWeight.w400,color: Colors.black54),
                                         overflow: TextOverflow.ellipsis,
                                         maxLines: 1,
                                         ),
                                          SizedBox(height: 5,),


                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text('${model.price}',style: TextStyle(fontSize: 18,fontWeight: FontWeight.w600),),
                                               Row(
                                                 children: [
                                                   Container(
                                                     decoration: BoxDecoration(
                                                       shape: BoxShape.circle,
                                                       color: Colors.green,
                                                     ),
                                                     
                                                     child: IconButton(onPressed: (){
                                                       navigateTo(context, EditProducts(model , productID));

                                                     }, icon: Icon(Icons.edit,color: Colors.white,))
                                                     ),
                                                     SizedBox(width: 10,),
                                                    Container(
                                                     decoration: BoxDecoration(
                                                       shape: BoxShape.circle,
                                                       color: Colors.red,
                                                     ),
                                                     
                                                     child: IconButton(onPressed: (){
                                                        FirebaseFirestore.instance.collection('products').doc(productID).delete().then((value) {
                                                        showToast(text: 'Deleted Successfully', states: ToastStates.SUCCESS);
                                                      });

                                                       
                                                       


                                                     }, icon: Icon(Icons.delete,color: Colors.white,))
                                                     ),
                                                 ],
                                               ),



                                            ],
                                          ),
                                          SizedBox(height: 15,)
                                       ],
                                     ),
                                   ),

                               ],
                          ),
                        ),
                    ),
              );

    // return Padding(
    //     padding: const EdgeInsets.all(20.0),
    //     child: Column(
    //       crossAxisAlignment: CrossAxisAlignment.start,
    //       children: [
    //         Row(
    //           children: [
    //             Image(
    //               width: 120,
    //               height: 120,
    //               image: NetworkImage('${model.image}')
    //               ),
    //               SizedBox(width: 10,),
    //             Container(
    //               width: 140,
    //               child: Column(
    //                 mainAxisSize: MainAxisSize.min,
    //                     crossAxisAlignment: CrossAxisAlignment.start,
                  
    //                 children: [
    //                   Text('${model.name}',style: TextStyle(fontSize: 22,fontWeight: FontWeight.w800,color: defaultColor),),
    //                        SizedBox(height: 10,),
                  
    //                  Text('${model.description}',style: TextStyle(fontSize: 14,color: Colors.grey),maxLines: 2,overflow: TextOverflow.ellipsis,),
    //                   SizedBox(height: 10,),
                  
    //                   Text('${model.categoryName}',style: TextStyle(fontSize: 14,fontWeight: FontWeight.w800),),
                  
    //                   SizedBox(height: 10,),
    //                   Text(formattedDate,style: TextStyle(fontSize: 14,fontWeight: FontWeight.w800,color: Colors.black54),)
    //                 ],
    //               ),
    //             ),
    //             Spacer(),
                
    //             IconButton(onPressed: (){
    //              bottomSheetController= showBottomSheet(
    //                 context: context, 
    //                 builder: (context){
    //                   return Container(
    //                   height: MediaQuery.of(context).size.height  * 0.18,
    //                   child: Padding(
    //                     padding: const EdgeInsets.all(20.0),
    //                     child: Column(
    //                       children: [
    //                         InkWell(
    //                           onTap: (){
    //                            navigateTo(context, EditProducts(model , productID));

    //                              bottomSheetController.close();
    //                           },
    //                           child: Row(
    //                             children: [
    //                               Icon(MdiIcons.pencil,color:Colors.green,size: 32,),
    //                               SizedBox(width: 10,),
    //                               Text('Edit Product',style: TextStyle(fontSize: 18,fontWeight:FontWeight.w800,color:Colors.green))
    //                             ],
    //                           ),
    //                         ),
    //                         SizedBox(height: 20,),
    //                          InkWell(
    //                             onTap: (){
    //                               FirebaseFirestore.instance.collection('products').doc(productID).delete().then((value) {
    //                                  Navigator.pop(context);
    //                                 showToast(text: 'Deleted Successfully', states: ToastStates.SUCCESS);
    //                               });

    //                           },
    //                            child: Row(
    //                             children: [
    //                               Icon(MdiIcons.delete,color:Colors.red,size: 32),
    //                                SizedBox(width: 10,),
                             
    //                               Text('Delete Product',style: TextStyle(fontSize: 18,fontWeight:FontWeight.w800,color:Colors.red))
    //                             ],
    //                         ),
    //                          ),
                          
                            
    //                       ],
    //                     ),
    //                   ),
    //                 );
    //                           }
    //                 );
    //             }, icon: Icon(MdiIcons.dotsHorizontal,size: 32,))

    //           ],
    //         ),

    //       ],
    //     ),
    //   );
  }
}
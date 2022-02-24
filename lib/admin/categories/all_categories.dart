

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
import 'package:pazar/admin/products/edit_products.dart';
import 'package:pazar/shared/components/components.dart';
import 'package:pazar/shared/styles/colors.dart';

class AllCategories extends StatelessWidget {


  Widget build(BuildContext context) {

    return BlocConsumer<AdminCubits,AdminStates>
    (
    listener: (context,state){},
    builder: (context,state){
      var cubit  =AdminCubits.get(context);
      return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('All Categories',style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
      ),
      body: ConditionalBuilder(
        condition: state is! AdminGetAllCategoryLoadingStates && cubit.allCategory!.length>0 , 
        builder: (context)=>ListView.separated(
        itemBuilder: (context,index){
          var catModel = cubit.allCategory![index];
          return buildCategoryItems(catModel,context,cubit.catID[index]);
        }, 
        separatorBuilder: (context,index)=>Divider(color: Colors.grey[400],thickness: 1.5,endIndent: 25,indent: 25,), 
        itemCount: cubit.allCategory!.length
        ),
        fallback: (context)=>Center(child: CircularProgressIndicator(),)
        )
    );
    },
    );
  }

  Widget buildCategoryItems(CategoryModel model , context , String catID)
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
                                         Text('${model.name}',style: TextStyle(fontSize: 18,fontWeight: FontWeight.w600,color: defaultColor),maxLines: 1,overflow: TextOverflow.ellipsis,),
                                                                                     SizedBox(height: 10,),

                                           Row(
                                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                 children: [
                                                  defaultButton(
                                                    background: Colors.green,
                                                    text: 'Edit',
                                                    textColor: Colors.white,
                                                    function: (){
                                                      navigateTo(context, EditCategories(model , catID));

   

                                                    },
                                                    width: 100
                                                  ),
                                                     SizedBox(width: 10,),
                                                    defaultButton(
                                                    background: Colors.red,
                                                    text: 'Delete',
                                                    textColor: Colors.white,
                                                    function: (){
                                                      FirebaseFirestore.instance.collection('category').doc(catID).delete().then((value) {
                                                            showToast(text: 'Deleted Successfully', states: ToastStates.SUCCESS);
                                                          });
                                                      
                                                    },
                                                        width: 100

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
    //             SizedBox(width: 10,),
    //             Column(
    //                   crossAxisAlignment: CrossAxisAlignment.start,

    //               children: [
    //                 Text('${model.name}',style: TextStyle(fontSize: 18,fontWeight: FontWeight.w800),),
    //                 SizedBox(height: 25,),
    //                 Text(formattedDate,style: TextStyle(fontSize: 14,fontWeight: FontWeight.w800,color: Colors.black54),)
    //               ],
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
    //                            navigateTo(context, EditCategories(model , catID));

    //                              bottomSheetController.close();
    //                           },
    //                           child: Row(
    //                             children: [
    //                               Icon(MdiIcons.pencil,color:Colors.green,size: 32,),
    //                               SizedBox(width: 10,),
    //                               Text('Edit Category',style: TextStyle(fontSize: 18,fontWeight:FontWeight.w800,color:Colors.green))
    //                             ],
    //                           ),
    //                         ),
    //                         SizedBox(height: 20,),
    //                          InkWell(
    //                             onTap: (){
    //                               FirebaseFirestore.instance.collection('category').doc(catID).delete().then((value) {
    //                                  Navigator.pop(context);
    //                                 showToast(text: 'Deleted Successfully', states: ToastStates.SUCCESS);
    //                               });

    //                           },
    //                            child: Row(
    //                             children: [
    //                               Icon(MdiIcons.delete,color:Colors.red,size: 32),
    //                                SizedBox(width: 10,),
                             
    //                               Text('Delete Category',style: TextStyle(fontSize: 18,fontWeight:FontWeight.w800,color:Colors.red))
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



import 'package:flutter/material.dart';
import 'package:pazar/shared/components/components.dart';
import 'package:pazar/shared/styles/colors.dart';

class DeleteProducts extends StatelessWidget {
  const DeleteProducts({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
     return Scaffold(
       appBar: AppBar(),
      body: ListView(
          children: <Widget>[
              Container(
                    margin:EdgeInsets.all(8.0),
                    child: Card(
                      color: Colors.grey[200],
                      elevation: 5,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8.0))),
                        child: InkWell(
                           onTap: () => print("ciao"),     
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
                                            'https://firebasestorage.googleapis.com/v0/b/pazar-48c4e.appspot.com/o/products%2Fimage_picker1214025836798962091.jpg?alt=media&token=e2e06505-6473-4a53-8d07-65741212f22b',
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
                                            Text('Product 1 Product 1 Product 1 Product 1',style: TextStyle(fontSize: 18,fontWeight: FontWeight.w600,color: defaultColor),maxLines: 1,overflow: TextOverflow.ellipsis,),
                                                                                        SizedBox(height: 10,),

                                            Text('Clothes Clothes',style: TextStyle(fontSize: 18,fontWeight: FontWeight.w600),maxLines: 1,overflow: TextOverflow.ellipsis,),
                                             SizedBox(height: 10,),
                                            Text('Description',
                                            style: TextStyle(fontSize: 18,fontWeight: FontWeight.w600,color: defaultColor),
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 1,
                                            ),


                                             Row(
                                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                               children: [
                                                 Text('100',style: TextStyle(fontSize: 18,fontWeight: FontWeight.w600),),
                                                  Row(
                                                    children: [
                                                      Container(
                                                        decoration: BoxDecoration(
                                                          shape: BoxShape.circle,
                                                          color: Colors.green,
                                                        ),
                                                        
                                                        child: IconButton(onPressed: (){
                                                          print('edit');
                                                        }, icon: Icon(Icons.edit,color: Colors.white,))
                                                        ),
                                                        SizedBox(width: 10,),
                                                       Container(
                                                        decoration: BoxDecoration(
                                                          shape: BoxShape.circle,
                                                          color: Colors.red,
                                                        ),
                                                        
                                                        child: IconButton(onPressed: (){
                                                          print('delete');
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
                    ),
              )],
    ));
  }
}
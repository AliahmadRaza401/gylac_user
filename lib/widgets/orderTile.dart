import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'custom_text.dart';

class OrderTile extends StatelessWidget
{
  final String pickup;
  final String des;
  final int price;
  final String status;
  final String? id;
  final String orderstatus;
  const OrderTile({Key? key,required this.des,required this.price,required this.status,required this.pickup, this.id,
    required this.orderstatus}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top:8.0,left: 10,right: 10,bottom: 10),
      child: Container(
        alignment: Alignment.center,
        height: 380,
        width: 350,
        decoration: BoxDecoration(
                                      border: Border.all(
                                      color:Color.fromRGBO(250, 190, 19, 1),
                                      style: BorderStyle.solid,
                                      width: 1.0,
                                  ),
                                      borderRadius: BorderRadius.circular(10),
                                      color: Colors.white
                                    ),
        child:Column(children: [
          Divider(),
              SingleChildScrollView(
              child:ListTile(
                leading:  FlatButton.icon(
                    onPressed: () async {
                   
                    },
                    icon: Image.asset("assets/images/package.png",height: 30,width: 30,),
                    label: Text(""),
                    ),
                    
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    CustomText(
                      text: "Pickup",
                      color:Color.fromRGBO(250, 190, 19, 1)
                    ),
                  ],
                ),
                subtitle:
                Text(
                       pickup,
                      style:TextStyle(fontWeight:FontWeight.bold,),
                      
                      textWidthBasis: TextWidthBasis.longestLine,                
                    ),/* FlatButton.icon(
                    onPressed: () async {
                   
                    },
                    icon: Image.asset("images/package.png",height: 30,width: 30,),
                    label:*/
              ),),
              Divider(),
              SingleChildScrollView(
              child:ListTile(
                leading:FlatButton.icon(
                    onPressed: () async {
                   
                    },
                    icon:Icon(Icons.local_taxi_rounded,color: Color.fromRGBO(250, 190, 19, 1),size: 30,),
                    label:Text("")), 
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    CustomText(
                      text: "Destination",
                      color:Color.fromRGBO(250, 190, 19, 1),
                    ),
                  ],
                ),
                subtitle: Text(
                       des,
                      style:TextStyle(fontWeight:FontWeight.bold,),
                     
                      textWidthBasis: TextWidthBasis.longestLine,               
                    ),/**/
              ),),
              Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  FlatButton.icon(
                      onPressed: null,
                      icon: Icon(Icons.flag),
                      label: Text('Accepted Price Offer :',style: TextStyle(fontWeight:FontWeight.bold,color: Colors.black54),)),
                  FlatButton.icon(
                      onPressed: null,
                      icon: Image.asset("assets/images/money.png",height: 20,width: 20,),
                      label: Text(
                          price.toString()+" MNT",style: TextStyle(fontWeight:FontWeight.bold,color: Colors.black54),)),
                ],
              ),
              Divider(),
              Row(children: [
                Text("Order Status"),
                Text(orderstatus)
                
              ],),
              Divider(),
              
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  RaisedButton(
                    child:Center(child: Text("View Details",
                    style: TextStyle(fontSize: 16.0,fontFamily: "Brand-Bold",color: Colors.black),
                    )),
                    shape:  RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(28.0),
                    ),
                    color: Color.fromRGBO(251, 176, 59,1),
                    onPressed: () async {

                    },
                    
                  ),
                  
                ],
              ),
        ],),


      ),
    );
  }
  
}

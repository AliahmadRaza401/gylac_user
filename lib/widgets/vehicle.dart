import 'package:flutter/material.dart';
class VehicleType extends StatelessWidget {
  final Widget text;
  final Widget? icon;
  final double? w;

  const VehicleType({Key? key,
     this.icon,
    required this.text,
     this.w,
    }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      //onTap: onTap,
      //onLongPress: onLongPress,
      child: Container(
        margin:const EdgeInsets.all(15),
        alignment: Alignment.center,
        
        child: Column(children: [
          Container(
            height: 80,
            width: 80,
            decoration: BoxDecoration(
                                  border: Border.all(
                                  color: const Color.fromRGBO(250, 190, 19, 1),
                                  style: BorderStyle.solid,
                                  width: w!,
                              ),
                                  borderRadius: BorderRadius.circular(50),
                                  color: Colors.black
                                ),
           
            child:Center(child: icon),
          ),
          Padding(
            padding: const EdgeInsets.only(top:10.0),
            child: text,

          ),
        ],),
             ),
    );
  }
}
import 'package:flutter/material.dart';
class DividerWidget extends StatelessWidget{
  final Color colour;

  const DividerWidget({Key? key, required this.colour}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Divider(
          height: 1.0,
          color: colour,
          thickness: 1.0,
    );
     }
  
}



class DividerW extends StatelessWidget {
  

  @override
  Widget build(BuildContext context) {
    return Divider(
      height: 1.0,
      color: Colors.grey[600],
      thickness: 1.0,
      
    );
  }
}
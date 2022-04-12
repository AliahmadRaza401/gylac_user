import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';


class StarsWidget extends StatelessWidget {
  final int? numberOfStars;

  const StarsWidget({Key? key, this.numberOfStars}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      width: 350,
      decoration: BoxDecoration(
                   border: Border.all(
                   color:const Color.fromRGBO(250, 190, 19, 1),
                   style: BorderStyle.solid,
                   width: 1.0,
                       ),
                   borderRadius: BorderRadius.circular(10),
                   color: Colors.white
                  ),
      child:Center(child: 
            RatingBar.builder(
                initialRating: 3,
                minRating: 1,
                direction: Axis.horizontal,
                allowHalfRating: true,
                
                itemCount: 5,
                itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                itemBuilder: (context, _) => const Icon(
                  Icons.star,
                  color: Colors.amber,
                ),
                onRatingUpdate: (rating) {
                  print(rating);
                },
                updateOnDrag: true,
              ),
      )
    );
  }
}

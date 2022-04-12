import 'package:flutter/material.dart';

class DistanceTimeEstimateBox extends StatelessWidget {
  const DistanceTimeEstimateBox({
     required this.etaInMinutes,
     required this.distanceInKM,
  });

  final double etaInMinutes;
  final double distanceInKM;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 40),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:const BorderRadius.only(
          topLeft: Radius.circular(10),
          topRight: Radius.circular(10),
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.7),
            spreadRadius: 5,
            blurRadius: 7,
            offset: Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
             const Text(
                "ETA: ",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                ),
              ),
              Text(
                etaInMinutes == double.infinity
                    ? "Calculating"
                    : "${etaInMinutes.toStringAsFixed(2)} minutes",
                style: const TextStyle(
                  color: Colors.green,
                  fontSize: 18,
                ),
              )
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Distance: ",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                ),
              ),
              Text(
                distanceInKM == double.infinity
                    ? "Calculating"
                    : "${distanceInKM.toStringAsFixed(2)} km",
                style:const TextStyle(
                  color: Colors.blue,
                  fontSize: 18,
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}

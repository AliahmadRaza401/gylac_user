import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../constants/colors.dart';

class NotificationTile extends StatelessWidget {
  final String time;
  final String title;
  final String msg;
  final String status;
  const NotificationTile(
      {Key? key,required this.time,required this.msg,required this.title,required this.status})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 10, right: 10, left: 10,bottom: 10),
      margin: EdgeInsets.only(top: 10, right: 10, left: 10),
      decoration: BoxDecoration(
        color: white,
        borderRadius: BorderRadius.circular(5),
        border: Border.all(color: textFieldStroke, width: 1),
        boxShadow: [
          BoxShadow(
              offset: Offset(2, 2),
              color: black.withOpacity(0.25),
              blurRadius: 5)
        ],
      ),
      child: Column(
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,

            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  status == "completed"?Image.asset("assets/images/Correct_sign_1_freepik 4.png",width: 30,height: 30,):
                  status == "cancelled"?Image.asset("assets/images/orderFailed.png",width: 30,height: 30,):
                  status == "failed"?Image.asset("assets/images/orderFailed.png",width: 30,height: 30,):
                  status == "rejected"?Image.asset("assets/images/package.png",width: 30,height: 30,):
                  status == "paymentDone"?Image.asset("assets/images/orderSuccess.png",width: 30,height: 30,):
                  Icon(Icons.notifications,color: Color.fromRGBO(251, 176, 59,1),),

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        "$title",
                        style: TextStyle(
                          fontFamily: 'Poppins',
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      SizedBox(
                        width: 280,
                        child: Text(
                          "$msg",
                          style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 12, fontWeight: FontWeight.w300),
                        ),
                      )
                    ],
                  ),
                ],
              ),
              Text("$time",style: TextStyle(fontSize: 13,fontWeight: FontWeight.bold),)
            ],
          ),

        ],
      ),
    );
  }
}

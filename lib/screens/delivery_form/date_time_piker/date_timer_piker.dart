
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';

import 'package:flutter/material.dart';
import 'package:gyalcuser_project/providers/create_delivery_provider.dart';
import 'package:gyalcuser_project/utils/app_colors.dart';
import 'package:intl/intl.dart';

import 'package:provider/provider.dart';

import '../../../constants/colors.dart';
import '../../../widgets/custom_btn.dart';
import 'package:get/get.dart';

class DateTimeForm extends StatefulWidget {
  @override
  _DateTimeFormState createState() => _DateTimeFormState();
}

class _DateTimeFormState extends State<DateTimeForm> {
  final formKey = GlobalKey<FormState>();
  DateTime selectedDate = DateTime.now();
  var currentDate;
  var currentTime;
  DateTime now = DateTime.now();
  TimeOfDay? time;
  final format = DateFormat("yyyy-MM-dd");
  final timeFormat = DateFormat("hh:mm a");
  late CreateDeliveryProvider deliveryProvider;
  var currentDateTime;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    deliveryProvider = Provider.of<CreateDeliveryProvider>(context, listen: false);

  }


  @override
  Widget build(BuildContext context) {
    final deliveryProvider = Provider.of<CreateDeliveryProvider>(context);
    return AlertDialog(
        insetPadding: const EdgeInsets.all(20),
      contentPadding:const EdgeInsets.all(0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(25),
      ),
      content: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(25),
          border: Border.all(
            color:
            AppColors.primaryColor, //                   <--- border color
            width: 3.0,
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.orangeColor.withOpacity(0.5),
              spreadRadius: 3,
              blurRadius: 4,
              offset: Offset(0, 3), // changes position of shadow
            ),
          ],
        ),
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height * 0.55,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  alignment: Alignment.centerLeft,
                  margin: const EdgeInsets.symmetric(
                    vertical: 0,
                    horizontal: 10,
                  ),
                  child:  Text(
                    "SELECT TIME & DATE".tr,
                    style: TextStyle(
                      color: orange,

                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),

                  ),
                ),
                const SizedBox(height: 15),
                Container(
                  decoration: BoxDecoration(
                    color: orange,
                    borderRadius: BorderRadius.circular(35),

                  ),
                  padding: EdgeInsets.all(15),
                  child: Form(
                    key: formKey,
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(DateFormat.yMMMMd('en_US').format(now).toString(),
                                  style: const TextStyle(

                                      color: Colors.white,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600)),
                              Text(DateFormat.jm().format(now).toString(),
                                  style: const TextStyle(

                                      color: Colors.white,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600)),
                            ],
                          ),
                          const SizedBox(height: 10),
                         // BasicDateField(selectedDate: selectedDate,),
                          Container(
                            width: 250,

                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 5,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),

                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.orangeColor.withOpacity(0.5),
                                  spreadRadius: 3,
                                  blurRadius: 4,
                                  offset: const Offset(0, 3), // changes position of shadow
                                ),
                              ],
                            ),
                            child: Column(children: <Widget>[
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  Text(
                                    'Select date '.tr,
                                    style: TextStyle(
                                      color: AppColors.orangeColor,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 15,
                                      fontFamily: 'Poppins'
                                    ),
                                  ),
                                  Icon(
                                    Icons.calendar_today,
                                    color: AppColors.orangeColor,
                                    size: 25,
                                  )
                                ],
                              ),
                              DateTimeField(
                                format: format,
                                onShowPicker: (context, currentValue) async{
                                  final date =await showDatePicker(
                                    context: context,
                                    firstDate: DateTime(1900),
                                    initialDate: currentValue ?? DateTime.now(),
                                    lastDate: DateTime(2200),);
                                  if (date != null && date !=selectedDate ) {
                                   selectedDate = date;
                                   deliveryProvider.date = format.format(selectedDate).toString();
                                   return selectedDate;

                                 }
                                  else {
                                    return currentValue;
                                  }

                                },

                              ),
                            ]),
                          ),
                          const SizedBox(height: 15),
                          //BasicTimeField(time:time, selectedDate: selectedDate,),
                          Container(
                            width: 250,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 5,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.orangeColor.withOpacity(0.5),
                                  spreadRadius: 3,
                                  blurRadius: 4,
                                  offset: const Offset(0, 3), // changes position of shadow
                                ),
                              ],
                            ),
                            child: Column(children: <Widget>[
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  Text(
                                    'Select Time '.tr,
                                    style:  TextStyle(
                                      color: AppColors.orangeColor,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 15,
                                        fontFamily: 'Poppins'
                                    ),

                                  ),
                                  Icon(
                                    Icons.watch_later_outlined,
                                    color: AppColors.orangeColor,
                                    size: 25,
                                  )
                                ],
                              ),
                              DateTimeField(
                                format: timeFormat,
                                onShowPicker: (context, currentValue) async {
                                  time = await showTimePicker(
                                    context: context,
                                    initialTime: TimeOfDay.fromDateTime(currentValue ?? DateTime.now()),
                                  );
                                  setState(() {
                                    deliveryProvider.time = "${time!.hour}:${time!.minute}:${time!.period.name}";
                                  });
                                  return time == null ? null : DateTimeField.convert(time);

                                },
                              ),
                            ]),
                          ),
                          const SizedBox(
                            height: 10,
                          ),

                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                CustomBtn(
                  onTap: () {
                      Navigator.of(context).pop(true);
                  },
                  bgColor: orange,
                  shadowColor: black,
                  text: 'Save'.tr,
                ),
                TextButton(onPressed: (){
                  Navigator.of(context).pop(true);
                }, child: Text("Cancel".tr,style: TextStyle(color: black, decoration: TextDecoration.underline,),))
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/*class BasicDateField extends StatelessWidget {
  DateTime selectedDate;
  BasicDateField({Key? key,required this.selectedDate}) : super(key: key);
  final format = DateFormat("yyyy-MM-dd");

  @override
  Widget build(BuildContext context) {

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 5,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: AppColors.primaryColor, //                   <--- border color
          width: 3.0,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.orangeColor.withOpacity(0.5),
            spreadRadius: 3,
            blurRadius: 4,
            offset: const Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      child: Column(children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children:const [
             Text(
              'Select date ',
              style: TextStyle(
                color: AppColors.orangeColor,
                fontWeight: FontWeight.w500,
                fontSize: 18,
              ),
            ),
             Icon(
              Icons.calendar_today,
              color: AppColors.orangeColor,
              size: 25,
            )
          ],
        ),

        DateTimeField(
          format: format,
          onShowPicker: (context, currentValue) async{
            final date =await showDatePicker(
                context: context,
                firstDate: DateTime(1900),
                initialDate: currentValue ?? DateTime.now(),
                lastDate: DateTime(2200),);
            if (date != null && date !=selectedDate ) {
              selectedDate = date;
                deliver = ;

            } else {
              return currentValue;
            }

          },

        ),
      ]),
    );
  }
}*/

/*class BasicTimeField extends StatelessWidget {
  DateTime selectedDate;
  TimeOfDay? time;
   BasicTimeField({Key? key,required this.time,required this.selectedDate}) : super(key: key);
  final format = DateFormat("hh:mm a");
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 5,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: AppColors.primaryColor, //                   <--- border color
          width: 3.0,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.orangeColor.withOpacity(0.5),
            spreadRadius: 3,
            blurRadius: 4,
            offset: const Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      child: Column(children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: const[
             Text(
              'Select Time ',
              style:  TextStyle(
                color: AppColors.orangeColor,
                fontWeight: FontWeight.w500,
                fontSize: 18,
              ),
            ),
             Icon(
              Icons.watch_later_outlined,
              color: AppColors.orangeColor,
              size: 25,
            )
          ],
        ),
        DateTimeField(
          format: format,
          onShowPicker: (context, currentValue) async {
             time = await showTimePicker(
              context: context,
              initialTime: TimeOfDay.fromDateTime(currentValue ?? DateTime.now()),
            );
            print('time: $time');
            
            return time == null ? null : DateTimeField.convert(time);
            
          },
        ),
      ]),
    );
  }
}*/

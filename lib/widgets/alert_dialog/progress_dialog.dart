// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';

class ProgressDialog extends StatelessWidget {
  String message;

  ProgressDialog({required this.message});
  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Color(0xffE3F2FD),
      child: Container(
        margin: const EdgeInsets.all(15),
        width: double.infinity,
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(6)),
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Row(
            children: [
              const SizedBox(width: 6),
              const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
              ),
              const SizedBox(width: 25),
              Text(
                message,
                style: const TextStyle(color: Colors.black, fontSize: 10),
              )
            ],
          ),
        ),
      ),
    );
  }
}

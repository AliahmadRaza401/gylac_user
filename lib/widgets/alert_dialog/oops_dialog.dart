import 'package:flutter/material.dart';

import '../app_buttons.dart';

class OopsDialog extends StatelessWidget {
  final String message;

  const OopsDialog({Key? key, required this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(25),
      ),
      content: Padding(
        padding: const EdgeInsets.all(25.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            // ignore: prefer_const_constructors
            Text(
              'OOPS!',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
                color: Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 30),
            Text(
              message,
              style: TextStyle(fontSize: 18),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 30),
            NormalButton(
              buttonText: "OK",
              onTap: () => Navigator.pop(context),
            )
          ],
        ),
      ),
    );
  }
}


import 'package:fluence_for_influencer/shared/constants.dart';
import 'package:flutter/material.dart';

class AppButton extends StatelessWidget {
  final String buttonName;
  final dynamic press;

  const AppButton({
    Key? key,
    required this.buttonName,
    required this.press,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: press,
        style: ButtonStyle(
          shape:
              MaterialStateProperty.all<OutlinedBorder>(RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          )),
          backgroundColor:
              MaterialStateProperty.all<Color>(Constants.primaryColor),
        ),
        child: Text(buttonName, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500)));
  }
}

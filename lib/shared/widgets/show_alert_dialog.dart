import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

/*
  Cara panggil:
  showDialog(context: context, builder: (context) => showAlertDialog(context, ...));
  Contoh ada di influencer_upload_portfolio.dart, di method createDialog
*/

Widget showAlertDialog(BuildContext context, Text dialogTitle, Text dialogContent,
                    TextButton primaryButton, TextButton? secondaryButton) {

  List<Widget> actionsButton = [primaryButton];
  if(secondaryButton != null) actionsButton.add(secondaryButton);
  
  return AlertDialog(
    title: dialogTitle,    
    content: dialogContent,
    actions: actionsButton,
    elevation: 24.0,
  );
}

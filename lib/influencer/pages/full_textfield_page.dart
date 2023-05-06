import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

import 'package:fluence_for_influencer/shared/widgets/text_input.dart';
import 'package:fluence_for_influencer/shared/constants.dart';

class FullTextfieldPage extends StatelessWidget {
  const FullTextfieldPage(
      {super.key, required this.field, required this.fieldController});

  final String field;
  final TextEditingController fieldController;
  // final

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: buildAppBar(context), body: buildBody(context));
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      title: Text(field, style: const TextStyle(color: Constants.primaryColor)),
      iconTheme: const IconThemeData(color: Constants.primaryColor),
      elevation: 0,
      backgroundColor: Colors.white,
      actions: [
        Container(
          margin: const EdgeInsets.only(right: 15.0),
          alignment: Alignment.center,
          child: InkWell(
              onTap: () {
                // save
                Navigator.pop(context, fieldController.text);
              },
              child: const Text("Save",
                  style: TextStyle(
                      fontSize: 17.0,
                      color: Constants.primaryColor,
                      fontWeight: FontWeight.w500))),
        ),
      ],
    );
  }

  Widget buildBody(BuildContext context) {
    double margin = 10.0;
    return SingleChildScrollView(
      child: Container(
        height: MediaQuery.of(context).size.height,
        padding: EdgeInsets.symmetric(horizontal: margin * 2),
        width: MediaQuery.of(context).size.width,
        child: TextFormField(
          autofocus: true,
          maxLines: null,
          controller: fieldController,
          decoration: const InputDecoration(
            filled: false,
            hintText: 'Type something...',
            contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 16),
            constraints: BoxConstraints(maxWidth: 150),
            labelStyle: TextStyle(color: Colors.black),
            // Enabled and focused
            focusedBorder: OutlineInputBorder(borderSide: BorderSide.none),
            // Enabled and not showing error
            enabledBorder: OutlineInputBorder(borderSide: BorderSide.none),
            // Has error but not focus
            errorBorder: OutlineInputBorder(borderSide: BorderSide.none),
            // Has error and focus
            focusedErrorBorder: OutlineInputBorder(borderSide: BorderSide.none),
          ),
        ),
      ),
    );
  }
}

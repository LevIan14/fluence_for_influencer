import 'package:flutter/material.dart';
import 'package:fluence_for_influencer/shared/constants.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:ionicons/ionicons.dart';

import 'package:fluence_for_influencer/shared/widgets/text_input.dart';

class DirectingTextfield extends StatelessWidget {
  const DirectingTextfield({super.key, required this.field, required this.fieldController, required this.onTap});

  final String field;
  final TextEditingController fieldController;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    InputDecoration inputDecoration = textInputDecoration;
    ThemeData theme = Theme.of(context);
    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      Container(
          margin: const EdgeInsets.symmetric(vertical: 10),
          child: Text(field,
              style:
                  const TextStyle(color: Constants.primaryColor, fontSize: 15),
              textAlign: TextAlign.left)),
      TextFormField(
        decoration: inputDecoration.copyWith(
          suffixIcon: const Icon(Ionicons.chevron_forward_outline, color: Constants.grayColor)
        ),
        readOnly: true,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        controller: fieldController,
        keyboardType: TextInputType.text,
        obscureText: false,
        onTap: onTap,
      ),
    ]);
  }
}
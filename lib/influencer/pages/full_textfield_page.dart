import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

import 'package:fluence_for_influencer/shared/widgets/text_input.dart';

class FullTextfield extends StatelessWidget {
  const FullTextfield({super.key});

  @override
  Widget build(BuildContext context) {
    InputDecoration inputDecoration = textInputDecoration;
    ThemeData theme = Theme.of(context);
    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      // Container(
      //     margin: const EdgeInsets.symmetric(vertical: 10),
      //     child: Text(field,
      //         style:
      //             const TextStyle(color: Constants.primaryColor, fontSize: 15),
      //         textAlign: TextAlign.left)),
      // TextFormField(
      //   decoration: inputDecoration,
      //   readOnly: isReadOnly,
      //   autovalidateMode: AutovalidateMode.onUserInteraction,
      //   controller: fieldController,
      //   keyboardType: keyboardType,
      //   obscureText: isObscure,
      //   validator: (value) => validator(value),
      //   onChanged: (value) {},
      //   onTap: () => onTap!(context),
      // ),
    ]);
  }
}
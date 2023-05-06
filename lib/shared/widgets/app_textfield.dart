import 'package:fluence_for_influencer/shared/constants.dart';
import 'package:fluence_for_influencer/shared/widgets/text_input.dart';
import 'package:flutter/material.dart';

class AppTextfield extends StatelessWidget {
  const AppTextfield({
    super.key,
    this.isObscure = false,
    this.keyboardType = TextInputType.text,
    this.isReadOnly = false,
    this.isEraseAll = false,
    this.onTap,
    required this.field,
    required this.fieldController,
    required this.validator,
  });

  final bool isObscure;
  final TextInputType keyboardType;
  final String field;
  final bool isReadOnly;
  final bool isEraseAll;
  final TextEditingController fieldController;
  final Function(String?) validator;
  final Future<void> Function()? onTap;

  @override
  Widget build(BuildContext context) {
    InputDecoration inputDecoration = textInputDecoration;
    if (isEraseAll) {
      inputDecoration.copyWith(
          suffixIcon: IconButton(
        icon: const Icon(Icons.close),
        onPressed: () => fieldController.text = "",
      ));
    }
    ThemeData theme = Theme.of(context);
    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      Container(
          margin: const EdgeInsets.symmetric(vertical: 10),
          child: Text(field,
              style:
                  const TextStyle(color: Constants.primaryColor, fontSize: 15),
              textAlign: TextAlign.left)),
      TextFormField(
        decoration: inputDecoration,
        readOnly: isReadOnly,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        controller: fieldController,
        keyboardType: keyboardType,
        obscureText: isObscure,
        validator: (value) => validator(value),
        onChanged: (value) {},
        onTap: onTap != null ? () => onTap : null,
      ),
    ]);
  }
}

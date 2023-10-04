import 'package:flutter/material.dart';

class FormSubmitBtn extends StatelessWidget {
  final void Function() onPressed;
  final String? textBtn;

  const FormSubmitBtn({Key? key, required this.onPressed, this.textBtn = ''})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
        onPressed: onPressed,
        icon:  Icon(textBtn!.isEmpty ?Icons.person_add:Icons.navigate_next),
        label: Text(textBtn!.isEmpty ? 'SingIn With Google' : textBtn.toString()));
  }
}

import '../../bloc/add_delete_update_post/add_delete_update_quetion_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/entities/quetion.dart';
import 'form_submit_btn.dart';
import 'text_form_field_widget.dart';

class FormWidget extends StatefulWidget {
  final bool isUpdatePost;
  final Quetion? post;
  const FormWidget({
    Key? key,
    required this.isUpdatePost,
    this.post,
  }) : super(key: key);

  @override
  State<FormWidget> createState() => _FormWidgetState();
}

class _FormWidgetState extends State<FormWidget> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _titleController = TextEditingController();
  TextEditingController _bodyController = TextEditingController();

  @override
  void initState() {
    if (widget.isUpdatePost) {
      _titleController.text = widget.post!.answer;
      _bodyController.text = widget.post!.question;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TextFormFieldWidget(
                name: "Title", multiLines: false, controller: _titleController),
            TextFormFieldWidget(
                name: "Body", multiLines: true, controller: _bodyController),
            FormSubmitBtn(
                isUpdatePost: widget.isUpdatePost,
                onPressed: validateFormThenUpdateOrAddPost),
          ]),
    );
  }

  void validateFormThenUpdateOrAddPost() {
    final isValid = _formKey.currentState!.validate();

    if (isValid) {
      final post = Quetion(
          id: widget.isUpdatePost ? widget.post!.id : '',
          answer: _titleController.text,
          question: _bodyController.text, options: []);

      if (widget.isUpdatePost) {
        BlocProvider.of<AddDeleteUpdateQuetionBloc>(context)
            .add(UpdateQuetionEvent(quetion: post));
      } else {
        BlocProvider.of<AddDeleteUpdateQuetionBloc>(context)
            .add(AddQuetionEvent(quetion: post));
      }
    }
  }
}

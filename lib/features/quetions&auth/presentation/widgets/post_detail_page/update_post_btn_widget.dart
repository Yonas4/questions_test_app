import 'package:flutter/material.dart';

import '../../../domain/entities/quetion.dart';

import '../../pages/post_add_update_page.dart';

class UpdatePostBtnWidget extends StatelessWidget {
  final Quetion post;
  const UpdatePostBtnWidget({
    Key? key,
    required this.post,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: () {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => PostAddUpdatePage(
                isUpdatePost: true,
                post: post,
              ),
            ));
      },
      icon: Icon(Icons.edit),
      label: Text("Edit"),
    );
  }
}

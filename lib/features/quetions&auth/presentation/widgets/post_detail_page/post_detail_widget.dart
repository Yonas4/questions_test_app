import 'update_post_btn_widget.dart';
import 'package:flutter/material.dart';

import '../../../domain/entities/quetion.dart';
import 'delete_post_btn_widget.dart';

class PostDetailWidget extends StatelessWidget {
  final Quetion quetion;
  const PostDetailWidget({
    Key? key,
    required this.quetion,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Column(
        children: [
          Text(
            quetion.answer,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          Divider(
            height: 50,
          ),
          Text(
            quetion.question,
            style: TextStyle(
              fontSize: 16,
            ),
          ),
          Divider(
            height: 50,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              UpdatePostBtnWidget(post: quetion),
              // DeletePostBtnWidget(postId: post.id!)
            ],
          )
        ],
      ),
    );
  }
}



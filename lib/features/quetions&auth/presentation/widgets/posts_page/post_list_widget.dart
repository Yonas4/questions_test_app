import '../../pages/post_detail_page.dart';
import 'package:flutter/material.dart';

import '../../../domain/entities/quetion.dart';

class PostListWidget extends StatelessWidget {
  final List<Quetion> quetion;
  const PostListWidget({
    Key? key,
    required this.quetion,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: quetion.length,
      itemBuilder: (context, index) {
        return ListTile(
          leading: Text(quetion[index].id.toString()),
          title: Text(
            quetion[index].answer,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          subtitle: Text(
            quetion[index].question,
            style: TextStyle(fontSize: 16),
          ),
          contentPadding: EdgeInsets.symmetric(horizontal: 10),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => PostDetailPage(post: quetion[index]),
              ),
            );
          },
        );
      },
      separatorBuilder: (context, index) => Divider(thickness: 1),
    );
  }
}

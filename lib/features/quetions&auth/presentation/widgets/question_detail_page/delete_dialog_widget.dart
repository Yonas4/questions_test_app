// import '../../bloc/add_delete_update_post/add_update_users_bloc.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
//
// class DeleteDialogWidget extends StatelessWidget {
//   final int postId;
//   const DeleteDialogWidget({
//     Key? key,
//     required this.postId,
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return AlertDialog(
//       title: Text("Are you Sure ?"),
//       actions: [
//         TextButton(
//           onPressed: () => Navigator.of(context).pop(),
//           child: Text(
//             "No",
//           ),
//         ),
//         TextButton(
//           onPressed: () {
//             BlocProvider.of<AddDeleteUpdateQuetionBloc>(context).add(
//               DeleteQuetionEvent(postId: postId),
//             );
//           },
//           child: Text("Yes"),
//         ),
//       ],
//     );
//   }
// }

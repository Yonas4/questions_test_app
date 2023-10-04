import 'dart:async';

import 'package:questions/features/quetions&auth/presentation/bloc/add_update_users/add_update_users_bloc.dart';

import '../../../../../../core/strings/messages.dart';
import '../../../../domain/entities/auth/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../pages/users/leaderbord_page.dart';
import 'form_submit_btn.dart';

class FormWidget extends StatelessWidget {
  final UserData? user;

  FormWidget({Key? key, this.user}) : super(key: key);

  final _formKey = GlobalKey<FormState>();
  late final AddUpdateUserBloc authBloc;
  late StreamSubscription authStream;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Icon(
              Icons.question_mark_sharp,
              size: 200,
            ),
            const SizedBox(height: 70),
            FormSubmitBtn(onPressed: () => updateOrAddPost(context)),
          ]),
    );
  }

  void updateOrAddPost(BuildContext context) {
    // if (isUpdatePost) {
    //   BlocProvider.of<AddUpdateUserBloc>(context)
    //       .add(UpdateUsersEvent(users: user));
    // } else {
    authBloc = context.read<AddUpdateUserBloc>()..add(AddUsersEvent());

    authStream = authBloc.stream.listen((state) {
      if (state is MessageAddUpdateUserState) {
        print('${state.message}testedddddddd');

        if (state.message == IS_TESTED_MESSAGE) {
          print('${state.message}testedddddddd');
          _navigator(context, const LeaderBoardPage());
        }
      }
    });
    // BlocProvider.of<AddUpdateUserBloc>(context).add(AddUsersEvent());
    // }
  }

  _navigator(BuildContext context, rout) {
    Future.delayed(const Duration(seconds: 2))
        .then((_) => Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) {
                return rout;
              }),
              (route) => false,
            ));
  }
}

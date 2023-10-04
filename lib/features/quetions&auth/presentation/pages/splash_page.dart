import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:questions/features/quetions&auth/presentation/bloc/add_update_users/add_update_users_bloc.dart';
import 'package:questions/features/quetions&auth/presentation/pages/quesions/question_page.dart';
import 'package:questions/features/quetions&auth/presentation/pages/users/leaderbord_page.dart';
import 'package:questions/features/quetions&auth/presentation/pages/users/user_add_update_page.dart';

import '../../../../core/strings/messages.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> with TickerProviderStateMixin {
  late final AddUpdateUserBloc authBloc;
  late StreamSubscription authStream;
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    authBloc = context.read<AddUpdateUserBloc>()..add(UserSingIngEvent());

    /// For [animation]
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
    _animation = Tween(begin: 0.0, end: 1.0).animate(_controller);

    authStream = authBloc.stream.listen((state) {
      if (state is MessageAddUpdateUserState) {
        print(state.message.toString()+'uuuuuuuuuuuu');
        if (state.message == SINGING_MESSAGE) {
          //go to home page
          _navigator(context, QuestionPage());
        } else if (state.message == IS_TESTED_MESSAGE) {
          _navigator(context, LeaderBoardPage());
        } else {
          _navigator(context, UserAddPage());
        }
      }
    });
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RotationTransition(
        turns: _animation,
        child: Center(
          child: Icon(
            Icons.question_mark_sharp,
            size: 160.h,
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    authStream.cancel();
    _controller.dispose();
    super.dispose();
  }
}

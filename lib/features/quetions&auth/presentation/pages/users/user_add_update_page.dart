import 'package:questions/features/quetions&auth/domain/entities/auth/user.dart';
import 'package:questions/features/quetions&auth/presentation/bloc/add_update_users/add_update_users_bloc.dart';

import '../../../../../core/widgets/loading_widget.dart';

import '../../widgets/users_widgets/user_add_update_widgets/form_widget.dart';
import '../quesions/question_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/util/snackbar_message.dart';

class UserAddPage extends StatelessWidget {
  final UserData? userData;

  const UserAddPage({
    Key? key,
    this.userData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: _buildAppbar(),
      body: _buildBody(),
    );
  }

  AppBar _buildAppbar() {
    return AppBar(title: Text("Add User"));
  }

  Widget _buildBody() {
    return Center(
      child: Padding(
          padding: const EdgeInsets.all(10),
          child: BlocConsumer<AddUpdateUserBloc, AddUpdateUsersState>(
            listener: (context, state) {
              if (state is MessageAddUpdateUserState) {
                //show don message snackBar
                SnackBarMessage().showSuccessSnackBar(
                    message: state.message, context: context);

                //go to home page
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (_) => const QuestionPage()),
                    (route) => false);
              } else if (state is ErrorAddUpdateUsersState) {
                //show snackBar error
                SnackBarMessage().showErrorSnackBar(
                    message: state.message, context: context);
              }
            },
            builder: (context, state) {
              if (state is LoadingAddUpdateUsersState) {
                return const LoadingWidget();
              }

              return FormWidget(user: userData);
            },
          )),
    );
  }
}

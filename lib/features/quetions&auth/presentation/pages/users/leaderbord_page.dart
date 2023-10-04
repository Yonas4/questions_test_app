import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:questions/features/quetions&auth/presentation/bloc/get_users/get_users_bloc.dart';

import '../../../../../core/widgets/loading_widget.dart';
import '../../widgets/qustion_widgets/message_display_widget.dart';
import '../../widgets/users_widgets/users_list_widget.dart';

class LeaderBoardPage extends StatelessWidget {
  const LeaderBoardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppbar(),
      body: _buildBody(),
    );
  }

  AppBar _buildAppbar() => AppBar(title: const Text('LeaderBoard'));

  Widget _buildBody() {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: BlocBuilder<UsersBloc, UsersState>(
        builder: (context, state) {
          if (state is LoadingUsersState) {
            return const LoadingWidget();
          } else if (state is LoadedUsersState) {
            return RefreshIndicator(
                onRefresh: () => _onRefresh(context),
                child: UsersListWidget(
                  userData: state.userData,
                ));
          } else if (state is ErrorUsersState) {
            return MessageDisplayWidget(message: state.message);
          }
          return const LoadingWidget();
        },
      ),
    );
  }

  Future<void> _onRefresh(BuildContext context) async {
    BlocProvider.of<UsersBloc>(context).add(RefreshUsersEvent());
  }
}

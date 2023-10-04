import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:questions/features/quetions&auth/presentation/bloc/get_quesions/quetion_bloc.dart';

import '../../../../../core/widgets/loading_widget.dart';

import '../../widgets/qustion_widgets/message_display_widget.dart';
import '../../widgets/qustion_widgets/questions_list_widget.dart';

class QuestionPage extends StatelessWidget {
  const QuestionPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppbar(),
      body: _buildBody(),
    );
  }

  AppBar _buildAppbar() => AppBar(title: const Text('Questions'));

  Widget _buildBody() {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: BlocBuilder<QuetionBloc, QuetionState>(
        builder: (context, state) {
          if (state is LoadingQuetionState) {
            return const LoadingWidget();
          } else if (state is LoadedQuetionState) {
            return RefreshIndicator(
                onRefresh: () => _onRefresh(context),
                child: QuestionsListWidget(quetion: state.quetion));
          } else if (state is ErrorQuetionState) {
            return MessageDisplayWidget(message: state.message);
          }
          return const LoadingWidget();
        },
      ),
    );
  }

  Future<void> _onRefresh(BuildContext context) async {
    BlocProvider.of<QuetionBloc>(context).add(RefreshQuetionEvent());
  }
}

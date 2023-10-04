import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:questions/features/quetions&auth/data/models/user_model.dart';
import 'package:questions/features/quetions&auth/presentation/pages/users/leaderbord_page.dart';

import '../../../../../core/util/snackbar_message.dart';
import '../../../../../core/widgets/loading_widget.dart';
import '../../../domain/entities/quetion.dart';
import '../../bloc/add_update_users/add_update_users_bloc.dart';
import '../users_widgets/user_add_update_widgets/form_submit_btn.dart';

class QuestionsListWidget extends StatefulWidget {
  final List<Quetion> quetion;

  QuestionsListWidget({
    Key? key,
    required this.quetion,
  }) : super(key: key);

  @override
  State<QuestionsListWidget> createState() => _QuestionsListWidgetState();
}

class _QuestionsListWidgetState extends State<QuestionsListWidget> {
  final _pageController =
      PageController(initialPage: 0, keepPage: false, viewportFraction: 1);

  List<Map<String, dynamic>> answers = [];
  List<bool> isSelected = [];

  int page = 0;

  @override
  void initState() {
    super.initState();
    widget.quetion.forEach((element) {
      answers.add({
        'qNumber': element.id,
        'answer': element.answer,
        'selected': element.options.first
      });
    });
    widget.quetion.first.options.forEach((element) {
      isSelected.add(false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        PageView.builder(
          itemCount: widget.quetion.length + 1,
          scrollDirection: Axis.horizontal,
          reverse: false,
          pageSnapping: true,
          onPageChanged: (index) {
            setState(() {
              page = index;
            });
            print(page);
          },
          controller: _pageController,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (BuildContext context, int position) {
            return (widget.quetion.length + 1) == position + 1
                ? Container(
                    padding: const EdgeInsets.all(8),
                    margin: EdgeInsets.only(
                        top: 50.h, bottom: 90.h, right: 10.w, left: 10.w),
                    decoration: BoxDecoration(
                        color: Colors.blueAccent,
                        borderRadius: BorderRadius.circular(20)),
                    child: Column(
                      children: List.generate(answers.length, (index) {
                        var reversedList = List.from(answers.reversed);
                        return Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                              color: reversedList[index]['selected'] ==
                                      reversedList[index]['answer']
                                  ? Colors.green
                                  : Colors.red,
                              borderRadius: BorderRadius.circular(20)),
                          alignment: Alignment.centerLeft,
                          padding: EdgeInsets.only(left: 0.w),
                          margin: EdgeInsets.only(top: 3.h, bottom: 3.h),
                          child: ListTile(
                            title: Padding(
                              padding: const EdgeInsets.only(top: 4, bottom: 4),
                              child: Text(
                                'you are select :${reversedList[index]['selected']}',
                                style: TextStyle(fontSize: 18.sp),
                              ),
                            ),
                            leading: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                'Question: ' + reversedList[index]['qNumber'],
                                style: TextStyle(fontSize: 14.sp),
                              ),
                            ),
                            contentPadding: const EdgeInsets.all(10),
                            subtitle: Padding(
                              padding: const EdgeInsets.only(top: 4, bottom: 4),
                              child: Text(
                                'true answer is : ' +
                                    reversedList[index]['answer'],
                                style: TextStyle(
                                    fontSize: 18.sp, color: Colors.black),
                              ),
                            ),
                          ),
                        );
                      }),
                    ),
                  )
                : Container(
                    padding: const EdgeInsets.all(8),
                    margin: EdgeInsets.only(
                        top: 50.h, bottom: 90.h, right: 10.w, left: 10.w),
                    decoration: BoxDecoration(
                        color: Colors.blueAccent,
                        borderRadius: BorderRadius.circular(20)),
                    child: Column(
                      children: [
                        Container(
                            width: double.infinity,
                            height: 40.h,
                            decoration: BoxDecoration(
                                color: Colors.greenAccent,
                                borderRadius: BorderRadius.circular(20)),
                            alignment: Alignment.centerLeft,
                            padding: EdgeInsets.only(left: 20.w),
                            child: Text(
                              'Q (${widget.quetion[position].id}) : ${widget.quetion[position].question}',
                              style: TextStyle(fontSize: 20.sp),
                            )),
                        SizedBox(height: 30.h),
                        SizedBox(
                          width: double.infinity,
                          child: ToggleButtons(
                              onPressed: (int index) {
                                answers[position] = {
                                  'qNumber': widget.quetion[position].id,
                                  'answer': widget.quetion[position].answer,
                                  'selected':
                                      widget.quetion[position].options[index]
                                };
                                setState(() {
                                  for (int i = 0; i < isSelected.length; i++) {
                                    isSelected[i] = i == index;
                                  }
                                });
                              },
                              borderWidth: 2,
                              direction: Axis.vertical,
                              // selectedColor: Colors.red,
                              isSelected: isSelected,
                              fillColor: Colors.yellow,
                              borderRadius: BorderRadius.circular(15),
                              children: List.generate(
                                widget.quetion[position].options.length,
                                (index) => Container(
                                    height: 40.h,
                                    decoration: BoxDecoration(
                                        // color: Colors.white,
                                        borderRadius:
                                            BorderRadius.circular(20)),
                                    alignment: Alignment.centerLeft,
                                    padding: EdgeInsets.only(left: 20.w),
                                    child: Text(
                                      '${widget.quetion[position].options[index]}',
                                      style: TextStyle(fontSize: 20.sp),
                                    )),
                              )),
                        ),
                      ],
                    ),
                  );
          },
        ),
        Positioned(
          bottom: 10.h,
          right: 10.w,
          child: BlocConsumer<AddUpdateUserBloc, AddUpdateUsersState>(
            listener: (context, state) {
              if (state is MessageAddUpdateUserState) {
                //show don message snackBar
                SnackBarMessage().showSuccessSnackBar(
                    message: state.message, context: context);

                //go to home page
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (_) => const LeaderBoardPage()),
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
              return FormSubmitBtn(
                onPressed: page == widget.quetion.length
                    ? () async {
                        final userData =
                            await BlocProvider.of<AddUpdateUserBloc>(context)
                                .localDataSource
                                .getCachedUser();

                        double rate = 0;
                        for (var element in answers) {
                          rate = double.parse(element['answer']) ==
                                  double.parse(element['selected'])
                              ? (100 / answers.length) + rate
                              : ((100 / answers.length) / 2) + rate;
                        }

                        final user = UserDataModel(
                            id: userData.id,
                            name: userData.name,
                            email: userData.email,
                            photourl: userData.photourl,
                            rate: rate.toString(),
                            isTested: true,
                            addtime: Timestamp.now().seconds.toString());

                        BlocProvider.of<AddUpdateUserBloc>(context)
                            .add(UpdateUsersEvent(users: user));
                        print('object');
                      }
                    : () {
                        _pageController.nextPage(
                            duration: const Duration(milliseconds: 500),
                            curve: Curves.easeIn);
                      },
                textBtn: page == widget.quetion.length ? 'Submit' : 'Next',
              );
            },
          ),
        )
      ],
    );
  }
}

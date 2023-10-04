import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:questions/features/quetions&auth/presentation/bloc/add_update_users/add_update_users_bloc.dart';
import 'package:questions/features/quetions&auth/presentation/bloc/get_quesions/quetion_bloc.dart';
import 'package:questions/features/quetions&auth/presentation/bloc/get_users/get_users_bloc.dart';
import 'package:questions/features/quetions&auth/presentation/pages/splash_page.dart';

import 'core/app_theme.dart';
import 'injection_container.dart' as di;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //حقن التبعيات
  await di.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // bloc providers
    return MultiBlocProvider(
        providers: [
          BlocProvider(
              create: (_) => di.sl<QuetionBloc>()..add(GetAllQuetionEvent())),
          BlocProvider(
              create: (_) =>
                  di.sl<AddUpdateUserBloc>()..add(UserSingIngEvent())),
          BlocProvider(
              create: (_) => di.sl<UsersBloc>()..add(GetAllUsersEvent())),
        ],
        // screen util للتحكم بمقاسات الشاشات وجعل التطبيق متوافق مع مختلف الشاشات
        child: ScreenUtilInit(
            designSize: const Size(360, 690),
            minTextAdapt: true,
            splitScreenMode: true,
            builder: (_, child) {
              return MaterialApp(
                  debugShowCheckedModeBanner: false,
                  theme: appTheme,
                  title: 'Question App',
                  home: const SplashPage());
            }));
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/app_theme.dart';
import 'features/quetions&auth/presentation/bloc/add_delete_update_post/add_delete_update_quetion_bloc.dart';
import 'features/quetions&auth/presentation/bloc/posts/quetion_bloc.dart';
import 'features/quetions&auth/presentation/pages/posts_page.dart';
import 'injection_container.dart' as di;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider(
              create: (_) => di.sl<QuetionBloc>()..add(GetAllQuetionEvent())),
          BlocProvider(create: (_) => di.sl<AddDeleteUpdateQuetionBloc>()),
        ],
        child: MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: appTheme,
            title: 'Posts App',
            home: const PostsPage()));
  }
}

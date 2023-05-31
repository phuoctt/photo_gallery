import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:photo_gallery/route/navigator.dart';
import 'package:photo_gallery/route/routes.dart';
import 'app.dart';
import 'bloc/app/app_cubit.dart';
import 'bloc/photo/photo_cubit.dart';
import 'features/screens/dashboard.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final app = App();
  await app.setup();
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider<PhotoCubit>.value(value: PhotoCubit()),
        BlocProvider<AppCubit>.value(value: AppCubit(app.userLocalStorage)),
      ],
      child: MyApp(app: app),
    ),
  );
}

class MyApp extends StatelessWidget {
  final App app;

  const MyApp({Key? key, required this.app}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      navigatorKey: navigatorKey,
      onGenerateRoute: routes(app),
      navigatorObservers: [routeObserver],
      theme: ThemeData(
        primarySwatch: Colors.blue,
        primaryColor: const Color(0xff3A506B),
        appBarTheme: const AppBarTheme(color: Color(0xff3A506B)),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
            backgroundColor: Color(0xff3A506B)),
      ),
      home: const DashBoardScreen(),
    );
  }
}

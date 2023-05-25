import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:photo_gallery/route/navigator.dart';
import 'package:photo_gallery/route/routes.dart';
import 'app.dart';
import 'bloc/photo/photo_cubit.dart';
import 'features/screens/dashboard.dart';
import 'models/photo.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final app = App();
  await app.setup();
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider<PhotoCubit>.value(value: PhotoCubit()),
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
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const DashBoardScreen(),
    );
  }
}

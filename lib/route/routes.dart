import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:photo_gallery/bloc/photo/photo_manager_cubit.dart';

import '../app.dart';
import '../bloc/photo/photo_cubit.dart';
import '../features/screens/dashboard.dart';
import '../features/screens/info_photo.dart';
import '../features/screens/photo_manager.dart';
import '../features/screens/photo_view.dart';
import '../models/photo.dart';

var bootStage = 1;

RouteFactory routes(App app) {
  return (RouteSettings settings) {
    var fullScreen = false;
    Widget? screen;

    // if (bootStage == 1) {
    //   bootStage = 2;
    //   return PageRouteBuilder(
    //     pageBuilder: (_, __, ___) => const SplashScreen(),
    //   );
    // }
    final arguments = settings.arguments as Map<String, dynamic>? ?? {};
    var name = settings.name;
    switch (name) {
      case PhotoViewScreen.route:
        final data = arguments['data'];
        screen = PhotoViewScreen(
          photo: data,
        );
        break;
      case InfoPhotoScreen.route:
        screen = InfoPhotoScreen(photo: arguments['data']);
        break;
      case DashBoardScreen.route:
        PhotoModel data = arguments['data'];
        screen = BlocProvider(
          create: (_) => PhotoCubit(key: data.name),
          child: DashBoardScreen(data: data),
        );
        break;
      case PhotoManagerScreen.route:
        final index = arguments['index'];
        screen = BlocProvider(
          create: (_) => PhotoManagerCubit(app.box, index),
          child: PhotoManagerScreen(
            index: index,
            data: arguments['data'],
          ),
        );
        break;
      // default:
      //   screen = DashBoardScreen(
      //     userType: app.userLocalStorage.userType,
      //   );
    }

    if (bootStage == 2) {
      bootStage = 3;
      return PageRouteBuilder(
        settings: settings,
        pageBuilder: (BuildContext context, _, __) {
          return screen!;
        },
        transitionDuration: const Duration(milliseconds: 500),
      );
    }

    if (fullScreen) {
      return MaterialPageRoute(
        settings: settings,
        builder: (_) => screen!,
        fullscreenDialog: true,
      );
    }
    return MaterialPageRoute(settings: settings, builder: (context) => screen!);

    // return PageRouteBuilder(pageBuilder: (BuildContext context, _, __) {
    //   return screen!;
    // }, transitionsBuilder: (_, Animation<double> animation, __, Widget child) {
    //   return FadeTransition(opacity: animation, child: child);
    // });
  };
}

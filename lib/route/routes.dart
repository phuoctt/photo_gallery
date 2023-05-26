import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../app.dart';
import '../bloc/photo/photo_cubit.dart';
import '../features/screens/dashboard.dart';
import '../features/screens/info_photo.dart';
import '../features/screens/photo_view.dart';
import '../features/screens/search_photo.dart';
import '../models/photo.dart';

var bootStage = 1;

RouteFactory routes(App app) {
  return (RouteSettings settings) {
    var fullScreen = false;
    Widget? screen;
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
      case SearchPhotoScreen.route:
        screen = SearchPhotoScreen(photos: arguments['data']);
        break;
      case DashBoardScreen.route:
        PhotoModel data = arguments['data'];
        screen = BlocProvider(
          create: (_) => PhotoCubit(key: data.name),
          child: DashBoardScreen(data: data),
        );
        break;
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

    if (fullScreen) {}
    return MaterialPageRoute(settings: settings, builder: (context) => screen!);
  };
}

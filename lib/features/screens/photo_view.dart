import 'dart:io';

import 'package:flutter/material.dart';
import 'package:photo_gallery/features/views/fab_menu_option.dart';
import 'package:photo_gallery/models/photo.dart';
import 'package:photo_gallery/route/navigator.dart';
import 'package:photo_view/photo_view.dart';

import 'info_photo.dart';

class PhotoViewScreen extends StatelessWidget {
  static const route = '/photo_view';
  PhotoModel photo;

  PhotoViewScreen({required this.photo, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(photo.name ?? ''),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.info_outline_rounded,
              color: Colors.white,
            ),
            onPressed: () =>
                pushNamed(InfoPhotoScreen.route, arguments: {'data': photo}),
          )
        ],
      ),
      body: PhotoView(
        imageProvider: FileImage(File(photo.path ?? '')),
      ),
    );
  }
}

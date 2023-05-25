import 'dart:io';

import 'package:flutter/material.dart';
import 'package:photo_gallery/models/photo.dart';
import 'package:photo_gallery/share/enums/photo_type.dart';

import '../../resources/paths.dart';

enum MenuPhoto { edit, delete, share }

class PhotoItem extends StatelessWidget {
  final PhotoModel data;
  final PopupMenuItemSelected<MenuPhoto>? onChanged;

  const PhotoItem({Key? key, required this.data, this.onChanged})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          flex: 7,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8.0),
            child: SizedBox(
              width: double.infinity,
              child: data.type == PhotoType.file.type
                  ? Image.file(
                    File(data.path ?? ''),
                    fit: BoxFit.fill,
                  )
                  : Image.asset(Images.icon_folder),
            ),
          ),
        ),
        Row(
          children: [
            Expanded(
                child: Text(
              data.name ?? '',
              maxLines: 2,
              textAlign: TextAlign.center,
            )),
            PopupMenuButton<MenuPhoto>(
              icon: const Icon(Icons.more_horiz),
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(16.0),
                ),
              ),
              onSelected: onChanged,
              itemBuilder: (BuildContext context) =>
                  _getListMenuOptionByType(PhotoType.fromType(data.type)),
            ),
          ],
        )
      ],
    );
  }

  List<PopupMenuEntry<MenuPhoto>> _getListMenuOptionByType(PhotoType type) {
    final menu = [
      const PopupMenuItem<MenuPhoto>(
        value: MenuPhoto.delete,
        child: Text('Delete'),
      ),
    ];
    if (type == PhotoType.file) {
      menu.addAll(const [
        PopupMenuItem<MenuPhoto>(
          value: MenuPhoto.edit,
          child: Text('Edit'),
        ),
        PopupMenuItem<MenuPhoto>(
          value: MenuPhoto.share,
          child: Text('Share'),
        )
      ]);
    }
    return menu;
  }
}

import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import 'package:flutter/material.dart';
import 'package:photo_gallery/models/photo.dart';
import 'package:photo_gallery/share/enums/photo_type.dart';

import '../../bloc/app/app_cubit.dart';
import '../../resources/paths.dart';
import 'icon_change_list.dart';

enum MenuPhoto { edit, delete, share, rename }

class PhotoItem extends StatelessWidget {
  final PhotoModel data;
  final PopupMenuItemSelected<MenuPhoto>? onChanged;

  const PhotoItem({
    Key? key,
    required this.data,
    this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final modeView =
        BlocProvider.of<AppCubit>(context).state.mode ?? ListModeType.grid_view;
    return modeView == ListModeType.grid_view
        ? _buildItemGridView()
        : _buildItemListView();
  }

  Widget _buildItemGridView() {
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
                      fit: BoxFit.cover,
                    )
                  : Image.asset(
                      Images.icon_folder,
                      color: const Color(0xff577399),
                    ),
            ),
          ),
        ),
        Row(
          children: [
            _space(),
            Expanded(
                child: Text(
              data.name ?? '',
              maxLines: 2,
              textAlign: TextAlign.center,
            )),
            _buildPopupMenuBtn(),
          ],
        )
      ],
    );
  }

  Widget _buildItemListView() {
    return Row(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(12.0),
          child: SizedBox(
            width: 60,
            height: 60,
            child: data.type == PhotoType.file.type
                ? Image.file(
                    File(data.path ?? ''),
                    fit: BoxFit.cover,
                  )
                : Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12.0),
                        color: const Color(0xff399AF7).withOpacity(0.2)),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Image.asset(
                        Images.icon_folder,
                        color: const Color(0xff577399),
                      ),
                    )),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              data.name ?? '',
              maxLines: 1,
              style: const TextStyle(fontSize: 15),
            ),
            const SizedBox(height: 8),
            Text(
              'Modified ${DateFormat.yMMMd().format(data.createDate ?? DateTime.now())}',
              style: const TextStyle(fontSize: 12),
            ),
          ],
        )),
        _buildPopupMenuBtn(),
      ],
    );
  }

  Widget _buildPopupMenuBtn() {
    return PopupMenuButton<MenuPhoto>(
      icon: const Icon(Icons.more_horiz),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(16.0),
        ),
      ),
      onSelected: onChanged,
      itemBuilder: (BuildContext context) =>
          _getListMenuOptionByType(PhotoType.fromType(data.type)),
    );
  }

  List<PopupMenuEntry<MenuPhoto>> _getListMenuOptionByType(PhotoType type) {
    final menu = [
      const PopupMenuItem<MenuPhoto>(
        value: MenuPhoto.delete,
        child: Text('Delete'),
      ),
      const PopupMenuItem<MenuPhoto>(
        value: MenuPhoto.rename,
        child: Text('Rename'),
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

  Widget _space() => Visibility(
      maintainSize: true,
      maintainAnimation: true,
      maintainState: true,
      visible: false,
      child: IconButton(onPressed: () {}, icon: const Icon(Icons.add)));
}

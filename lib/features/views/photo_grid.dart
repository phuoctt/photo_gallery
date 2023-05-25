import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:photo_gallery/features/screens/dashboard.dart';
import 'package:photo_gallery/route/navigator.dart';
import 'package:photo_gallery/share/enums/photo_type.dart';
import 'package:share_plus/share_plus.dart';

import '../../bloc/photo/photo_cubit.dart';
import '../../models/photo.dart';
import '../screens/photo_manager.dart';
import '../screens/photo_view.dart';
import '../widgets/item_photo.dart';
import 'create_popup.dart';

class PhotoGridView extends StatefulWidget {
  final List<PhotoModel> data;
  final PopupMenuItemSelected<MenuPhoto>? onChanged;

  const PhotoGridView({
    Key? key,
    required this.data,
    this.onChanged,
  }) : super(key: key);

  @override
  State<PhotoGridView> createState() => _PhotoGridViewState();
}

class _PhotoGridViewState extends State<PhotoGridView> {
  PhotoCubit get photoCubit => BlocProvider.of<PhotoCubit>(context);

  @override
  Widget build(BuildContext context) {
    return widget.data.isEmpty
        ? noDataWidget()
        : Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: _buildPhotoView(),
          );
  }

  Widget _buildPhotoView() {
    return Column(
      children: [
        TextField(
          decoration: InputDecoration(
            prefixIcon: Icon(Icons.search),
            border: OutlineInputBorder(),
            hintText: 'Search',
          ),
        ),
        Expanded(
          child: GridView.builder(
              padding: const EdgeInsets.symmetric(vertical: 10),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
              ),
              itemCount: widget.data.length,
              itemBuilder: (BuildContext context, int index) {
                final item = widget.data[index];
                return GestureDetector(
                  onTap: () => _onTapPhoto(item),
                  child: PhotoItem(
                    data: item,
                    onChanged: (menu) {
                      switch (menu) {
                        case MenuPhoto.delete:
                          BlocProvider.of<PhotoCubit>(context)
                              .onDelete(index, item);
                          break;
                        case MenuPhoto.edit:
                          _cropImage(context, index, item);
                          break;
                        case MenuPhoto.share:
                          Share.shareFiles([item.path ?? '']);
                          break;
                      }
                    },
                  ),
                );
              }),
        ),
      ],
    );
  }

  Widget noDataWidget() {
    return const Center(
      child: Text(
        'No Data',
        style: TextStyle(color: Colors.amber),
      ),
    );
  }

  Future<void> _cropImage(
      BuildContext context, int index, PhotoModel photo) async {
    if (photo.path != null) {
      final croppedFile = await ImageCropper().cropImage(
        sourcePath: photo.path ?? '',
        compressFormat: ImageCompressFormat.jpg,
        compressQuality: 100,
        uiSettings: [
          AndroidUiSettings(
              toolbarTitle: 'Cropper',
              toolbarColor: Colors.blue,
              toolbarWidgetColor: Colors.white,
              initAspectRatio: CropAspectRatioPreset.original,
              lockAspectRatio: false),
          IOSUiSettings(
            title: 'Cropper',
          ),
        ],
      );
      if (croppedFile != null) {
        photoCubit.onUpdatePhoto(
            index, XFile(croppedFile.path), photo.name ?? '');
      }
    }
  }

  void _onTapPhoto(PhotoModel item) {
    switch (PhotoType.fromType(item.type)) {
      case PhotoType.file:
        pushNamed(PhotoViewScreen.route, arguments: {'data': item});
        break;
      case PhotoType.folder:
        pushNamed(DashBoardScreen.route, arguments: {'data': item});
        break;
    }
  }
}

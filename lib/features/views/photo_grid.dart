import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:photo_gallery/features/screens/dashboard.dart';
import 'package:photo_gallery/route/navigator.dart';
import 'package:photo_gallery/share/enums/photo_type.dart';
import 'package:share_plus/share_plus.dart';

import '../../bloc/app/app_cubit.dart';
import '../../bloc/photo/photo_cubit.dart';
import '../../models/photo.dart';
import '../screens/photo_view.dart';
import '../widgets/icon_change_list.dart';
import '../widgets/item_photo.dart';
import 'create_popup.dart';

class PhotoGridView extends StatefulWidget {
  final List<PhotoModel> data;

  const PhotoGridView({
    Key? key,
    required this.data,
  }) : super(key: key);

  @override
  State<PhotoGridView> createState() => _PhotoGridViewState();
}

class _PhotoGridViewState extends State<PhotoGridView> {
  PhotoCubit get photoCubit => BlocProvider.of<PhotoCubit>(context);

  @override
  Widget build(BuildContext context) {
    final modeView =
        BlocProvider.of<AppCubit>(context).state.mode ?? ListModeType.grid_view;
    return widget.data.isEmpty
        ? noDataWidget()
        : Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              transitionBuilder: (child, animation) {
                return SlideTransition(
                    position: animation.drive(Tween(
                        begin: const Offset(1.0, 0.0),
                        end: const Offset(0.0, 0.0))),
                    child: child);
              },
              child: modeView == ListModeType.grid_view
                  ? _buildPhotoGridView()
                  : _buildPhotoListView(),
            ),
          );
  }

  Widget _buildPhotoGridView() {
    return GridView.builder(
        padding: const EdgeInsets.symmetric(vertical: 10),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          childAspectRatio: MediaQuery.of(context).size.width /
              (MediaQuery.of(context).size.height / 2),
        ),
        itemCount: widget.data.length,
        itemBuilder: (BuildContext context, int index) {
          final item = widget.data[index];
          return _buildItemPhoto(index, item);
        });
  }

  Widget _buildPhotoListView() {
    return ListView.separated(
        itemBuilder: (_, index) {
          final item = widget.data[index];
          return _buildItemPhoto(index, item);
        },
        separatorBuilder: (_, index) {
          return const SizedBox(height: 16);
        },
        itemCount: widget.data.length);
  }

  Widget _buildItemPhoto(int index, PhotoModel item) {
    return GestureDetector(
      onTap: () => _onTapPhoto(item),
      child: PhotoItem(
        data: item,
        onChanged: (menu) async {
          switch (menu) {
            case MenuPhoto.delete:
              BlocProvider.of<PhotoCubit>(context).onDelete(index, item);
              break;
            case MenuPhoto.edit:
              _cropImage(context, index, item);
              break;
            case MenuPhoto.share:
              Share.shareFiles([item.path ?? '']);
              break;
            case MenuPhoto.rename:
              final result =
                  await CreatePopup.show(title: 'Rename', content: item.name);
              if (result != null) {
                photoCubit.onRename(index, item.copyWith(name: result));
              }
              break;
          }
        },
      ),
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
        photoCubit.onUpdatePhoto(index, XFile(croppedFile.path), photo);
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

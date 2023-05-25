import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:photo_gallery/bloc/photo/photo_state.dart';
import 'package:photo_gallery/models/photo.dart';

import '../../bloc/photo/photo_cubit.dart';
import '../views/create_popup.dart';
import '../views/fab_menu_option.dart';
import '../views/photo_grid.dart';

class DashBoardScreen extends StatefulWidget {
  static const route = '/dashboard';
  final PhotoModel? data;

  const DashBoardScreen({Key? key, this.data}) : super(key: key);

  @override
  State<DashBoardScreen> createState() => _DashBoardScreenState();
}

class _DashBoardScreenState extends State<DashBoardScreen> {
  PhotoCubit get photoCubit => BlocProvider.of<PhotoCubit>(context);

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      photoCubit.onLoadPhotos();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.data?.name ?? 'Photo Gallery'),
          actions: [
            IconButton(onPressed: () {}, icon: const Icon(Icons.search))
          ],
        ),
        body: BlocBuilder<PhotoCubit, PhotoState>(
            buildWhen: (p, c) => c is PhotoLogged,
            builder: (context, state) {
              if (state is PhotoLogged) {
                final data = state.data;
                return PhotoGridView(data: data);
              }
              return const Center(child: CircularProgressIndicator());
            }),
        floatingActionButton: ExpandableFab(
          distance: 60,
          children: [
            ActionButton(
              onPressed: () async {
                final result = await CreatePopup.show();
                if (result != null) {
                  photoCubit.createFolder(result);
                }
              },
              icon: const Icon(
                Icons.folder,
                color: Colors.white,
              ),
            ),
            ActionButton(
              onPressed: pickImage,
              icon: const Icon(
                Icons.upload,
                color: Colors.white,
              ),
            ),
          ],
        ));
  }

  Future<void> pickImage() async {
    final files = await ImagePicker().pickMultiImage(imageQuality: 30);
    photoCubit.addPhoto(files);
  }
}

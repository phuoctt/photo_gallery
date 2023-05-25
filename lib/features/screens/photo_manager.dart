import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:photo_gallery/bloc/photo/photo_state.dart';
import 'package:photo_gallery/models/photo.dart';

import '../../bloc/photo/photo_cubit.dart';
import '../../bloc/photo/photo_manager_cubit.dart';
import '../views/create_popup.dart';
import '../views/fab_menu_option.dart';
import '../views/photo_grid.dart';

class PhotoManagerScreen extends StatefulWidget {
  final int index;
  static const route = '/file_manager';
  final PhotoModel data;

  const PhotoManagerScreen({Key? key, required this.index, required this.data})
      : super(key: key);

  @override
  State<PhotoManagerScreen> createState() => _PhotoManagerScreenState();
}

class _PhotoManagerScreenState extends State<PhotoManagerScreen> {
  PhotoManagerCubit get cubit => BlocProvider.of<PhotoManagerCubit>(context);
  late PhotoModel _data;

  @override
  void initState() {
    _data = widget.data;
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      cubit.onLoadPhotos();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.data.name ?? ''),
        ),
        body: BlocBuilder<PhotoManagerCubit, PhotoState>(
            builder: (context, state) {
          if (state is PhotoLogged) {
            _data = _data.copyWith(photoChild: state.data);
          }
          if (state is PhotoLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          return PhotoGridView(data: _data.photoChild ?? []);
        }),
        floatingActionButton: FloatingActionButton(
          onPressed: pickImage,
          backgroundColor: Colors.blue,
          child: const Icon(Icons.add),
        ));
  }

  Future<void> pickImage() async {
    final files = await ImagePicker().pickMultiImage(imageQuality: 30);
    cubit.addPhoto(_data,files);
  }
}

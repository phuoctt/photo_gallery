import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:photo_gallery/bloc/photo/photo_state.dart';

import '../../models/photo.dart';
import '../../share/utility.dart';

class PhotoManagerCubit extends Cubit<PhotoState> {
  Box<dynamic> box;
  int index;

  PhotoManagerCubit(
    this.box,
    this.index,
  ) : super(const PhotoLoading());

  Future<void> onLoadPhotos() async {
    try {
      emit(const PhotoLoading());
      final photo = box.getAt(index) as PhotoModel;
      emit(PhotoLogged(data: List.from(photo.photoChild ?? [])));
    } catch (err) {
      emit(PhotoError(err.toString()));
    }
  }

  Future<void> addPhoto(PhotoModel data, List<XFile> files) async {
    try {
      final result = await _moveFileDirectory(data, files);
      emit(PhotoLogged(data: List.from(result)));
    } catch (err) {
      emit(PhotoError(err.toString()));
    }
  }

  Future<List<PhotoModel>> _moveFileDirectory(
      PhotoModel data, List<XFile> files) async {
    List<PhotoModel> photos = List.from(data.photoChild ?? []);
    for (var e in files) {
      final directory = await getApplicationDocumentsDirectory();
      var path = '${directory.path}/${data.path}/${e.name}';
      await   Directory('${directory.path}/${data.path}/').create();
      await Utility.moveFile(File(e.path), path);
      photos.add(PhotoModel(
        name: e.name,
        date: DateTime.now(),
        path: path,
      ));
    }
    final value = data.copyWith(photoChild: photos);
    box.putAt(index, value);
    return photos;
  }

  List<PhotoModel> _getPhotoStorage() {
    Map<dynamic, dynamic> photoLocal = box.toMap();
    List<PhotoModel> data = List.from([]);
    for (var element in photoLocal.entries) {
      data.add(element.value as PhotoModel);
    }
    return data;
  }
}

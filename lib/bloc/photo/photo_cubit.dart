import 'dart:convert';
import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:photo_gallery/bloc/photo/photo_state.dart';
import 'package:image_picker/image_picker.dart';

import '../../models/photo.dart';
import '../../share/constant.dart';
import '../../share/enums/photo_type.dart';
import '../../share/utility.dart';

class PhotoCubit extends Cubit<PhotoState> {
  final String? key;
  late Box<dynamic> box;

  PhotoCubit({this.key}) : super(const PhotoLoading());

  Future<void> onLoadPhotos() async {
    try {
      box = await Hive.openBox(key ?? HiveKey.boxKey);
      emit(const PhotoLoading());
      emit(PhotoLogged(data: _getPhotoStorage()));
    } catch (err) {
      emit(PhotoError(err.toString()));
    }
  }

  Future<void> addPhoto(List<XFile> files) async {
    try {
      await _addAndMoveFile(files);
      emit(PhotoLogged(data: _getPhotoStorage()));
    } catch (err) {
      emit(PhotoError(err.toString()));
    }
  }

  Future<void> onDelete(int index, PhotoModel data) async {
    try {
      box.deleteAt(index);
      emit(PhotoLogged(data: _getPhotoStorage()));
      switch (PhotoType.fromType(data.type)) {
        case PhotoType.file:
          File(data.path ?? '').delete();
          break;
        case PhotoType.folder:
          await Directory(data.path ?? '').delete(recursive: true);
          // Directory(data.path??'').deleteSync(recursive: true);
          break;
      }
    } catch (err) {
      emit(PhotoError(err.toString()));
    }
  }

  Future<void> onUpdatePhoto(int index, XFile file, PhotoModel photo) async {
    try {
      await _updateAndMoveFile(index, file, photo);
      emit(PhotoLogged(data: _getPhotoStorage()));
    } catch (err) {
      emit(PhotoError(err.toString()));
    }
  }

  Future<void> onRename(int index, PhotoModel photo) async {
    try {
      box.putAt(index, photo);
      emit(PhotoLogged(data: _getPhotoStorage()));
    } catch (err) {
      emit(PhotoError(err.toString()));
    }
  }

  Future<void> createFolder(String? name) async {
    final directory = await getApplicationDocumentsDirectory();
    await Directory('${directory.path}/$name/').create();
    box.add(PhotoModel(
      name: name,
      type: PhotoType.folder.type,
      createDate: DateTime.now(),
      updateDate: DateTime.now(),
      path: '${directory.path}/${name?.trim()}',
    ));
    emit(PhotoLogged(data: _getPhotoStorage()));
  }

  Future<void> uploadPhoto(List<XFile> files) async {
    await _addAndMoveFile(files);
    emit(PhotoLogged(data: _getPhotoStorage()));
  }

  List<PhotoModel> _getPhotoStorage() {
    Map<dynamic, dynamic> photoLocal = box.toMap();
    List<PhotoModel> data = List.from([]);
    for (var element in photoLocal.entries) {
      data.add(element.value as PhotoModel);
    }
    return data;
  }

  Future<void> _addAndMoveFile(List<XFile> files) async {
    for (var e in files) {
      final directory = await getApplicationDocumentsDirectory();
      var path = directory.path;
      await Utility.moveFile(File(e.path), '$path/${e.name}');
      box.add(PhotoModel(
        name: e.name,
        createDate: DateTime.now(),
        updateDate: DateTime.now(),
        path: '$path/${e.name}',
      ));
    }
  }

  Future<void> _updateAndMoveFile(
      int index, XFile file, PhotoModel photo) async {
    final directory = await getApplicationDocumentsDirectory();
    var path = directory.path;
    await Utility.moveFile(File(file.path), '$path/${file.name}');
    box.putAt(
      index,
      photo.copyWith(path: '$path/${file.name}', dateUpdate: DateTime.now()),
      // PhotoModel(
      //   name: photo.name,
      //   createDate: DateTime.now(),
      //   path: '$path/${file.name}',
      // )
    );
  }
}

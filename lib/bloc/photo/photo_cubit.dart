import 'dart:convert';
import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:photo_gallery/bloc/photo/photo_state.dart';
import 'package:image_picker/image_picker.dart';

import '../../models/photo.dart';
import '../../share/constant.dart';

class PhotoCubit extends Cubit<PhotoState> {
  PhotoCubit() : super(const PhotoLoading());

  Future<void> onLoadPhotos() async {
    emit(const PhotoLoading());
    var box = await Hive.openBox(HiveKey.boxKey);
    Map<dynamic, dynamic> photoLocal = box.toMap();
    Map<int, PhotoModel> maps = {};
    for (var element in photoLocal.entries) {
      maps[element.key] = element.value as PhotoModel;
    }
    emit(PhotoLogged(data: maps));
  }

  Future<void> addPhoto(List<XFile> files) async {
    var box = await Hive.openBox(HiveKey.boxKey);
    files.map((e) async {
      final directory = await getApplicationDocumentsDirectory();
      var path = directory.path;
      await moveFile(File(e.path), '$path/${e.name}');
      box.add(PhotoModel(
        name: e.name,
        date: DateTime.now(),
        path: '$path/${e.name}',
      ));
    }).toList();
  }

  Future<File> moveFile(File originalFile, String targetPath) async {
    try {
      // This will try first to just rename the file if they are on the same directory,
      return await originalFile.rename(targetPath);
    } on FileSystemException catch (e) {
      // if the rename method fails, it will copy the original file to the new directory and then delete the original file
      final newFileInTargetPath = await originalFile.copy(targetPath);
      await originalFile.delete();
      return newFileInTargetPath;
    }
  }
}

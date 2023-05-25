
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:photo_gallery/share/constant.dart';

import 'models/photo.dart';


class App {
  Box<dynamic> get box => _box;
  late Box<dynamic> _box;

  Future<void> setup() async {
    final directory = await getApplicationDocumentsDirectory();
    var path = directory.path;
    Hive
      ..init(path)
      ..registerAdapter(PhotoModelAdapter());
     _box = await Hive.openBox(HiveKey.boxKey);
  }
}
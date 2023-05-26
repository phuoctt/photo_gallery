import 'package:hive/hive.dart';

part 'photo.g.dart';

@HiveType(typeId: 1)
class PhotoModel {
  PhotoModel({
    required this.name,
    required this.createDate,
    required this.path,
    this.type = 1,
    this.updateDate,
    this.photoChild,
  });

  @HiveField(0)
  String? name;

  @HiveField(1)
  DateTime? createDate;

  @HiveField(2)
  String? path;

  @HiveField(3)
  int? type; //1 file  2 folder

  @HiveField(4)
  List<PhotoModel>? photoChild;

  @HiveField(5)
  DateTime? updateDate;

  PhotoModel copyWith({
    String? name,
    DateTime? date,
    DateTime? dateUpdate,
    String? path,
    int? type,
    List<PhotoModel>? photoChild,
  }) {
    return PhotoModel(
      name: name ?? this.name,
      createDate: date ?? this.createDate,
      updateDate: dateUpdate ?? this.updateDate,
      path: path ?? this.path,
      type: type ?? this.type,
      photoChild: photoChild ?? this.photoChild,
    );
  }
}

import 'package:hive/hive.dart';

part 'photo.g.dart';

@HiveType(typeId: 1)
class PhotoModel {
  PhotoModel({
    required this.name,
    required this.date,
    required this.path,
    this.type = 1,
    this.photoChild,
  });

  @HiveField(0)
  String? name;

  @HiveField(1)
  DateTime? date;

  @HiveField(2)
  String? path;

  @HiveField(3)
  int? type; //1 file  2 folder

  @HiveField(4)
  List<PhotoModel>? photoChild;

  PhotoModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    date = json['date'];
    path = json['path'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['email'] = date;
    data['path'] = path;
    return data;
  }

  PhotoModel copyWith({
    String? name,
    DateTime? date,
    String? path,
    int? type,
    List<PhotoModel>? photoChild,
  }) {
    return PhotoModel(
      name: name ?? this.name,
      date: date ?? this.date,
      path: path ?? this.path,
      type: type ?? this.type,
      photoChild: photoChild ?? this.photoChild,
    );
  }
}

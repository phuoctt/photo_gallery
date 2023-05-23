import 'package:hive/hive.dart';
part 'photo.g.dart';

@HiveType(typeId: 1)
class PhotoModel {
  PhotoModel({required this.name, required this.date, required this.path});

  @HiveField(0)
  String? name;

  @HiveField(1)
  DateTime? date;

  @HiveField(2)
  String? path;

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
}

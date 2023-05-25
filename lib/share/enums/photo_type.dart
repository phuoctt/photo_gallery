
enum PhotoType {
  file(1),
  folder(2);

  const PhotoType(this.type);

  final int type;
  static PhotoType fromType(int? type) =>
      PhotoType.values.firstWhere((element) => type == element.type,
          orElse: () => PhotoType.file);
}

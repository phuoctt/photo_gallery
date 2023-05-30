enum FilterType {
  name('Name'),
  createdDate('Created Date'),
  updateDate('Update Date'),
  size('Size');

  const FilterType(this.title);

  final String title;

  static FilterType fromType(int? type) =>
      FilterType.values.firstWhere((element) => type == element.title,
          orElse: () => FilterType.name);
}

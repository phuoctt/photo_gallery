
import '../../features/widgets/icon_change_list.dart';

class AppState  {
  final ListModeType? mode;

  const AppState({this.mode});

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is AppState && o.mode == mode;
  }

  @override
  int get hashCode => mode.hashCode;
}

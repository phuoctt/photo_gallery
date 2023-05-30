import 'package:shared_preferences/shared_preferences.dart';

import '../../features/widgets/icon_change_list.dart';

class UserLocalStorage {
  static const String modeKey = 'mode_view_key';

  late SharedPreferences _storage;

  Future<void> load() async {
    _storage = await SharedPreferences.getInstance();
    await loadViewMore();
  }

  loadViewMore() async {
    _viewMode =
        _storage.getString(modeKey) ?? ListModeType.grid_view.toString();
  }

  updateViewMode(ListModeType mode) {
    _scheduleSave(
        modeKey,
        mode == ListModeType.grid_view
            ? ListModeType.grid_view.toString()
            : ListModeType.list_view.toString());
  }

  ListModeType get modeView => _getViewMode();
  String _viewMode = "";

  set viewMode(String value) {
    _viewMode = value;
    _scheduleSave(modeKey, value);
  }

  void _scheduleSave(String key, String value) {
    _storage.setString(key, value);
  }

  ListModeType _getViewMode() => _viewMode == ListModeType.grid_view.toString()
      ? ListModeType.grid_view
      : ListModeType.list_view;
}

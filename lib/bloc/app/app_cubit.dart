import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/preference/local_preference.dart';
import '../../features/widgets/icon_change_list.dart';
import 'app_state.dart';

class AppCubit extends Cubit<AppState> {
  final UserLocalStorage storage;

  AppCubit(this.storage) : super(AppState()) {
    onLoadSetting();
  }

  void onLoadSetting() {
    emit(AppState(mode: storage.modeView));
  }

  void onUpdateMode(ListModeType mode) {
    storage.updateTheme(mode);
    emit(AppState(mode: mode));
  }
}

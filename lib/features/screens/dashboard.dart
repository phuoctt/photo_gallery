import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:photo_gallery/bloc/photo/photo_state.dart';
import 'package:photo_gallery/features/screens/search_photo.dart';
import 'package:photo_gallery/models/photo.dart';
import 'package:photo_gallery/route/navigator.dart';

import '../../bloc/app/app_cubit.dart';
import '../../bloc/app/app_state.dart';
import '../../bloc/photo/photo_cubit.dart';
import '../views/create_popup.dart';
import '../views/fab_menu_option.dart';
import '../views/photo_grid.dart';
import '../widgets/icon_change_list.dart';

class DashBoardScreen extends StatefulWidget {
  static const route = '/dashboard';
  final PhotoModel? data;

  const DashBoardScreen({Key? key, this.data}) : super(key: key);

  @override
  State<DashBoardScreen> createState() => _DashBoardScreenState();
}

class _DashBoardScreenState extends State<DashBoardScreen> {
  PhotoCubit get photoCubit => BlocProvider.of<PhotoCubit>(context);
  late List<PhotoModel> _data = List.from([]);
  ListModeType modeView = ListModeType.grid_view;

  @override
  void initState() {
    _data = List.from(widget.data?.photoChild ?? []);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      photoCubit.onLoadPhotos();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppCubit, AppState>(
      builder: (context, state) {
        modeView = state.mode ?? ListModeType.grid_view;
        return Scaffold(
            appBar: AppBar(
              title: Text(widget.data?.name ?? 'Photo Gallery'),
              actions: _buildActonButton(),
            ),
            body: BlocBuilder<PhotoCubit, PhotoState>(
                buildWhen: (p, c) => c is PhotoLogged,
                builder: (context, state) {
                  if (state is PhotoLogged) {
                    _data = state.data;
                    return PhotoGridView(
                      data: _data,
                    );
                  }
                  return const Center(child: CircularProgressIndicator());
                }),
            floatingActionButton: buildFAB());
      },
    );
  }

  List<Widget> _buildActonButton() {
    return [
      IconButton(
          onPressed: () =>
              pushNamed(SearchPhotoScreen.route, arguments: {'data': _data}),
          icon: const Icon(Icons.search)),
      IconTransferList(
        mode: modeView,
        onPressed: _updateListMode,
      )
    ];
  }

  Widget buildFAB() {
    return ExpandableFab(
      distance: 90,
      children: [
        ActionButton(
          onPressed: () async {
            final result = await CreatePopup.show();
            if (result != null) {
              photoCubit.createFolder(result);
            }
          },
          icon: const Icon(
            Icons.folder,
            color: Colors.white,
          ),
        ),
        ActionButton(
          onPressed: _takeAPicture,
          icon: const Icon(
            Icons.camera_alt,
            color: Colors.white,
          ),
        ),
        ActionButton(
          onPressed: _pickImage,
          icon: const Icon(
            Icons.upload,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  Future<void> _pickImage() async {
    final files = await ImagePicker().pickMultiImage(imageQuality: 30);
    photoCubit.addPhoto(files);
  }

  Future<void> _takeAPicture() async {
    final XFile? image =
        await ImagePicker().pickImage(source: ImageSource.camera);
    if (image == null) return;
    photoCubit.addPhoto([image]);
  }

  void _updateListMode() {
    BlocProvider.of<AppCubit>(context).onUpdateMode(
        modeView == ListModeType.list_view
            ? ListModeType.grid_view
            : ListModeType.list_view);
  }
}

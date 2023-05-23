import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:photo_gallery/bloc/photo/photo_state.dart';

import '../../bloc/photo/photo_cubit.dart';

class DashBoardScreen extends StatefulWidget {
  const DashBoardScreen({Key? key}) : super(key: key);

  @override
  State<DashBoardScreen> createState() => _DashBoardScreenState();
}

class _DashBoardScreenState extends State<DashBoardScreen> {
  PhotoCubit get photoCubit => BlocProvider.of<PhotoCubit>(context);

  List<File> data = List.from([]);

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      photoCubit.onLoadPhotos();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('dá'),
        ),
        body: BlocBuilder<PhotoCubit, PhotoState>(builder: (context, state) {
          if (state is PhotoLogged) {
            final data  = state.data;
            return GridView.builder(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                ),
                itemCount: data.length,
                itemBuilder: (BuildContext context, int index) {
                  final map = data.entries.toList()[index];
                  final photo = map.value;
                  return Image.file(
                    File(photo.path??''),
                    fit: BoxFit.cover,
                  );
                });
          }
          return const Center(child: CircularProgressIndicator());
        }),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            pickImage();
            // final XFile? image =
            //     await ImagePicker().pickImage(source: ImageSource.gallery);
            print('object');
            //
            // final directory = await getApplicationDocumentsDirectory();
            //
            // var path = directory.path;
            // final file = await moveFile(
            //     File(
            //       image?.path ?? '',
            //     ),
            //     '$path/hinha');
            // setState(() {
            //   data.add(file);
            // });
          },
          child: const Icon(Icons.add),
        ));
  }

  Future<void> pickImage() async {
    photoCubit.addPhoto(await ImagePicker().pickMultiImage());
  }
}

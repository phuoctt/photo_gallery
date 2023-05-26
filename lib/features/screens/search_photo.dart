import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:photo_gallery/models/photo.dart';
import 'dart:async';

import '../../bloc/app/app_cubit.dart';
import '../views/photo_grid.dart';
import '../widgets/unfocus.dart';

class SearchPhotoScreen extends StatefulWidget {
  static const route = '/search_photo';
  final List<PhotoModel> photos;

  const SearchPhotoScreen({
    Key? key,
    required this.photos,
  }) : super(key: key);

  @override
  State<SearchPhotoScreen> createState() => _SearchPhotoScreenState();
}

class _SearchPhotoScreenState extends State<SearchPhotoScreen> {
  late List<PhotoModel> _data;
  late List<PhotoModel> _resultSearch;
  Timer? _debounce;

  @override
  void initState() {
    _data = widget.photos;
    _resultSearch = List.from([]);
    super.initState();
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return UnFocus(
      child: Scaffold(
        appBar: AppBar(
          title: _searchBar(),
        ),
        body: PhotoGridView(data: _resultSearch),
      ),
    );
  }

  Widget _searchBar() {
    return SizedBox(
        height: 40,
        child: TextField(
            autocorrect: true,
            onChanged: _onSearchChanged,
            decoration: const InputDecoration(
              hintText: 'Search',
              hintStyle: TextStyle(color: Colors.grey),
              filled: true,
              fillColor: Colors.white70,
              contentPadding: EdgeInsets.fromLTRB(10, 0, 0, 0),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(8.0)),
                borderSide: BorderSide(color: Colors.grey, width: 1),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(8.0)),
                borderSide: BorderSide(color: Colors.grey, width: 1),
              ),
            )));
  }

  _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      setState(() {
        _resultSearch = List.from(_data
            .where((element) =>
                element.name?.toLowerCase().contains(query) == true)
            .toList());
      });
    });
  }
}

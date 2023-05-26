import 'dart:io';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:photo_gallery/share/extensions/date_time.dart';

import '../../models/photo.dart';
import '../../share/utility.dart';
import '../widgets/separated_flexible.dart';

class InfoPhotoScreen extends StatelessWidget {
  static const route = '/info_photo';
  final PhotoModel photo;

  const InfoPhotoScreen({
    Key? key,
    required this.photo,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Info'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SeparatedColumn(
          crossAxisAlignment: CrossAxisAlignment.start,
          separatorBuilder: () => const Divider(),
          children: [
            _buildContentWidget('Name', photo.name),
            _buildContentWidget(
                'Create date', photo.createDate.toDate('HH:mm dd MMM yyy')),
            _buildContentWidget(
                'Update date', photo.updateDate.toDate('HH:mm dd MMM yyy')),
            _buildContentWidget(
                'Size',
                Utility.getFileSizeString(
                    bytes: File(photo.path ?? '').lengthSync())),
          ],
        ),
      ),
    );
  }

  Widget _buildContentWidget(String? title, String? content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title ?? '',
          style: const TextStyle(fontSize: 16, color: Colors.black),
        ),
        const SizedBox(height: 10),
        Text(
          content ?? '',
          style: const TextStyle(fontSize: 14, color: Colors.black87),
        )
      ],
    );
  }
}

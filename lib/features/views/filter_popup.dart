import 'package:flutter/material.dart';
import 'package:photo_gallery/features/widgets/separated_flexible.dart';

import '../../route/navigator.dart';
import '../../share/enums/filter_type.dart';

class FilterPopup extends StatefulWidget {
  const FilterPopup({Key? key, this.initValue}) : super(key: key);
  final FilterType? initValue;

  static Future<FilterType?> show({FilterType? initValue}) =>
      showModalBottomSheet(
        context: navigatorKey.currentContext!,
        builder: (BuildContext context) {
          return Wrap(
            children: [
              FilterPopup(initValue: initValue),
            ],
          );
        },
      );

  @override
  State<FilterPopup> createState() => _FilterPopupState();
}

class _FilterPopupState extends State<FilterPopup> {
  FilterType? _value;

  @override
  void initState() {
    _value = widget.initValue;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            'Sort',
            style: TextStyle(fontSize: 20),
          ),
        ),
        Divider(),
        SeparatedColumn(
            children: FilterType.values
                .map((e) =>
                ListTile(
                  title: Text(e.title ?? ''),
                  leading: Radio<FilterType>(
                    value: e,
                    groupValue: _value,
                    onChanged: (FilterType? value) {
                      setState(() {
                        _value = value;
                      });
                    },
                  ),
                ))
                .toList()),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: TextButton(onPressed: () => pop(_value), child: Text('OK')),
        )
      ],
    );
  }
}

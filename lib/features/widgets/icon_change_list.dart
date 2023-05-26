import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../resources/paths.dart';

enum ListModeType { grid_view, list_view }

class IconTransferList extends StatefulWidget {
  final ListModeType mode;
  final Function? onPressed;

  const IconTransferList({Key? key, required this.mode, this.onPressed})
      : super(key: key);

  @override
  _IconTransferListState createState() => _IconTransferListState();
}

class _IconTransferListState extends State<IconTransferList> {
  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          transitionBuilder: (child, anim) => RotationTransition(
                turns: child.key == const ValueKey('icon1')
                    ? Tween<double>(begin: 1, end: 0.75).animate(anim)
                    : Tween<double>(begin: 0.75, end: 1).animate(anim),
                child: FadeTransition(opacity: anim, child: child),
              ),
          child: widget.mode == ListModeType.list_view
              ? Image.asset(
                  Images.icon_gridview,
                  height: 24,
                  key: const ValueKey('icon1'),
                )
              : Image.asset(
                  Images.icon_listview,
                  height: 24,
                  key: const ValueKey('icon2'),
                )),
      onPressed: () => widget.onPressed?.call(),
    );
  }
}

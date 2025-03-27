import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'cubits/resizable_side_bar_cubit.dart';
import 'resizable_side_bar_item_base.dart';
import 'wrapper/share_properties_injector.dart';

part 'resizable_side_bar_item_contents.dart';

///===Expandable Menu Item Container===///

class ResizableSideBarExpandedItem extends StatefulWidget
    implements ResizableSideBarItemBase {
  final String title;
  final IconData icon;
  final List<ResizableSideBarItem> children;
  const ResizableSideBarExpandedItem({
    super.key,
    required this.title,
    required this.icon,
    required this.children,
  });

  @override
  State<StatefulWidget> createState() {
    return __ResizableSideBarExpandedItemContenState();
  }

  @override
  Widget setIndex(int index) {
    return _ResizableSideBarExpandedItemConten(
      index: index,
      title: title,
      icon: icon,
      children: children,
    );
  }
}

///===Menu Item Container===///

class ResizableSideBarItem extends StatefulWidget
    implements ResizableSideBarItemBase {
  final String title;
  final IconData icon;
  const ResizableSideBarItem({
    super.key,
    required this.icon,
    required this.title,
  });

  @override
  State<StatefulWidget> createState() => _ResizableSideBarItemContentState();

  @override
  Widget setIndex(int index) {
    return _ResizableSideBarItemContent(
      index: index,
      icon: icon,
      title: title,
    );
  }
}

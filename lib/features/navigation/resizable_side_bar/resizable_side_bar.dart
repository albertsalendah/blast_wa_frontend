import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:whatsapp_blast/features/navigation/resizable_side_bar/cubits/resizable_side_bar_cubit.dart';
import 'resizable_side_bar_item_base.dart';
import 'resizable_side_bar_items.dart';
import 'wrapper/share_properties_injector.dart';
import 'wrapper/share_properties_wrapper.dart';

//parts
part 'resizable_side_bar_main.dart';
part 'parts/resizable_side_bar_header.dart';
part 'parts/resizable_side_bar_title.dart';
part 'parts/resizable_side_bar_footer.dart';
part 'parts/resizable_side_bar_handle.dart';

class ResizableSideBar extends StatefulWidget {
  final List<ResizableSideBarItemBase> items;
  final List<Widget> pageList;
  final Widget Function(double size)? header;
  final String? title;
  final Color? backgroundColor;
  final IconData? handleIcon;
  final Color? selectedMenuBackgroundColor;
  final TextStyle? textStyle;
  final Color? hoverColor;
  final Color? menuBackgroundColor;
  final Color? iconColor;
  final IconData? footerIcon;
  final String? footerLabel;
  final VoidCallback? onFooterTap;
  final VoidCallback? onTapPages;
  const ResizableSideBar({
    super.key,
    required this.items,
    required this.pageList,
    this.header,
    this.title,
    this.footerIcon,
    this.backgroundColor,
    this.selectedMenuBackgroundColor,
    this.handleIcon,
    this.textStyle,
    this.hoverColor = const Color.fromARGB(150, 150, 150, 150),
    this.menuBackgroundColor,
    this.footerLabel,
    this.iconColor,
    this.onFooterTap,
    this.onTapPages,
  });

  @override
  State<ResizableSideBar> createState() => _ResizableSideBarState();
}

///How To Use
// List<ResizableSideBarItemBase> menuList = [
//   ResizableSideBarItem(
//     icon: Icons.gamepad,
//     title: 'GamePad',
//   ),
//   ResizableSideBarExpandedItem(
//     icon: Icons.home,
//     title: 'Home',
//     children: [
//       ResizableSideBarItem(icon: Icons.accessibility, title: 'Accessibility'),
//       ResizableSideBarItem(icon: Icons.access_time, title: 'Access Time'),
//     ],
//   ),
//   ResizableSideBarItem(icon: Icons.ac_unit, title: 'AC Unit'),
//   ResizableSideBarItem(icon: Icons.access_alarm, title: 'Alarm'),
// ];

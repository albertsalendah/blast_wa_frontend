part of '../resizable_side_bar.dart';

class _ResizableSideBarHeader extends StatelessWidget {
  final bool setPosition;
  final Widget Function(double size)? header;
  final double size;
  const _ResizableSideBarHeader({
    required this.setPosition,
    this.header,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: setPosition ? Alignment.topLeft : Alignment.topCenter,
      child: header != null
          ? SizedBox(
              height: size.floorToDouble(),
              width: size.floorToDouble(),
              child: header!(size.floorToDouble()))
          : const SizedBox.shrink(),
    );
  }
}

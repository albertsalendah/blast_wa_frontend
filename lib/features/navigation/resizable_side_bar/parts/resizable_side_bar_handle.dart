part of '../resizable_side_bar.dart';

class _ResizableSideBarHandle extends StatelessWidget {
  final Color? color;
  final void Function(DragUpdateDetails)? onHorizontalDragUpdate;
  const _ResizableSideBarHandle({
    this.color,
    this.onHorizontalDragUpdate,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragUpdate: (details) {
        onHorizontalDragUpdate?.call(details);
      },
      child: MouseRegion(
        cursor: SystemMouseCursors.resizeLeftRight,
        child: VerticalDivider(
          color: Colors.transparent,
          width: 1,
        ),
      ),
    );
  }
}

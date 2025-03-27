part of '../resizable_side_bar.dart';

class _ResizableSideBarTitle extends StatelessWidget {
  final String? title;
  final bool visible;
  const _ResizableSideBarTitle({
    this.title,
    required this.visible,
  });

  @override
  Widget build(BuildContext context) {
    final shared = ResizableSharedPropertiesInjector.of(context);
    return Center(
      child: Visibility(
        visible: visible && title != null,
        maintainAnimation: true,
        maintainState: true,
        child: Text(
          title ?? '',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: (shared.textStyle ?? TextStyle()).copyWith(
            fontSize:
                shared.textStyle?.fontSize ?? ((shared.fontSize ?? 0) + 2),
            fontWeight: FontWeight.w700,
            color: shared.textStyle?.color ?? shared.iconColor,
          ),
        ),
      ),
    );
  }
}

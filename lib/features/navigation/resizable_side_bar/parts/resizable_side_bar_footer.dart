part of '../resizable_side_bar.dart';

class _ResizableSideBarFooter extends StatelessWidget {
  final bool labelVisibility;
  final Color? backgroundColor;
  final VoidCallback? onFooterTap;
  final double? width;
  final IconData? footerIcon;
  final String? footerLabel;
  const _ResizableSideBarFooter({
    required this.labelVisibility,
    this.backgroundColor,
    this.onFooterTap,
    this.width,
    this.footerIcon,
    this.footerLabel,
  });

  @override
  Widget build(BuildContext context) {
    final shared = ResizableSharedPropertiesInjector.of(context);
    return Column(
      children: [
        Divider(
          height: 1,
          color: shared.selectedMenuBackgroundColor ?? Colors.white,
        ),
        footerIcon != null
            ? IconButton(
                onPressed: onFooterTap,
                hoverColor: shared.hoverColor,
                color: shared.iconColor ?? shared.textStyle?.color,
                style: ButtonStyle(
                  shape: WidgetStateProperty.all(RoundedRectangleBorder()),
                  padding: WidgetStateProperty.all(
                    EdgeInsets.symmetric(horizontal: 8),
                  ),
                ),
                icon: Row(
                  children: [
                    Icon(footerIcon, size: shared.iconSize),
                    footerLabel != null
                        ? Expanded(
                            child: Visibility(
                              visible: labelVisibility && footerLabel != null,
                              child: Padding(
                                padding: const EdgeInsets.only(left: 8),
                                child: Text(
                                  footerLabel!,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: (shared.textStyle ?? TextStyle())
                                      .copyWith(
                                    fontSize: shared.textStyle?.fontSize ??
                                        shared.fontSize,
                                    color: shared.textStyle?.color ??
                                        shared.iconColor,
                                  ),
                                ),
                              ),
                            ),
                          )
                        : const SizedBox.shrink(),
                  ],
                ),
              )
            : const SizedBox.shrink(),
      ],
    );
  }
}

part of 'resizable_side_bar_items.dart';

///===Expandable Menu Item Container===///
final Color _defSelectedColor = Colors.white;

class _ResizableSideBarExpandedItemConten extends StatefulWidget {
  final int index;
  final List<ResizableSideBarItem> children;
  final String title;
  final Widget Function(Color? color) icon;
  const _ResizableSideBarExpandedItemConten({
    required this.index,
    required this.children,
    required this.title,
    required this.icon,
  });

  @override
  State<_ResizableSideBarExpandedItemConten> createState() =>
      __ResizableSideBarExpandedItemContenState();
}

class __ResizableSideBarExpandedItemContenState
    extends State<_ResizableSideBarExpandedItemConten> {
  bool _isHovered = false;
  bool _isVisible = false;
  bool _isChildSelected = false;

  @override
  Widget build(BuildContext context) {
    final shared = ResizableSharedPropertiesInjector.of(context);
    return BlocListener<ResizableSideBarCubit, ResizableSideBarItemIndex>(
      listener: (context, selectedIndex) {
        _isChildSelected = (selectedIndex.parentIndex == widget.index);
        _isVisible = _isChildSelected;
        setState(() {});
      },
      listenWhen: (previous, current) =>
          previous.parentIndex != current.parentIndex,
      child: LayoutBuilder(
        builder: (context, constraints) {
          bool isOverflow = constraints.maxWidth > (shared.iconSize ?? 0) + 60;
          return Column(
            children: [
              MouseRegion(
                onEnter: (_) => setState(() => _isHovered = true),
                onExit: (_) => setState(() => _isHovered = false),
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      _isVisible = !_isVisible;
                    });
                  },
                  child: _resizableSidebarItemContainer(
                    icon: widget.icon,
                    title: widget.title,
                    shared: shared,
                    isHovered: _isHovered,
                    isOverflow: isOverflow,
                    isVisible: _isVisible,
                    isChildSelected: _isChildSelected,
                  ),
                ),
              ),
              AnimatedSize(
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeInOut,
                alignment: Alignment.topCenter,
                child: Visibility(
                  visible: _isVisible,
                  maintainAnimation: true,
                  maintainState: true,
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: !isOverflow ? 0 : 24),
                        child: Column(
                          children: List.generate(
                            widget.children.length,
                            (index) {
                              final items = widget.children[index];
                              return _ResizableSideBarItemContent(
                                index: widget.index + index,
                                icon: items.icon,
                                title: items.title,
                                parentIndex: widget.index,
                              );
                            },
                          ),
                        ),
                      ),
                      Divider(
                        height: 1,
                        color: shared.selectedMenuBackgroundColor ??
                            _defSelectedColor,
                      )
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

///===Menu Item Container===///

class _ResizableSideBarItemContent extends StatefulWidget {
  final int index;
  final int? parentIndex;
  final String title;
  final Widget Function(Color? color) icon;
  const _ResizableSideBarItemContent({
    required this.index,
    this.parentIndex,
    required this.icon,
    required this.title,
  });

  @override
  State<_ResizableSideBarItemContent> createState() =>
      _ResizableSideBarItemContentState();
}

class _ResizableSideBarItemContentState
    extends State<_ResizableSideBarItemContent> {
  bool _isHovered = false;
  bool _isSelected = false;

  @override
  Widget build(BuildContext context) {
    final shared = ResizableSharedPropertiesInjector.of(context);
    final cubit = context.read<ResizableSideBarCubit>();
    return BlocListener<ResizableSideBarCubit, ResizableSideBarItemIndex>(
      listener: (context, selectedIndex) {
        if (_isSelected != (widget.index == selectedIndex.childIndex)) {
          setState(() {
            _isSelected = widget.index == selectedIndex.childIndex;
          });
        }
      },
      child: MouseRegion(
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        child: GestureDetector(
          onTap: () {
            widget.parentIndex != null
                ? cubit.selectIndex(
                    childIndex: widget.index, parentIndex: widget.parentIndex!)
                : cubit.reset(childIndex: widget.index);
          },
          child: _resizableSidebarItemContainer(
              icon: widget.icon,
              title: widget.title,
              shared: shared,
              isHovered: _isHovered,
              isSelected: _isSelected),
        ),
      ),
    );
  }
}

Widget _resizableSidebarItemContainer({
  required Widget Function(Color? color) icon,
  required String title,
  required ResizableSharedPropertiesInjector shared,
  required bool isHovered,
  bool isSelected = false,
  bool isOverflow = false,
  bool isVisible = false,
  bool isChildSelected = false,
}) {
  return Container(
    height: 45,
    padding: const EdgeInsets.fromLTRB(8, 2, 0, 2),
    margin: const EdgeInsets.symmetric(
      vertical: 4,
    ),
    decoration: BoxDecoration(
      color: isSelected
          ? (shared.selectedMenuBackgroundColor ?? _defSelectedColor)
          : (isHovered || isChildSelected)
              ? shared.hoverColor
              : shared.menuBackgroundColor ?? Colors.transparent,
      borderRadius: BorderRadius.circular(6),
    ),
    child: Row(
      children: [
        // Icon(
        //   icon,
        //   color: shared.iconColor != null
        //       ? (isSelected ? shared.menuBackgroundColor : shared.iconColor)
        //       : (isSelected
        //           ? shared.menuBackgroundColor
        //           : shared.textStyle?.color),
        //   size: shared.iconSize,
        // ),
        SizedBox(
          height: shared.iconSize,
          width: shared.iconSize,
          child: icon(shared.iconColor != null
              ? (isSelected ? shared.menuBackgroundColor : shared.iconColor)
              : (isSelected
                  ? shared.menuBackgroundColor
                  : shared.textStyle?.color)),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: (shared.textStyle ?? TextStyle()).copyWith(
              fontSize: shared.textStyle?.fontSize ?? (shared.fontSize),
              color: shared.textStyle?.color != null
                  ? (isSelected
                      ? shared.menuBackgroundColor
                      : shared.textStyle?.color)
                  : (isSelected
                      ? shared.menuBackgroundColor
                      : shared.iconColor),
            ),
          ),
        ),
        Visibility(
          visible: isOverflow,
          child: Padding(
            padding: const EdgeInsets.only(left: 4),
            child: AnimatedRotation(
              duration: const Duration(milliseconds: 250),
              turns: isVisible ? 0.5 : 0,
              child: Icon(
                Icons.arrow_drop_up,
                color: shared.iconColor ?? shared.textStyle?.color,
              ),
            ),
          ),
        ),
      ],
    ),
  );
}

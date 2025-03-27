import 'package:flutter/material.dart';

class AdaptiveLayout extends StatelessWidget {
  final Widget? narrowLayout;
  final Widget? wideLayout;
  final double narrowMaxWidth;
  final double wideMaxWidth;
  final double? maxHeight;

  const AdaptiveLayout({
    this.narrowLayout,
    this.wideLayout,
    this.narrowMaxWidth = 600.0,
    this.wideMaxWidth = 1200.0,
    this.maxHeight,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final orientation = MediaQuery.of(context).orientation;
        final isLandscape = orientation == Orientation.landscape;

        Widget? currentLayout;

        if (constraints.maxWidth > narrowMaxWidth && !isLandscape) {
          // wide screen portrait
          currentLayout = wideLayout;
        } else if (constraints.maxWidth > narrowMaxWidth &&
            isLandscape &&
            constraints.maxHeight > narrowMaxWidth) {
          // wide screen landscape
          currentLayout = wideLayout;
        } else {
          // phone screen
          currentLayout = narrowLayout;
        }

        return AnimatedOpacity(
          opacity: currentLayout == null ? 0 : 1,
          duration: const Duration(milliseconds: 300),
          child: _buildRestrictedLayout(
              currentLayout,
              constraints.maxWidth > narrowMaxWidth
                  ? wideMaxWidth
                  : narrowMaxWidth,
              maxHeight,
              key: ValueKey(currentLayout)),
        );
      },
    );
  }

  Widget _buildRestrictedLayout(
      Widget? child, double maxWidth, double? maxHeight,
      {Key? key}) {
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: maxWidth,
          maxHeight: maxHeight ?? double.infinity,
        ),
        child: child ?? const SizedBox.shrink(),
      ),
    );
  }
}

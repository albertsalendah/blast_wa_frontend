part of 'resizable_side_bar.dart';

class _ResizableSideBarState extends State<ResizableSideBar> {
  final PageController _pageController = PageController(initialPage: 0);
  double _sidebarWidth = 250;
  late double _fixedSidebarWidth;
  double _minWidth = 56;
  final double _maxWidth = 350;
  double? _prevScreenWidth;
  final Duration _duration = const Duration(milliseconds: 60);
  bool _isExpanded = false;
  bool shouldCollapse = false;
  final double _iconSize = 24;
  final double _fontSize = 16;

  @override
  void initState() {
    _fixedSidebarWidth = _sidebarWidth;
    _minWidth = _iconSize + 32;
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _updateSidebarState();
  }

  void _updateSidebarState() {
    final fullScreenWidth = MediaQuery.of(context).size.width;

    if (_prevScreenWidth != null &&
        (fullScreenWidth - _prevScreenWidth!).abs() < 10) {
      return;
    }
    _prevScreenWidth = fullScreenWidth;
    shouldCollapse = fullScreenWidth <= (_fixedSidebarWidth * 2);
    if (shouldCollapse != _isExpanded) {
      _isExpanded = shouldCollapse;
      _sidebarWidth = _isExpanded ? _minWidth : _fixedSidebarWidth;
    }
  }

  ResizableSidebarSharedPropertiesWrapper _sharePropertiesWrapper(
      {required Widget child}) {
    return ResizableSidebarSharedPropertiesWrapper(
      iconSize: _iconSize,
      fontSize: _fontSize,
      selectedMenuBackgroundColor: widget.selectedMenuBackgroundColor,
      iconColor: widget.iconColor,
      hoverColor: widget.hoverColor,
      menuBackgroundColor: widget.menuBackgroundColor ?? widget.backgroundColor,
      textStyle: widget.textStyle,
      child: child,
    );
  }

  void _navigateTo(BuildContext context, int index) {
    if (index < widget.pageList.length) {
      _pageController.animateToPage(
        index,
        duration: const Duration(milliseconds: 120),
        curve: Curves.easeInOut,
      );
    }
  }

  double _getHeaderHeight() {
    final TextPainter titleTextPainter = _getTitleTextPainter();
    final titleHeight =
        (widget.title != null && !titleTextPainter.didExceedMaxLines)
            ? titleTextPainter.height
            : 0;
    final headerHight =
        widget.header != null ? (_sidebarWidth / 2).ceilToDouble() : 0;
    final height = _minWidth + headerHight + titleHeight;
    return height;
  }

  TextPainter _getTitleTextPainter() {
    return TextPainter(
      text: TextSpan(
        text: widget.title,
        style: (widget.textStyle ?? TextStyle()).copyWith(
            fontWeight: FontWeight.w600,
            fontSize: widget.textStyle?.fontSize ?? (_fontSize + 2)),
      ),
      maxLines: 1,
      textDirection: TextDirection.ltr,
    )..layout(maxWidth: _sidebarWidth);
  }

  @override
  Widget build(BuildContext context) {
    int indexCounter = 0;
    double screemWidth = MediaQuery.of(context).size.width;
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => ResizableSideBarCubit()),
      ],
      child: LayoutBuilder(
        builder: (context, constraints) {
          if (screemWidth > 600) {
            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //SideBar
                _sideBar(context, indexCounter),
                //Pages
                Expanded(child: _pages(screemWidth: screemWidth))
              ],
            );
          } else {
            return Stack(
              // crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //Pages
                Positioned(
                  top: 0,
                  bottom: 0,
                  right: 0,
                  child: SizedBox(
                    width: screemWidth - _minWidth,
                    child: _pages(screemWidth: screemWidth),
                  ),
                ),
                //SideBar
                Positioned(
                  top: 0,
                  bottom: 0,
                  left: 0,
                  child: _sideBar(context, indexCounter),
                ),
              ],
            );
          }
        },
      ),
    );
  }

  Widget _pages({required double screemWidth}) {
    return BlocListener<ResizableSideBarCubit, ResizableSideBarItemIndex>(
      listener: (context, selectedIndex) {
        _navigateTo(
          context,
          selectedIndex.childIndex,
        );
      },
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          if (widget.onTapPages != null) {
            widget.onTapPages!();
          }
          setState(() {
            if (screemWidth < 600) {
              if (_isExpanded == false) {
                _isExpanded = true;
                _sidebarWidth = _minWidth;
              }
            }
          });
        },
        child: PageView(
          controller: _pageController,
          onPageChanged: (index) {},
          children: widget.pageList,
        ),
      ),
    );
  }

  Widget _sideBar(BuildContext context, int indexCounter) {
    return Container(
      width: _sidebarWidth,
      height: double.infinity,
      color: widget.backgroundColor,
      padding: const EdgeInsets.fromLTRB(8, 8, 0, 8),
      child: Stack(
        children: [
          AnimatedPositioned(
            duration: _duration,
            top: _getHeaderHeight(),
            left: 0,
            right: 8,
            bottom: 50,
            child: ScrollConfiguration(
              behavior:
                  ScrollConfiguration.of(context).copyWith(scrollbars: false),
              child: ListView.builder(
                itemCount: widget.items.length,
                itemBuilder: (context, i) {
                  final widgetItem = widget.items[i];

                  if (widgetItem is ResizableSideBarExpandedItem) {
                    final renderedWidget = widgetItem.setIndex(indexCounter);
                    indexCounter += widgetItem.children.length;
                    return _sharePropertiesWrapper(child: renderedWidget);
                  } else {
                    final renderedWidget = widgetItem.setIndex(indexCounter);
                    indexCounter++;
                    return _sharePropertiesWrapper(child: renderedWidget);
                  }
                },
              ),
            ),
          ),
          Positioned(
            left: 0,
            right: 8,
            top: 0,
            child: SizedBox(
              height: _getHeaderHeight(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  IconButton(
                    color: widget.iconColor,
                    hoverColor: widget.hoverColor,
                    highlightColor: widget.hoverColor,
                    style: ButtonStyle(
                      shape: WidgetStateProperty.all(CircleBorder()),
                      padding: WidgetStateProperty.all(EdgeInsets.zero),
                    ),
                    onPressed: () {
                      // if (!shouldCollapse) {
                      setState(
                        () {
                          _isExpanded = !_isExpanded;
                          _sidebarWidth =
                              _isExpanded ? _minWidth : _fixedSidebarWidth;
                        },
                      );
                      // }
                    },
                    icon: Icon(
                      Icons.menu,
                      size: _iconSize,
                      color: widget.iconColor ?? widget.textStyle?.color,
                    ),
                  ),
                  _sharePropertiesWrapper(
                    child: _ResizableSideBarHeader(
                      header: widget.header,
                      setPosition: _sidebarWidth == _getHeaderHeight(),
                      size: _iconSize > (_sidebarWidth / 2.3)
                          ? _iconSize
                          : _sidebarWidth / 2.3,
                    ),
                  ),
                  Container(
                    height: 8,
                  ),
                  _sharePropertiesWrapper(
                    child: _ResizableSideBarTitle(
                      title: widget.title,
                      visible: !_getTitleTextPainter().didExceedMaxLines,
                    ),
                  ),
                  Divider(
                    height: 1,
                    color: widget.selectedMenuBackgroundColor ?? Colors.white,
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 8,
            child: _sharePropertiesWrapper(
              child: _ResizableSideBarFooter(
                width: _sidebarWidth,
                labelVisibility: _sidebarWidth > 100,
                backgroundColor: widget.backgroundColor,
                onFooterTap: widget.onFooterTap,
                footerIcon: widget.footerIcon,
                footerLabel: widget.footerLabel,
              ),
            ),
          ),
          Positioned(
            left: _sidebarWidth - 14,
            right: 0,
            top: 0,
            bottom: 0,
            child: _sharePropertiesWrapper(
              child: _ResizableSideBarHandle(
                color: widget.backgroundColor,
                onHorizontalDragUpdate: (details) {
                  if (!shouldCollapse) {
                    setState(() {
                      _sidebarWidth += details.delta.dx;
                      _sidebarWidth = _sidebarWidth.clamp(_minWidth, _maxWidth);
                      if (_sidebarWidth > _minWidth) {
                        _isExpanded = false;
                      }
                    });
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

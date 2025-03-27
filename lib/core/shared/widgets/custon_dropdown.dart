import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

typedef DropDownOptionsBuilder<T extends Object> = FutureOr<Iterable<T>>
    Function(TextEditingValue textEditingValue);
typedef DropDownOnSelected<T extends Object> = void Function(T option);
typedef DropDownOptionsViewBuilder<T extends Object> = Widget Function(
  BuildContext context,
  AutocompleteOnSelected<T> onSelected,
  Iterable<T> options,
);
typedef DropDownEmptyViewBuilder<T extends Object> = Widget Function(
  BuildContext context,
);
typedef DropDownFieldViewBuilder = Widget Function(
  BuildContext context,
  TextEditingController textEditingController,
  FocusNode focusNode,
  VoidCallback onFieldSubmitted,
);
typedef DropDownOptionToString<T extends Object> = String Function(T option);

enum DropDownOptionsViewOpenDirection { up, down }

class CustomDropDown<T extends Object> extends StatefulWidget {
  const CustomDropDown({
    super.key,
    this.emptyViewBuilder,
    required this.optionsViewBuilder,
    required this.optionsBuilder,
    this.optionsViewOpenDirection = DropDownOptionsViewOpenDirection.down,
    this.displayStringForOption = defaultStringForOption,
    this.fieldViewBuilder,
    this.focusNode,
    this.onSelected,
    this.textEditingController,
    this.initialValue,
  })  : assert(
          fieldViewBuilder != null ||
              (key != null &&
                  focusNode != null &&
                  textEditingController != null),
          'Pass in a fieldViewBuilder, or otherwise create a separate field and pass in the FocusNode, TextEditingController, and a key. Use the key with RawAutocomplete.onFieldSubmitted.',
        ),
        assert((focusNode == null) == (textEditingController == null)),
        assert(
          !(textEditingController != null && initialValue != null),
          'textEditingController and initialValue cannot be simultaneously defined.',
        );
  final DropDownFieldViewBuilder? fieldViewBuilder;
  final FocusNode? focusNode;
  final DropDownOptionsViewBuilder<T> optionsViewBuilder;
  final DropDownEmptyViewBuilder<T>? emptyViewBuilder;
  final DropDownOptionsViewOpenDirection optionsViewOpenDirection;
  final DropDownOptionToString<T> displayStringForOption;
  final DropDownOnSelected<T>? onSelected;
  final DropDownOptionsBuilder<T> optionsBuilder;
  final TextEditingController? textEditingController;
  final TextEditingValue? initialValue;
  static void onFieldSubmitted<T extends Object>(GlobalKey key) {
    final _CustomDropDownState<T> rawAutocomplete =
        key.currentState! as _CustomDropDownState<T>;
    rawAutocomplete._onFieldSubmitted();
  }

  static String defaultStringForOption(Object? option) {
    return option.toString();
  }

  @override
  State<CustomDropDown<T>> createState() => _CustomDropDownState<T>();
}

class _CustomDropDownState<T extends Object> extends State<CustomDropDown<T>> {
  final GlobalKey _fieldKey = GlobalKey();
  final LayerLink _optionsLayerLink = LayerLink();
  final OverlayPortalController _optionsViewController =
      OverlayPortalController(debugLabel: '_CustomDropDownState');

  TextEditingController? _internalTextEditingController;
  TextEditingController get _textEditingController {
    return widget.textEditingController ??
        (_internalTextEditingController ??= TextEditingController()
          ..addListener(_onChangedField));
  }

  FocusNode? _internalFocusNode;
  FocusNode get _focusNode {
    return widget.focusNode ??
        (_internalFocusNode ??= FocusNode()
          ..addListener(_updateOptionsViewVisibility));
  }

  late final Map<Type, CallbackAction<Intent>> _actionMap =
      <Type, CallbackAction<Intent>>{
    DropDownPreviousOptionIntent:
        _DropDownCallbackAction<DropDownPreviousOptionIntent>(
      onInvoke: _highlightPreviousOption,
      isEnabledCallback: () => _canShowOptionsView,
    ),
    DropDownNextOptionIntent: _DropDownCallbackAction<DropDownNextOptionIntent>(
      onInvoke: _highlightNextOption,
      isEnabledCallback: () => _canShowOptionsView,
    ),
    DismissIntent: CallbackAction<DismissIntent>(onInvoke: _hideOptions),
  };

  Iterable<T> _options = Iterable<T>.empty();
  T? _selection;

  String? _lastFieldText;
  final ValueNotifier<int> _highlightedOptionIndex = ValueNotifier<int>(0);

  static const Map<ShortcutActivator, Intent> _shortcuts =
      <ShortcutActivator, Intent>{
    SingleActivator(LogicalKeyboardKey.arrowUp): DropDownPreviousOptionIntent(),
    SingleActivator(LogicalKeyboardKey.arrowDown): DropDownNextOptionIntent(),
  };

  bool get _canShowOptionsView => _focusNode.hasFocus && _selection == null;

  void _updateOptionsViewVisibility() {
    if (_canShowOptionsView) {
      _optionsViewController.show();
    } else {
      _optionsViewController.hide();
    }
  }

  Future<void> _onChangedField() async {
    final TextEditingValue value = _textEditingController.value;
    final Iterable<T> options = await widget.optionsBuilder(value);
    _options = options;
    _updateHighlight(_highlightedOptionIndex.value);
    final T? selection = _selection;
    if (selection != null &&
        value.text != widget.displayStringForOption(selection)) {
      _selection = null;
    }
    if (value.text != _lastFieldText) {
      _lastFieldText = value.text;
      _updateOptionsViewVisibility();
    }
  }

  void _onFieldSubmitted() {
    if (_optionsViewController.isShowing) {
      _select(_options.elementAt(_highlightedOptionIndex.value));
    }
  }

  void _select(T nextSelection) {
    if (nextSelection == _selection) {
      return;
    }
    _selection = nextSelection;
    final String selectionString = widget.displayStringForOption(nextSelection);
    _textEditingController.value = TextEditingValue(
      selection: TextSelection.collapsed(offset: selectionString.length),
      text: selectionString,
    );
    widget.onSelected?.call(nextSelection);
    _updateOptionsViewVisibility();
  }

  void _updateHighlight(int newIndex) {
    _highlightedOptionIndex.value =
        _options.isEmpty ? 0 : newIndex % _options.length;
  }

  void _highlightPreviousOption(DropDownPreviousOptionIntent intent) {
    assert(_canShowOptionsView);
    _updateOptionsViewVisibility();
    assert(_optionsViewController.isShowing);
    _updateHighlight(_highlightedOptionIndex.value - 1);
  }

  void _highlightNextOption(DropDownNextOptionIntent intent) {
    assert(_canShowOptionsView);
    _updateOptionsViewVisibility();
    assert(_optionsViewController.isShowing);
    _updateHighlight(_highlightedOptionIndex.value + 1);
  }

  Object? _hideOptions(DismissIntent intent) {
    if (_optionsViewController.isShowing) {
      _optionsViewController.hide();
      return null;
    } else {
      return Actions.invoke(context, intent);
    }
  }

  Widget _buildOptionsView(BuildContext context) {
    final TextDirection textDirection = Directionality.of(context);
    final Alignment followerAlignment =
        switch (widget.optionsViewOpenDirection) {
      DropDownOptionsViewOpenDirection.up => AlignmentDirectional.bottomStart,
      DropDownOptionsViewOpenDirection.down => AlignmentDirectional.topStart,
    }
            .resolve(textDirection);
    final Alignment targetAnchor = switch (widget.optionsViewOpenDirection) {
      DropDownOptionsViewOpenDirection.up => AlignmentDirectional.topStart,
      DropDownOptionsViewOpenDirection.down => AlignmentDirectional.bottomStart,
    }
        .resolve(textDirection);
    return CompositedTransformFollower(
      link: _optionsLayerLink,
      showWhenUnlinked: false,
      targetAnchor: targetAnchor,
      followerAnchor: followerAlignment,
      child: TextFieldTapRegion(
        child: DropDownHighlightedOption(
          highlightIndexNotifier: _highlightedOptionIndex,
          child: LayoutBuilder(
            builder: (context, constraints) {
              final isEmpty =
                  widget.emptyViewBuilder != null && _options.isEmpty;
              return ConstrainedBox(
                constraints: BoxConstraints(
                    maxHeight: 300, maxWidth: constraints.maxWidth),
                child: isEmpty
                    ? widget.emptyViewBuilder!(context)
                    : widget.optionsViewBuilder(context, _select, _options),
              );
              // if (widget.emptyViewBuilder != null && _options.isEmpty) {
              //   return widget.emptyViewBuilder!(context);
              // } else {
              //   return widget.optionsViewBuilder(context, _select, _options);
              // }
            },
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    final TextEditingController initialController =
        widget.textEditingController ??
            (_internalTextEditingController =
                TextEditingController.fromValue(widget.initialValue));
    initialController.addListener(_onChangedField);
    widget.focusNode?.addListener(_updateOptionsViewVisibility);
  }

  @override
  void didUpdateWidget(CustomDropDown<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!identical(
        oldWidget.textEditingController, widget.textEditingController)) {
      oldWidget.textEditingController?.removeListener(_onChangedField);
      if (oldWidget.textEditingController == null) {
        _internalTextEditingController?.dispose();
        _internalTextEditingController = null;
      }
      widget.textEditingController?.addListener(_onChangedField);
    }
    if (!identical(oldWidget.focusNode, widget.focusNode)) {
      oldWidget.focusNode?.removeListener(_updateOptionsViewVisibility);
      if (oldWidget.focusNode == null) {
        _internalFocusNode?.dispose();
        _internalFocusNode = null;
      }
      widget.focusNode?.addListener(_updateOptionsViewVisibility);
    }
  }

  @override
  void dispose() {
    widget.textEditingController?.removeListener(_onChangedField);
    _internalTextEditingController?.dispose();
    widget.focusNode?.removeListener(_updateOptionsViewVisibility);
    _internalFocusNode?.dispose();
    _highlightedOptionIndex.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Widget fieldView = widget.fieldViewBuilder?.call(
            context, _textEditingController, _focusNode, _onFieldSubmitted) ??
        const SizedBox.shrink();
    return OverlayPortal.targetsRootOverlay(
      controller: _optionsViewController,
      overlayChildBuilder: _buildOptionsView,
      child: TextFieldTapRegion(
        child: Container(
          key: _fieldKey,
          child: Shortcuts(
            shortcuts: _shortcuts,
            child: Actions(
              actions: _actionMap,
              child: CompositedTransformTarget(
                link: _optionsLayerLink,
                child: fieldView,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _DropDownCallbackAction<T extends Intent> extends CallbackAction<T> {
  _DropDownCallbackAction({
    required super.onInvoke,
    required this.isEnabledCallback,
  });
  final bool Function() isEnabledCallback;

  @override
  bool isEnabled(covariant T intent) => isEnabledCallback();

  @override
  bool consumesKey(covariant T intent) => isEnabled(intent);
}

class DropDownPreviousOptionIntent extends Intent {
  const DropDownPreviousOptionIntent();
}

class DropDownNextOptionIntent extends Intent {
  const DropDownNextOptionIntent();
}

class DropDownHighlightedOption extends InheritedNotifier<ValueNotifier<int>> {
  const DropDownHighlightedOption({
    super.key,
    required ValueNotifier<int> highlightIndexNotifier,
    required super.child,
  }) : super(notifier: highlightIndexNotifier);
  static int of(BuildContext context) {
    return context
            .dependOnInheritedWidgetOfExactType<DropDownHighlightedOption>()
            ?.notifier
            ?.value ??
        0;
  }
}

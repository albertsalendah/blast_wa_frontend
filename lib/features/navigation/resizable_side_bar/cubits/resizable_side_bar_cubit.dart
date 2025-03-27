import 'package:flutter_bloc/flutter_bloc.dart';

class ResizableSideBarCubit extends Cubit<ResizableSideBarItemIndex> {
  ResizableSideBarCubit()
      : super(ResizableSideBarItemIndex(childIndex: 0, parentIndex: -1));

  void selectIndex({required int childIndex, required int parentIndex}) =>
      emit(ResizableSideBarItemIndex(
          childIndex: childIndex, parentIndex: parentIndex));

  void reset({required int childIndex}) =>
      emit(ResizableSideBarItemIndex(childIndex: childIndex, parentIndex: -1));

  ResizableSideBarItemIndex getSelectedIndex() => state;
}

class ResizableSideBarItemIndex {
  final int childIndex;
  final int parentIndex;
  ResizableSideBarItemIndex({
    required this.childIndex,
    required this.parentIndex,
  });
}

import 'package:flutter/material.dart';
import 'package:whatsapp_blast/config/theme/app_pallet.dart';
import 'package:whatsapp_blast/core/shared/entities/image_data.dart';
import 'package:whatsapp_blast/core/utils/file_picker.dart';

class ImageListview {
  ImageListview();

  show({
    required BuildContext context,
    required GlobalKey key,
    required double topPading,
    required List<ImageData> listImages,
    required final Function(List<ImageData> list) updatedList,
    required final Function(List<ImageData> list) deleteImage,
  }) {
    List<ImageData> updatedListImages = List.from(listImages);
    ImageData? selectedImage =
        updatedListImages.isNotEmpty ? updatedListImages.first : null;
    final ScrollController scrollController = ScrollController();

    Future<void> addImage() async {
      final newImages = await pickImage();
      if (newImages.isNotEmpty) {
        updatedListImages.addAll(newImages);
        updatedListImages = updatedListImages.reversed.toList();
        updatedList(updatedListImages);
        updatedListImages.reversed;
        selectedImage = updatedListImages.first;
      }
    }

    showDialog(
      context: context,
      barrierColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return LayoutBuilder(
              builder: (context, constraints) {
                final RenderBox? renderBox =
                    key.currentContext?.findRenderObject() as RenderBox?;
                final offset =
                    renderBox?.localToGlobal(Offset.zero) ?? Offset.zero;
                final dialogHeight = 500.0;
                double topPosition = offset.dy - dialogHeight;
                if (topPosition < 0) {
                  topPosition = (renderBox?.size.height ?? 0.0) + offset.dy;
                }

                return Stack(
                  children: [
                    Positioned(
                      left: offset.dx,
                      top: topPosition - topPading,
                      child: Material(
                        color: Colors.transparent,
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          height: dialogHeight,
                          width: constraints.maxWidth <= 600 ? 300 : 400,
                          decoration: BoxDecoration(
                            color: AppPallete.darkGreen,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Column(
                            children: [
                              Container(
                                height: 380,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: AppPallete.backgroundColor,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Stack(
                                  children: [
                                    SizedBox(
                                      width: double.infinity,
                                      height: double.infinity,
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(6),
                                        child: selectedImage != null &&
                                                selectedImage?.byte != null
                                            ? Image.memory(
                                                selectedImage!.byte!,
                                                fit: BoxFit.cover,
                                              )
                                            : const SizedBox(),
                                      ),
                                    ),
                                    Positioned(
                                        top: 4,
                                        right: 4,
                                        child: _iconButton(
                                          icon: Icons.delete_outline_rounded,
                                          onTap: () {
                                            if (selectedImage != null) {
                                              int index = updatedListImages
                                                  .indexOf(selectedImage!);
                                              deleteImage(updatedListImages);
                                              updatedListImages.removeAt(index);

                                              if (updatedListImages
                                                  .isNotEmpty) {
                                                selectedImage =
                                                    updatedListImages.first;
                                              } else {
                                                Navigator.of(context).pop();
                                                return;
                                              }
                                              setState(() {});
                                            }
                                          },
                                        )),
                                    Positioned(
                                      top: 4,
                                      left: 4,
                                      child: _iconButton(
                                        icon: Icons.add_a_photo_outlined,
                                        onTap: () async {
                                          await addImage().then(
                                            (value) {
                                              setState(() {});
                                            },
                                          );
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 4),
                              SizedBox(
                                height: 100,
                                width: double.infinity,
                                child: ScrollConfiguration(
                                  behavior: ScrollConfiguration.of(context)
                                      .copyWith(scrollbars: true),
                                  child: Scrollbar(
                                    controller: scrollController,
                                    child: ListView.builder(
                                      controller: scrollController,
                                      physics: const BouncingScrollPhysics(),
                                      scrollDirection: Axis.horizontal,
                                      itemCount: updatedListImages.length,
                                      itemBuilder: (context, index) {
                                        final isLast =
                                            updatedListImages[index] !=
                                                updatedListImages.last;
                                        return GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              selectedImage =
                                                  updatedListImages[index];
                                            });
                                          },
                                          child: Container(
                                            height: 100,
                                            width: 100,
                                            margin: EdgeInsets.only(
                                                top: 4, right: isLast ? 8 : 0),
                                            decoration: BoxDecoration(
                                              color: AppPallete.backgroundColor,
                                              borderRadius:
                                                  BorderRadius.circular(6),
                                            ),
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(6),
                                              child: updatedListImages[index]
                                                          .byte !=
                                                      null
                                                  ? Image.memory(
                                                      updatedListImages[index]
                                                          .byte!,
                                                      fit: BoxFit.cover,
                                                    )
                                                  : const SizedBox.shrink(),
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            );
          },
        );
      },
    );
  }

  SizedBox _iconButton({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return SizedBox(
      width: 32,
      height: 32,
      child: IconButton(
        hoverColor: AppPallete.borderColor.withAlpha(200),
        style: ButtonStyle(
          shape: WidgetStateProperty.all(
            const CircleBorder(),
          ),
          padding: WidgetStateProperty.all(EdgeInsets.zero),
        ),
        onPressed: onTap,
        icon: Icon(
          icon,
          size: 24,
          color: AppPallete.white,
        ),
      ),
    );
  }
}

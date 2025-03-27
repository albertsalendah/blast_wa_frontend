// ignore_for_file: file_names
import 'package:expandable_text/expandable_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:whatsapp_blast/config/theme/app_pallet.dart';
import 'package:whatsapp_blast/core/shared/entities/image_data.dart';
import 'package:whatsapp_blast/core/shared/widgets/message_bubble_painter.dart';

class MessageCard extends StatelessWidget {
  final String message;
  final List<ImageData> images;
  final Function(ImageData image) deleteImage;
  final Function() onTapImageList;
  const MessageCard(
      {super.key,
      required this.message,
      required this.images,
      required this.deleteImage,
      required this.onTapImageList});

  @override
  Widget build(BuildContext context) {
    double imageHeight = 225;
    return Align(
      alignment: Alignment.centerRight,
      child: SizedBox(
        width: 250,
        child: Padding(
          padding: const EdgeInsets.all(6),
          child: CustomPaint(
            painter: MessageBubblePainter(),
            child: Container(
              clipBehavior: Clip.hardEdge,
              decoration: BoxDecoration(
                  color: AppPallete.darkGreen,
                  borderRadius: BorderRadius.circular(6)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (images.isNotEmpty) ...[
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: Visibility(
                        visible: images.length == 1,
                        replacement: SizedBox(
                          height: images.length == 2
                              ? imageHeight / 2
                              : imageHeight,
                          child: Stack(
                            children: [
                              GridView.builder(
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                ),
                                itemCount:
                                    images.length < 4 ? images.length : 4,
                                itemBuilder: (context, index) {
                                  Uint8List? imageBytes = images[index].byte;
                                  return imageBytes != null
                                      ? Padding(
                                          padding: const EdgeInsets.all(2.0),
                                          child: imagesView(
                                              image: images[index],
                                              height: imageHeight / 2),
                                        )
                                      : Container();
                                },
                              ),
                              if (images.length > 4)
                                imageListViewer(
                                    context: context, imageHeight: imageHeight)
                            ],
                          ),
                        ),
                        child: imagesView(
                            image: images.first, height: imageHeight),
                      ),
                    ),
                  ],
                  Visibility(
                    visible: message.isNotEmpty,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
                      child: ExpandableText(
                        message,
                        expandText: 'show more',
                        collapseText: 'show less',
                        maxLines: 5,
                        style: TextStyle(
                          color: AppPallete.white,
                        ),
                        linkColor: Colors.grey,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget imageListViewer(
      {required BuildContext context, required double imageHeight}) {
    return GestureDetector(
      onTap: () {
        onTapImageList();
      },
      child: Container(
        height: imageHeight,
        width: double.infinity,
        decoration: BoxDecoration(
          color: AppPallete.backgroundColor.withAlpha(150),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Center(
          child: Container(
            height: 32,
            width: 32,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              border: Border.all(color: AppPallete.white),
              borderRadius: BorderRadius.circular(32),
            ),
            child: Text(
              images.length.toString(),
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppPallete.white,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget imagesView({required ImageData image, double? height}) {
    return Stack(
      children: [
        SizedBox(
          width: double.infinity,
          height: height,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: image.byte != null
                ? Image.memory(
                    image.byte!,
                    fit: BoxFit.cover,
                  )
                : const SizedBox.shrink(),
          ),
        ),
        if (images.length <= 4)
          Positioned(
            top: 2,
            right: 2,
            child: SizedBox(
              width: 28,
              height: 28,
              child: IconButton(
                hoverColor: AppPallete.borderColor.withAlpha(200),
                style: ButtonStyle(
                  shape: WidgetStateProperty.all(
                      CircleBorder(side: BorderSide(color: AppPallete.white))),
                  padding: WidgetStateProperty.all(EdgeInsets.zero),
                ),
                onPressed: () {
                  deleteImage(image);
                },
                icon: Icon(
                  Icons.delete_outline_rounded,
                  size: 22,
                  color: AppPallete.white,
                ),
              ),
            ),
          ),
      ],
    );
  }
}

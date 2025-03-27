import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:whatsapp_blast/config/theme/app_pallet.dart';
import 'package:whatsapp_blast/core/shared/entities/image_data.dart';
import 'package:whatsapp_blast/core/utils/constants/constants.dart';
import 'package:whatsapp_blast/core/utils/file_picker.dart';
import 'package:whatsapp_blast/core/utils/show_snackbar.dart';
import 'package:whatsapp_blast/features/whatsapp_api/presentation/bloc/websocket_cubit.dart';
import 'package:whatsapp_blast/features/whatsapp_api/presentation/bloc/whatsapp_bloc.dart';
import 'package:whatsapp_blast/features/whatsapp_api/presentation/widgets/dropdown_number.dart';
import 'package:whatsapp_blast/features/whatsapp_api/presentation/widgets/image_listview.dart';

import '../widgets/message_progress_list.dart';
import 'chat_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({
    super.key,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool showProgress = false;

  final GlobalKey excelBtnKey = GlobalKey();
  PlatformFile? excelFile;
  String noWa = '';
  bool waConnectionStatus = false;
  List<ImageData> listImages = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<WhatsappBloc, WhatsappState>(
      listener: (context, state) {
        if (state is SendMessageSuccess) {
          listImages.clear();
          excelFile = null;
          setState(() {});
          showSnackBarSuccess(
              context: context, message: state.response.message);
        }
        if (state is WhatsappFailure) {
          showSnackBarError(context: context, message: state.message);
        }
      },
      child: BlocBuilder<WebSocketCubit, WebSocketState>(
        builder: (context, state) {
          waConnectionStatus = state.connectionStatus[state.selectedClient] ==
              ConnectionStatus.open;
          if (waConnectionStatus) {
            noWa = state.selectedClient;
          }
          return LayoutBuilder(
            builder: (context, constraints) {
              double width = constraints.maxWidth;
              if (width > 800 && !showProgress) {
                showProgress = !showProgress;
              }

              if (constraints.minHeight < 50) {
                return SizedBox.shrink();
              }
              return SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: Column(
                    children: [
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.fromLTRB(0, 8, 8, 8),
                        color: AppPallete.green,
                        child: SingleChildScrollView(
                          child: DropdownNumber(
                            onTapProgress: () {
                              setState(() {
                                showProgress = !showProgress;
                              });
                            },
                          ),
                        ),
                      ),
                      SizedBox(
                        height: constraints.maxHeight - 60,
                        width: double.infinity,
                        child: _screen(
                            isListEmpty: state.messageProgress.isNotEmpty,
                            width: width),
                      )
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _screen({required bool isListEmpty, required double width}) {
    bool isBigScreen = width > 800;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (!showProgress || isBigScreen)
          Expanded(
            flex: 2,
            child: _chatPage(),
          ),
        if (isBigScreen)
          VerticalDivider(
            width: 1,
            thickness: 1,
            color: AppPallete.borderColor,
          ),
        if (showProgress)
          Flexible(
            flex: 1,
            fit: FlexFit.tight,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Visibility(
                visible: isListEmpty,
                replacement: SizedBox(
                  height: 40,
                  child: Center(child: Text('No messages yet!')),
                ),
                child: MessageProgressList(),
              ),
            ),
          ),
      ],
    );
  }

  ChatPage _chatPage() {
    return ChatPage(
      noWa: noWa,
      excelBtnKey: excelBtnKey,
      waConnectionStatus: waConnectionStatus,
      excelFile: excelFile,
      listImages: listImages,
      deleteImage: (image) {
        setState(() {
          listImages.remove(image);
        });
      },
      onTapExcel: () async {
        setState(() {
          excelFile = null;
        });
        await pickExcel().then(
          (value) {
            if (value != null) {
              setState(() {
                excelFile = value;
              });
            }
          },
        );
      },
      onTapImage: () async {
        await pickImage().then(
          (value) {
            setState(() {
              listImages.addAll(value.reversed.toList());
            });
          },
        );
      },
      onTapImageList: () {
        ImageListview().show(
          context: context,
          key: excelBtnKey,
          topPading: excelFile != null ? 50 : 10,
          listImages: listImages,
          updatedList: (list) {
            setState(() {
              listImages = list;
            });
          },
          deleteImage: (list) {
            setState(() {
              listImages = list;
            });
          },
        );
      },
    );
  }
}

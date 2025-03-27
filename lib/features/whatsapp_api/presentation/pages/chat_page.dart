import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:whatsapp_blast/config/theme/app_pallet.dart';
import 'package:whatsapp_blast/core/di/init_dependencies.dart';
import 'package:whatsapp_blast/core/network/token_manager.dart';
import 'package:whatsapp_blast/core/shared/entities/image_data.dart';
import 'package:whatsapp_blast/core/shared/models/country_code_model.dart';
import 'package:whatsapp_blast/core/shared/widgets/country_code_dropdown.dart';
import 'package:whatsapp_blast/core/utils/show_snackbar.dart';
import 'package:whatsapp_blast/features/whatsapp_api/domain/usecases/send_message.dart';
import 'package:whatsapp_blast/features/whatsapp_api/presentation/bloc/whatsapp_bloc.dart';
import 'package:whatsapp_blast/features/whatsapp_api/presentation/widgets/excell_button.dart';
import 'package:whatsapp_blast/features/whatsapp_api/presentation/widgets/messageCard.dart';
import 'package:whatsapp_blast/features/whatsapp_api/presentation/widgets/message_text_field.dart';

class ChatPage extends StatefulWidget {
  final String noWa;
  final GlobalKey excelBtnKey;
  final bool waConnectionStatus;
  final List<ImageData> listImages;
  final PlatformFile? excelFile;
  final VoidCallback onTapExcel;
  final VoidCallback onTapImage;
  final VoidCallback onTapImageList;
  final Function(ImageData image) deleteImage;
  const ChatPage({
    super.key,
    required this.noWa,
    required this.excelBtnKey,
    required this.waConnectionStatus,
    required this.excelFile,
    required this.listImages,
    required this.onTapExcel,
    required this.onTapImage,
    required this.onTapImageList,
    required this.deleteImage,
  });

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController messageController = TextEditingController();
  String selectedClient = '';
  String email = '';
  CountryCode? _selectedCountryCode;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      String? token = serviceLocator<TokenManager>().accessToken;
      email = token != null ? JwtDecoder.decode(token)['email'] : '';
    });
  }

  @override
  void dispose() {
    messageController.dispose();
    super.dispose();
  }

  bool _checkInput() {
    return (widget.waConnectionStatus != false &&
        widget.excelFile != null &&
        _selectedCountryCode != null);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<WhatsappBloc, WhatsappState>(
      listener: (context, state) {
        if (state is SendMessageSuccess) {
          messageController.clear();
          setState(() {});
        }
      },
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ListView(
                children: [
                  MessageCard(
                    message: messageController.text,
                    images: widget.listImages,
                    deleteImage: widget.deleteImage,
                    onTapImageList: widget.onTapImageList,
                  ),
                ],
              ),
            ),
            SizedBox(height: 8),
            if (widget.excelFile != null)
              Row(
                children: [
                  CountryCodeDropdown(
                    onSelected: (countryCode) {
                      _selectedCountryCode = countryCode;
                      setState(() {});
                    },
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  Container(
                    height: 28,
                    padding: EdgeInsets.all(4),
                    alignment: Alignment.centerLeft,
                    decoration: BoxDecoration(
                        color: AppPallete.white,
                        borderRadius: BorderRadius.circular(6)),
                    child: SingleChildScrollView(
                      child: Text(
                        widget.excelFile?.name ?? '',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                ],
              ),
            const SizedBox(
              height: 8,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                ExcellButton(
                  btnKey: widget.excelBtnKey,
                  onTap: widget.onTapExcel,
                  visibility: widget.excelFile != null,
                ),
                const SizedBox(
                  width: 8,
                ),
                MessageTextField(
                    controller: messageController,
                    onChanged: (value) {
                      setState(() {});
                    },
                    onTapSuffix: widget.onTapImage),
                const SizedBox(
                  width: 8,
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: IconButton(
                    hoverColor: AppPallete.borderColor.withAlpha(50),
                    color: _checkInput() ? AppPallete.green : AppPallete.error,
                    disabledColor: AppPallete.error,
                    style: ButtonStyle(
                      backgroundColor:
                          WidgetStateProperty.all<Color>(AppPallete.white),
                      shape: WidgetStateProperty.all(CircleBorder()),
                      padding: WidgetStateProperty.all(EdgeInsets.zero),
                    ),
                    onPressed: () {
                      if (_checkInput()) {
                        context.read<WhatsappBloc>().add(
                              SendMessageEvent(
                                messegeParam: MessegeParam(
                                  listImages: widget.listImages,
                                  excelFile: widget.excelFile!,
                                  email: email,
                                  noWA: widget.noWa,
                                  message: messageController.text,
                                  countryCode: _selectedCountryCode != null
                                      ? _selectedCountryCode!.dialCode
                                          .replaceAll('+', '')
                                      : '',
                                ),
                              ),
                            );
                      } else {
                        String message = '';
                        if (widget.waConnectionStatus == false) {
                          message = 'Please select a number to send message';
                        } else if (widget.excelFile == null) {
                          message = 'Please pick an excel file';
                        } else if (_selectedCountryCode == null) {
                          message = "Please select country code";
                        }
                        showSnackBarError(context: context, message: message);
                      }
                    },
                    icon: Icon(
                      Icons.send,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}

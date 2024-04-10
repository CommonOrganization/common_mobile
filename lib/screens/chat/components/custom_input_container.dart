import 'package:common/services/chat_service.dart';
import 'package:common/services/group_chat_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import '../../../constants/constants_colors.dart';
import '../../../services/personal_chat_service.dart';
import '../../../services/upload_service.dart';
import 'package:permission_handler/permission_handler.dart';

class CustomInputContainer extends StatefulWidget {
  final String chatId;
  final String userId;
  const CustomInputContainer({
    super.key,
    required this.chatId,
    required this.userId,
  });

  @override
  State<CustomInputContainer> createState() => _CustomInputContainerState();
}

class _CustomInputContainerState extends State<CustomInputContainer> {
  final ImagePicker _picker = ImagePicker();
  late ChatService _chatService;
  final TextEditingController _textEditingController = TextEditingController();

  void sendText() {
    String text = _textEditingController.text;
    _textEditingController.clear();
    if (text.isEmpty) return;
    _chatService.sendText(
        chatId: widget.chatId, userId: widget.userId, text: text);
  }

  void sendImage() async {
    await [Permission.photos,Permission.camera].request();
    List<XFile> imageList = await _picker.pickMultiImage();
    if (imageList.isEmpty) return;
    List<String> imageUrlList =
        await UploadService.uploadImageList(imageList: imageList);
    _chatService.sendImage(
        chatId: widget.chatId, userId: widget.userId, images: imageUrlList);
  }

  @override
  void initState() {
    super.initState();
    if (widget.chatId.startsWith('personal')) {
      _chatService = PersonalChatService();
    } else {
      _chatService = GroupChatService();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: kWhiteColor,
      child: SafeArea(
        child: Container(
          alignment: Alignment.center,
          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          padding: const EdgeInsets.only(left: 20),
          decoration: BoxDecoration(
            border: Border.all(color: kDarkGray20Color),
            color: kDarkGray10Color,
            borderRadius: BorderRadius.circular(15),
          ),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _textEditingController,
                  style: TextStyle(
                    fontSize: 13,
                    color: kFontGray800Color,
                    height: 18 / 13,
                    letterSpacing: -0.5,
                  ),
                  maxLines: null,
                  decoration: const InputDecoration(
                    constraints: BoxConstraints(
                      minHeight: 42,
                      maxHeight: 100,
                    ),
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    counterText: '',
                  ),
                  onChanged: (text) => setState(() {}),
                ),
              ),
              const SizedBox(width: 16),
              GestureDetector(
                onTap: () => sendImage(),
                behavior: HitTestBehavior.opaque,
                child: SvgPicture.asset(
                  'assets/icons/svg/camera_28px.svg',
                ),
              ),
              const SizedBox(width: 16),
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () => sendText(),
                child: Container(
                  padding: const EdgeInsets.all(6),
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: _textEditingController.text.isNotEmpty
                        ? kMainColor
                        : kFontGray200Color,
                  ),
                  child: SizedBox(
                    width: 24,
                    height: 24,
                    child: SvgPicture.asset(
                      'assets/icons/svg/send_chat_24px.svg',
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 6),
            ],
          ),
        ),
      ),
    );
  }
}

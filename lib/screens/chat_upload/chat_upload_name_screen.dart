import 'package:common/controllers/user_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../constants/constants_colors.dart';
import '../../services/user_service.dart';

class ChatUploadNameScreen extends StatefulWidget {
  final List userIdList;
  final Function onPressed;
  const ChatUploadNameScreen({
    Key? key,
    required this.onPressed,
    required this.userIdList,
  }) : super(key: key);

  @override
  State<ChatUploadNameScreen> createState() => _ChatUploadNameScreenState();
}

class _ChatUploadNameScreenState extends State<ChatUploadNameScreen> {
  final TextEditingController _nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kWhiteColor,
      body: Consumer<UserController>(builder: (context, controller, child) {
        if (controller.user == null) return Container();
        String userId = controller.user!.id;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              width: double.infinity,
              height: 20,
            ),
            FutureBuilder(
              future: UserService.get(
                id: widget.userIdList.where((id) => id != userId).last,
                field: 'profileImage',
              ),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  String image = snapshot.data as String;
                  if (widget.userIdList.length > 2) {
                    return SizedBox(
                      width: 100,
                      height: 66,
                      child: Stack(
                        children: [
                          Positioned(
                            left: 0,
                            child: Container(
                              width: 66,
                              height: 66,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(42),
                                color: kDarkGray20Color,
                                image: DecorationImage(
                                  image: NetworkImage(image),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            right: 0,
                            child: Container(
                              alignment: Alignment.center,
                              width: 66,
                              height: 66,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(42),
                                  color: kMainColor,
                                  boxShadow: [
                                    BoxShadow(
                                      color: kBlackColor.withOpacity(0.08),
                                      offset: const Offset(0, 2),
                                      blurRadius: 5,
                                    )
                                  ]),
                              child: Text(
                                '+${widget.userIdList.length - 2}',
                                style: TextStyle(
                                  fontSize: 15,
                                  color: kWhiteColor,
                                  fontWeight: FontWeight.bold,
                                  height: 20 / 15,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                  return Container(
                    width: 66,
                    height: 66,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(42),
                      color: kDarkGray20Color,
                      image: DecorationImage(
                        image: NetworkImage(image),
                        fit: BoxFit.cover,
                      ),
                    ),
                  );
                }
                return Container(
                  width: 66,
                  height: 66,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(42),
                    color: kDarkGray20Color,
                  ),
                );
              },
            ),
            const SizedBox(height: 16),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: kFontGray100Color,
                  ),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _nameController,
                      maxLines: 1,
                      maxLength: 20,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        isDense: true,
                        counterText: '',
                        hintText: '그룹채팅방 이름',
                        hintStyle: TextStyle(
                          fontSize: 14,
                          color: kFontGray400Color,
                          height: 20 / 14,
                        ),
                      ),
                      onChanged: (text) => setState(() {}),
                      style: TextStyle(
                        fontSize: 14,
                        color: kFontGray800Color,
                        height: 20 / 14,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    '${_nameController.text.length}/20',
                    style: TextStyle(
                      fontSize: 12,
                      color: kFontGray400Color,
                      height: 16 / 12,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Text(
                '채팅시작 전, 내가 설정한 그룹채팅방의 이름은 다른 모든 대화상대에게도 동일하게 보입니다.',
                style: TextStyle(
                  fontSize: 12,
                  color: kFontGray400Color,
                  letterSpacing: -0.5,
                  height: 16 / 12,
                ),
              ),
            ),
            const Spacer(),
            GestureDetector(
              onTap: () {
                if (_nameController.text.isEmpty) return;
                widget.onPressed(_nameController.text);
              },
              child: Container(
                margin: EdgeInsets.only(
                  left: 20,
                  right: 20,
                  bottom: MediaQuery.of(context).padding.bottom + 20,
                ),
                child: Container(
                  alignment: Alignment.center,
                  width: double.infinity,
                  height: 54,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(27),
                    color: _nameController.text.isNotEmpty
                        ? kMainColor
                        : kFontGray100Color,
                  ),
                  child: Text(
                    '확인',
                    style: TextStyle(
                      fontSize: 16,
                      color: _nameController.text.isNotEmpty
                          ? kWhiteColor
                          : kFontGray200Color,
                      fontWeight: FontWeight.bold,
                      height: 20 / 16,
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      }),
    );
  }
}

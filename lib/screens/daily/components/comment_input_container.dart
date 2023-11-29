import 'package:common/controllers/user_controller.dart';
import 'package:common/models/reply/reply.dart';
import 'package:common/services/daily_service.dart';
import 'package:common/utils/daily_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import '../../../constants/constants_colors.dart';
import '../../../models/comment/comment.dart';

class CommentInputContainer extends StatefulWidget {
  final String dailyId;
  final String? commentId;

  const CommentInputContainer({
    Key? key,
    required this.dailyId,
    this.commentId,
  }) : super(key: key);

  @override
  State<CommentInputContainer> createState() => _CommentInputContainerState();
}

class _CommentInputContainerState extends State<CommentInputContainer> {
  final TextEditingController _textEditingController = TextEditingController();

  void sendText() {
    String text = _textEditingController.text;
    _textEditingController.clear();
    if (text.isEmpty) return;
    // send()
    if (widget.commentId != null) {
      //대댓글 작성
      String replyId =
          getReplyId(dailyId: widget.dailyId, commentId: widget.commentId!);
      Reply reply = Reply(
        dailyId: widget.dailyId,
        commentId: widget.commentId!,
        id: replyId,
        writerId: context.read<UserController>().user!.id,
        timeStamp: DateTime.now().toString(),
        content: text,
      );

      DailyService.writeReply(reply: reply);
      return;
    }
    //댓글 작성
    String commentId = getCommentId(dailyId: widget.dailyId);
    Comment comment = Comment(
      dailyId: widget.dailyId,
      id: commentId,
      writerId: context.read<UserController>().user!.id,
      timeStamp: DateTime.now().toString(),
      content: text,
    );

    DailyService.writeComment(comment: comment);
    return;
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

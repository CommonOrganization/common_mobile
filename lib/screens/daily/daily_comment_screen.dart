import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:common/controllers/block_controller.dart';
import 'package:common/controllers/user_controller.dart';
import 'package:common/models/comment/comment.dart';
import 'package:common/models/reply/reply.dart';
import 'package:common/services/daily_service.dart';
import 'package:common/widgets/bottom_sheets/comment_reply_report_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import '../../constants/constants_colors.dart';
import '../../services/user_service.dart';
import '../../utils/format_utils.dart';
import '../../widgets/bottom_sheets/comment_reply_edit_bottom_sheet.dart';
import 'components/comment_input_container.dart';

class DailyCommentScreen extends StatefulWidget {
  final String dailyId;

  const DailyCommentScreen({super.key, required this.dailyId});

  @override
  State<DailyCommentScreen> createState() => _DailyCommentScreenState();
}

class _DailyCommentScreenState extends State<DailyCommentScreen> {
  String? _selectedCommentId;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child:
          Consumer<BlockController>(builder: (context, blockController, child) {
        List blockedObjectList = blockController.blockedObjectList;
        return Scaffold(
          backgroundColor: kWhiteColor,
          appBar: AppBar(
            foregroundColor: kFontGray800Color,
            backgroundColor: kWhiteColor,
            leadingWidth: 48,
            leading: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                margin: const EdgeInsets.only(left: 20),
                alignment: Alignment.center,
                child: SvgPicture.asset('assets/icons/svg/arrow_left_28px.svg'),
              ),
            ),
            centerTitle: true,
            titleSpacing: 0,
            title: Text(
              '댓글',
              style: TextStyle(
                fontSize: 18,
                height: 28 / 18,
                letterSpacing: -0.5,
                color: kFontGray800Color,
                fontWeight: FontWeight.bold,
              ),
            ),
            elevation: 0,
          ),
          body: Column(
            children: [
              Expanded(
                child: StreamBuilder(
                  stream: DailyService.getComment(dailyId: widget.dailyId),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      QuerySnapshot<Map<String, dynamic>>? commentSnapshot =
                          snapshot.data;
                      if (commentSnapshot == null ||
                          commentSnapshot.docs.isEmpty) {
                        return noCommentPage();
                      }
                      return ListView(
                        physics: const ClampingScrollPhysics(),
                        children: commentSnapshot.docs
                            .map((QueryDocumentSnapshot document) =>
                                Comment.fromJson(
                                    document.data() as Map<String, dynamic>))
                            .where((comment) =>
                                !blockedObjectList.contains(comment.id))
                            .map((comment) => ListView(
                                  shrinkWrap: true,
                                  physics: const ClampingScrollPhysics(),
                                  children: [
                                    kDailyCommentCard(comment: comment),
                                    StreamBuilder(
                                      stream: DailyService.getReply(
                                          comment: comment),
                                      builder: (context, snapshot) {
                                        if (snapshot.hasData) {
                                          QuerySnapshot<Map<String, dynamic>>?
                                              replySnapshot = snapshot.data;
                                          if (replySnapshot == null ||
                                              replySnapshot.docs.isEmpty) {
                                            return Container();
                                          }
                                          return ListView(
                                            shrinkWrap: true,
                                            physics:
                                                const ClampingScrollPhysics(),
                                            children: replySnapshot.docs
                                                .map((QueryDocumentSnapshot document) =>
                                                    Reply.fromJson(
                                                        document.data() as Map<
                                                            String, dynamic>))
                                                .where((reply) => !blockedObjectList
                                                    .contains(reply.id))
                                                .map((reply) =>
                                                    kDailyCommentReplyCard(
                                                        reply: reply))
                                                .toList(),
                                          );
                                        }
                                        return Container();
                                      },
                                    ),
                                  ],
                                ))
                            .toList(),
                      );
                    }
                    return Container();
                  },
                ),
              ),
              if (_selectedCommentId != null)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  decoration: BoxDecoration(
                      border: Border(
                          top: BorderSide(
                    color: kFontGray100Color,
                  ))),
                  child: Row(
                    children: [
                      Text(
                        '대댓글 남기는 중',
                        style: TextStyle(
                          fontSize: 12,
                          color: kFontGray400Color,
                          height: 16 / 12,
                        ),
                      ),
                      const Spacer(),
                      GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () => setState(() => _selectedCommentId = null),
                        child: SvgPicture.asset(
                          'assets/icons/svg/close_16px.svg',
                        ),
                      ),
                    ],
                  ),
                ),
              CommentInputContainer(
                dailyId: widget.dailyId,
                commentId: _selectedCommentId,
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget noCommentPage() {
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          '아직 댓글이 없습니다',
          style: TextStyle(
            fontSize: 20,
            color: kFontGray800Color,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 20),
        Text(
          '댓글을 남겨보세요.',
          style: TextStyle(
            fontSize: 14,
            color: kFontGray600Color,
          ),
        ),
      ],
    );
  }

  Widget kDailyCommentCard({required Comment comment}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FutureBuilder(
              future:
                  UserService.get(id: comment.writerId, field: 'profileImage'),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return CachedNetworkImage(
                    imageUrl: snapshot.data,
                    imageBuilder: (context, imageProvider) => Container(
                      width: 42,
                      height: 42,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(42),
                        color: kDarkGray20Color,
                        image: DecorationImage(
                          image: imageProvider,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    fadeInDuration: Duration.zero,
                    fadeOutDuration: Duration.zero,
                    placeholder: (context, url) => Container(
                      width: 42,
                      height: 42,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(42),
                        color: kDarkGray20Color,
                      ),
                    ),
                  );
                }
                return Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(42),
                      color: kDarkGray20Color,
                    ));
              }),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    FutureBuilder(
                      future:
                          UserService.get(id: comment.writerId, field: 'name'),
                      builder: (context, snapshot) {
                        return Text(
                          snapshot.data ?? '',
                          style: TextStyle(
                            fontSize: 14,
                            color: kFontGray800Color,
                            fontWeight: FontWeight.bold,
                          ),
                        );
                      },
                    ),
                    const SizedBox(width: 6),
                    Text(
                      getTimeToWrite(comment.timeStamp),
                      style: TextStyle(
                        fontSize: 10,
                        color: kFontGray600Color,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  comment.content,
                  style: TextStyle(
                    fontSize: 12,
                    color: kFontGray800Color,
                  ),
                ),
                const SizedBox(height: 6),
                if (_selectedCommentId == comment.id)
                  GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () => setState(() => _selectedCommentId = null),
                    child: Text(
                      '취소',
                      style: TextStyle(
                        fontSize: 12,
                        color: kFontGray400Color,
                      ),
                    ),
                  )
                else
                  GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () =>
                        setState(() => _selectedCommentId = comment.id),
                    child: Text(
                      '대댓글 달기',
                      style: TextStyle(
                        fontSize: 12,
                        color: kFontGray400Color,
                      ),
                    ),
                  )
              ],
            ),
          ),
          const SizedBox(width: 10),
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () {
              showModalBottomSheet(
                context: context,
                backgroundColor: Colors.transparent,
                builder: (context) =>
                    context.read<UserController>().user?.id == comment.writerId
                        ? CommentReplyEditBottomSheet(
                            dailyId: comment.dailyId, commentId: comment.id)
                        : CommentReplyReportBottomSheet(commentId: comment.id),
              );
            },
            child: SvgPicture.asset(
              'assets/icons/svg/more_20px.svg',
            ),
          ),
        ],
      ),
    );
  }

  Widget kDailyCommentReplyCard({required Reply reply}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(width: 42),
          FutureBuilder(
              future:
                  UserService.get(id: reply.writerId, field: 'profileImage'),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return CachedNetworkImage(
                    imageUrl: snapshot.data,
                    imageBuilder: (context, imageProvider) => Container(
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: kDarkGray20Color,
                        image: DecorationImage(
                          image: imageProvider,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    fadeInDuration: Duration.zero,
                    fadeOutDuration: Duration.zero,
                    placeholder: (context, url) => Container(
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: kDarkGray20Color,
                      ),
                    ),
                  );
                }
                return Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: kDarkGray20Color,
                    ));
              }),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    FutureBuilder(
                      future:
                          UserService.get(id: reply.writerId, field: 'name'),
                      builder: (context, snapshot) {
                        return Text(
                          snapshot.data ?? '',
                          style: TextStyle(
                            fontSize: 14,
                            color: kFontGray800Color,
                            fontWeight: FontWeight.bold,
                          ),
                        );
                      },
                    ),
                    const SizedBox(width: 6),
                    Text(
                      getTimeToWrite(reply.timeStamp),
                      style: TextStyle(
                        fontSize: 10,
                        color: kFontGray600Color,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  reply.content,
                  style: TextStyle(
                    fontSize: 12,
                    color: kFontGray800Color,
                  ),
                ),
                const SizedBox(height: 6),
              ],
            ),
          ),
          const SizedBox(width: 10),
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () {
              showModalBottomSheet(
                context: context,
                backgroundColor: Colors.transparent,
                builder: (context) =>
                    context.read<UserController>().user?.id == reply.writerId
                        ? CommentReplyEditBottomSheet(
                            dailyId: reply.dailyId,
                            commentId: reply.commentId,
                            replyId: reply.id,
                          )
                        : CommentReplyReportBottomSheet(
                            commentId: reply.commentId,
                            replyId: reply.id,
                          ),
              );
            },
            child: SvgPicture.asset(
              'assets/icons/svg/more_20px.svg',
            ),
          ),
        ],
      ),
    );
  }
}

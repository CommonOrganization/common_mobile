import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../constants/constants_colors.dart';
import 'components/comment_input_container.dart';

class DailyCommentScreen extends StatefulWidget {
  final String dailyId;
  const DailyCommentScreen({Key? key, required this.dailyId}) : super(key: key);

  @override
  State<DailyCommentScreen> createState() => _DailyCommentScreenState();
}

class _DailyCommentScreenState extends State<DailyCommentScreen> {
  String? _selectedCommentId;

  @override
  Widget build(BuildContext context) {
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
            child: FutureBuilder(
              future: null,
              builder: (context, snapshot) {
                return Container();
              },
            ),
          ),
          CommentInputContainer(
            dailyId: widget.dailyId,
            commentId: _selectedCommentId,
          ),
        ],
      ),
    );
  }
}

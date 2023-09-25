import 'package:common/models/chat/chat.dart';
import 'package:common/services/chat_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../constants/constants_colors.dart';

class ChatAlbumScreen extends StatelessWidget {
  final String chatId;
  final ChatService service;
  const ChatAlbumScreen({
    Key? key,
    required this.chatId,
    required this.service,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kWhiteColor,
      appBar: AppBar(
        backgroundColor: kWhiteColor,
        foregroundColor: kFontGray800Color,
        elevation: 0,
        centerTitle: true,
        leadingWidth: 48,
        leading: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () => Navigator.pop(context),
          child: Container(
            margin: const EdgeInsets.only(left: 20),
            alignment: Alignment.center,
            child: SvgPicture.asset('assets/icons/svg/arrow_left_28px.svg'),
          ),
        ),
        title: Text(
          '앨범',
          style: TextStyle(
            fontSize: 18,
            height: 28 / 18,
            letterSpacing: -0.5,
            color: kFontGray800Color,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: FutureBuilder(
        future: service.getAlbum(chatId: chatId),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<Chat>? album = snapshot.data;
            if (album == null) return Container();
            return ListView(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              physics: const ClampingScrollPhysics(),
              children: album.map((chat) {
                return albumCard(chat);
              }).toList(),
            );
          }
          return Container();
        },
      ),
    );
  }

  Widget albumCard(Chat chat) {
    DateTime chatDate = DateTime.parse(chat.timeStamp);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            '${chatDate.year}.${chatDate.month.toString().padLeft(2, '0')}.${chatDate.day.toString().padLeft(2, '0')} ${chatDate.hour}:${chatDate.minute}',
            style: TextStyle(
              fontSize: 14,
              height: 20 / 14,
              color: kFontGray600Color,
              letterSpacing: -0.5,
            ),
          ),
        ),
        const SizedBox(height: 16),
        GridView.count(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          crossAxisCount: 3,
          mainAxisSpacing: 4,
          crossAxisSpacing: 4,
          children: (chat.message as List)
              .map(
                (image) => Image.network(
                  image,
                  fit: BoxFit.cover,
                ),
              )
              .toList(),
        ),
        const SizedBox(height: 10),
      ],
    );
  }
}

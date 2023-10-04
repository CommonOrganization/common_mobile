import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../constants/constants_colors.dart';
import '../search/search_screen.dart';

class DailyScreen extends StatefulWidget {
  const DailyScreen({Key? key}) : super(key: key);

  @override
  State<DailyScreen> createState() => _DailyScreenState();
}

class _DailyScreenState extends State<DailyScreen> {
  final TextEditingController _searchController = TextEditingController();

  Future<void> searchWord(String word) async {
    try {
      if (word.isEmpty) return;
      print(word);
      setState(() => _searchController.clear());
    } catch (e) {
      log('검색 실패 : $e');
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kWhiteColor,
      appBar: AppBar(
        foregroundColor: kFontGray800Color,
        backgroundColor: kWhiteColor,
        automaticallyImplyLeading: false,
        centerTitle: false,
        titleSpacing: 20,
        title: Text(
          '데일리',
          style: TextStyle(
            fontSize: 22,
            height: 28 / 22,
            color: kFontGray900Color,
            fontWeight: FontWeight.bold,
          ),
        ),
        elevation: 0,
        actions: [
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const SearchScreen(),
              ),
            ),
            child: SvgPicture.asset('assets/icons/svg/search_26px.svg'),
          ),
          const SizedBox(width: 20),
        ],
      ),
      body: ListView(
        children: [],
      ),
    );
  }
}

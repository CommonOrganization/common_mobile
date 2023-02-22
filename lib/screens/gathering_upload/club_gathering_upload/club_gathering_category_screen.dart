import 'package:flutter/material.dart';

import '../../../constants/constants_enum.dart';
import '../components/gathering_category_select_area.dart';
import '../components/gathering_upload_next_button.dart';

class ClubGatheringCategoryScreen extends StatefulWidget {
  final Function nextPressed;
  const ClubGatheringCategoryScreen({Key? key, required this.nextPressed})
      : super(key: key);

  @override
  State<ClubGatheringCategoryScreen> createState() =>
      _ClubGatheringCategoryScreenState();
}

class _ClubGatheringCategoryScreenState
    extends State<ClubGatheringCategoryScreen> {
  bool _showMore = false;
  CommonCategory? _selectedCategory;
  final TextEditingController _detailCategoryController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Column(
        children: [
          Expanded(
            child: GatheringCategorySelectArea(
              title: '원하는 주제로 소모임을 만들어볼까요?',
              controller: _detailCategoryController,
              showMore: _showMore,
              selectedCategory: _selectedCategory,
              onSelect: (CommonCategory category) =>
                  setState(() => _selectedCategory = category),
              showMorePressed: () => setState(() => _showMore = true),
              onChanged: (text) => setState(() {}),
            ),
          ),
          GatheringUploadNextButton(
            value: _selectedCategory != null,
            onTap: () {
              if (_selectedCategory == null) return;
              widget.nextPressed(
                  _selectedCategory, _detailCategoryController.text);
            },
          ),
        ],
      ),
    );
  }
}

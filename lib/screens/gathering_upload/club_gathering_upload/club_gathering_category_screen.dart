import 'package:common/models/club_gathering/club_gathering.dart';
import 'package:flutter/material.dart';

import '../../../constants/constants_enum.dart';
import '../components/gathering_category_select_area.dart';
import '../components/gathering_upload_next_button.dart';

class ClubGatheringCategoryScreen extends StatefulWidget {
  final ClubGathering? gathering;
  final Function nextPressed;
  const ClubGatheringCategoryScreen({Key? key, required this.nextPressed, this.gathering})
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
  void initState() {
    super.initState();
    setGatheringInformation();
  }

  void setGatheringInformation() {
    if (widget.gathering == null) return;
    _selectedCategory =
        CommonCategoryExtenstion.getCategory(widget.gathering!.category);
    _detailCategoryController.text = widget.gathering!.detailCategory;
  }

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
              showMorePressed: () => setState(() => _showMore = !_showMore),
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
            title: '다음',
          ),
        ],
      ),
    );
  }
}

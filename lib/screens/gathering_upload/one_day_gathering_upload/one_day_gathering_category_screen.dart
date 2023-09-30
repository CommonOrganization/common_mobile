import 'package:common/constants/constants_enum.dart';
import 'package:common/screens/gathering_upload/components/gathering_category_select_area.dart';
import 'package:common/screens/gathering_upload/components/gathering_upload_next_button.dart';
import 'package:flutter/material.dart';

import '../../../models/one_day_gathering/one_day_gathering.dart';

class OneDayGatheringCategoryScreen extends StatefulWidget {
  final OneDayGathering? gathering;
  final Function nextPressed;
  const OneDayGatheringCategoryScreen({
    Key? key,
    this.gathering,
    required this.nextPressed,
  }) : super(key: key);

  @override
  State<OneDayGatheringCategoryScreen> createState() =>
      _OneDayGatheringCategoryScreenState();
}

class _OneDayGatheringCategoryScreenState
    extends State<OneDayGatheringCategoryScreen> {
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
              title: '어떤 주제로 하루모임을 만들어볼까요?',
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

import 'package:common/constants/constants_colors.dart';
import 'package:common/screens/gathering_upload/components/gathering_upload_next_button.dart';
import 'package:common/services/firebase_gathering_service.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class OneDayGatheringContentScreen extends StatefulWidget {
  final Function nextPressed;
  const OneDayGatheringContentScreen({
    Key? key,
    required this.nextPressed,
  }) : super(key: key);

  @override
  State<OneDayGatheringContentScreen> createState() =>
      _OneDayGatheringContentScreenState();
}

class _OneDayGatheringContentScreenState
    extends State<OneDayGatheringContentScreen> {
  final ImagePicker _picker = ImagePicker();

  final TextEditingController _gatheringContentController =
      TextEditingController();

  String? _mainImageUrl;
  final List<String> _imageUrlList = [];

  void selectImage(bool isMain) async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image == null) return;
    String? imageUrl =
        await FirebaseGatheringService.uploadGatheringImage(image: image);
    if (imageUrl == null) return;
    if (isMain) {
      setState(() => _mainImageUrl = imageUrl);
      return;
    }
    setState(() => _imageUrlList.add(imageUrl));
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: ()=>FocusScope.of(context).unfocus(),
      child: Column(
        children: [
          Expanded(
            child: ListView(
              children: [
                const SizedBox(height: 12),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    '하루모임을 소개해볼까요?',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: kFontGray900Color,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    '대표사진은 최소 1장 이상 등록해 주세요.',
                    style: TextStyle(
                      fontSize: 13,
                      color: kFontGray500Color,
                    ),
                  ),
                ),
                const SizedBox(height: 36),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(width: 20),
                      if (_mainImageUrl != null)
                        kSelectedImageArea(_mainImageUrl!, true)
                      else
                        kImageSelectButton(true),
                      ..._imageUrlList
                          .map((imageUrl) => kSelectedImageArea(imageUrl, false))
                          .toList(),
                      kImageSelectButton(false),
                    ],
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 18, bottom: 24),
                  width: double.infinity,
                  height: 1,
                  color: kFontGray50Color,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    '설명',
                    style: TextStyle(
                      fontSize: 15,
                      color: kFontGray800Color,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(
                      top: 12, bottom: 6, left: 20, right: 20),
                  padding: const EdgeInsets.all(16),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: kFontGray50Color,
                  ),
                  constraints: const BoxConstraints(minHeight: 150),
                  child: TextField(
                    controller: _gatheringContentController,
                    style: TextStyle(fontSize: 13, color: kFontGray800Color,height: 20/13,),
                    maxLines: null,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      isDense: true,
                      counterText: '',
                      hintText: '어떤 주제로 하루모임을 갖고 싶은지 소개해보세요.(선택)',
                      hintStyle: TextStyle(
                        fontSize: 13,
                        color: kFontGray400Color,
                        height: 20/13,
                      ),
                    ),
                    onChanged: (text) => setState(() {}),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 26),
                  child: Text(
                    '하루모임 상세 내용을 자세히 작성할수록 멤버들의 신청률도 높아져요',
                    style: TextStyle(
                      fontSize: 11,
                      color: kFontGray400Color,
                    ),
                  ),
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
          GatheringUploadNextButton(
            value: _mainImageUrl != null,
            onTap: () {
              if (_mainImageUrl == null) return;
              widget.nextPressed(
                  _gatheringContentController.text, _mainImageUrl, _imageUrlList);
            },
          ),
        ],
      ),
    );
  }

  Widget kSelectedImageArea(String imageUrl, bool isMain) {
    return Padding(
      padding: const EdgeInsets.only(right: 10),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            alignment: Alignment.center,
            width: 78,
            height: 78,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(78),
              image: DecorationImage(
                fit: BoxFit.cover,
                image: NetworkImage(imageUrl),
              ),
            ),
          ),
          const SizedBox(height: 2),
          if (isMain)
            Text(
              'ⓘ 대표',
              style: TextStyle(
                fontSize: 11,
                color: kSubColor3,
              ),
            )
        ],
      ),
    );
  }

  Widget kImageSelectButton(bool isMain) {
    return Padding(
      padding: const EdgeInsets.only(right: 10),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          GestureDetector(
            onTap: () => selectImage(isMain),
            child: Container(
              alignment: Alignment.center,
              width: 78,
              height: 78,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(78),
                color: isMain ? kSubColor1 : kFontGray50Color,
              ),
              child: Icon(
                Icons.add,
                color: isMain ? kMainColor : kFontGray400Color,
                size: 30,
              ),
            ),
          ),
          const SizedBox(height: 2),
          if (isMain)
            Text(
              'ⓘ 대표',
              style: TextStyle(
                fontSize: 11,
                color: kSubColor3,
              ),
            )
        ],
      ),
    );
  }
}

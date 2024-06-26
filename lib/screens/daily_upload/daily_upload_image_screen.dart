import 'package:common/constants/constants_colors.dart';
import 'package:common/services/daily_service.dart';
import 'package:common/utils/local_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import '../../widgets/common_action_button.dart';

class DailyUploadImageScreen extends StatefulWidget {
  final Function nextPressed;
  const DailyUploadImageScreen({super.key, required this.nextPressed});

  @override
  State<DailyUploadImageScreen> createState() => _DailyUploadImageScreenState();
}

class _DailyUploadImageScreenState extends State<DailyUploadImageScreen> {
  final ImagePicker _picker = ImagePicker();

  String? _mainImageUrl;
  final List _imageUrlList = [];

  void selectImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image == null) return;
    String? imageUrl = await DailyService.uploadDailyImage(image: image);
    if (imageUrl == null) return;
    setState(() => _mainImageUrl = imageUrl);
  }

  void selectMultiImage() async {
    final List<XFile> imageList = await _picker.pickMultiImage();
    final List imageUrlList = [];
    if (imageList.isEmpty) return;
    if (!mounted) return;
    if (_imageUrlList.length + imageList.length > 4) {
      showMessage(context, message: '사진은 대표 사진을 포함해서 5장까지 업로드 가능합니다.');
      return;
    }
    for (var image in imageList) {
      String? imageUrl = await DailyService.uploadDailyImage(image: image);
      if (imageUrl == null) return;
      imageUrlList.add(imageUrl);
    }

    setState(() => _imageUrlList.addAll(imageUrlList));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView(
            physics: const ClampingScrollPhysics(),
            children: [
              const SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  '재미있는 순간들을 사진으로 기록해요',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: kFontGray900Color,
                    height: 1,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  '사진은 최소 1장 이상 등록해 주세요.',
                  style: TextStyle(
                    fontSize: 13,
                    color: kFontGray500Color,
                    height: 20 / 13,
                  ),
                ),
              ),
              const SizedBox(height: 36),

              if (_mainImageUrl != null)
                kImageContainer(true, _mainImageUrl!)
              else
                kImageSelectMainContainer(),
              const SizedBox(height: 4),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [1, 2, 3, 4].map((size) {
                  if (size <= _imageUrlList.length) {
                    int index = size - 1;
                    return kImageContainer(false, _imageUrlList[index]);
                  }
                  return kImageSelectSubContainer();
                }).toList(),
              ),
            ],
          ),
        ),
        CommonActionButton(
          value: _mainImageUrl != null,
          onTap: () {
            if (_mainImageUrl == null) return;
            widget.nextPressed(_mainImageUrl, _imageUrlList);
          },
          title: '다음',
        ),
      ],
    );
  }

  Widget kImageContainer(bool isMain, String image) {
    double size = isMain
        ? MediaQuery.of(context).size.width
        : (MediaQuery.of(context).size.width - 12) / 4;
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: isMain ? kSubColor1 : kDarkGray20Color,
        image: DecorationImage(
          image: NetworkImage(image),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget kImageSelectMainContainer() {
    return Builder(builder: (context) {
      double mainImageSize = MediaQuery.of(context).size.width;
      return GestureDetector(
        onTap: () => selectImage(),
        child: Container(
          alignment: Alignment.center,
          width: mainImageSize,
          height: mainImageSize,
          color: kSubColor1,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SvgPicture.asset('assets/icons/svg/add_66px.svg'),
              const SizedBox(height: 20),
              Text(
                'ⓘ 대표',
                style: TextStyle(
                  fontSize: 14,
                  color: kSubColor3,
                  height: 20 / 14,
                ),
              )
            ],
          ),
        ),
      );
    });
  }

  Widget kImageSelectSubContainer() {
    return Builder(builder: (context) {
      double subImageSize = (MediaQuery.of(context).size.width - 12) / 4;
      return GestureDetector(
        onTap: () => selectMultiImage(),
        child: Container(
          width: subImageSize,
          height: subImageSize,
          decoration: BoxDecoration(
            color: kFontGray50Color,
          ),
          child: SvgPicture.asset(
            'assets/icons/svg/add_20px.svg',
            fit: BoxFit.scaleDown,
          ),
        ),
      );
    });
  }
}

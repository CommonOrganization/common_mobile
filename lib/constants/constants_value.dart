import 'package:common/constants/constants_enum.dart';

const String kAdminNumber = '990116';

const String kSENSServiceId = 'ncp:sms:kr:272033445057:common_damoim';
const String kSENSAccessKey = 'zjOM8XgBcfQ2NdUBwEVM';
const String kSENSSecretKey = 'xcCu4cBzvoRbChlXXroyOBDoAtzdTxpLaqW7XVAi';

const String kKakaoRestAPIKey = 'fc0ad4a3411161995e5b2bbe9381c594';

const double kBottomSheetHeight = 350;
const double kScreenDefaultHeight = 700;

const String kOpinionUrl =
    'https://docs.google.com/forms/d/e/1FAIpQLScAwa-eeYkYQuIR87fYVbQpby9Z7F7Ac4ms6JiszWNCNwwucA/viewform?usp=sf_link';
const String kKakaoChannelUrl = 'http://pf.kakao.com/_PuUjG';
const String kKakaoChannelChatUrl = 'http://pf.kakao.com/_PuUjG/chat';

const String kPersonalInformationProcessingPolicyUrl = 'https://comeoncommon.modoo.at/?link=7uksbs7w';
const String kServiceUsePolicyUrl = 'https://comeoncommon.modoo.at/?link=6ry8c7fl';

const List<String> kShortWeekdayList = ['월', '화', '수', '목', '금', '토', '일'];
const List<String> kWeekdayList = [
  '월요일',
  '화요일',
  '수요일',
  '목요일',
  '금요일',
  '토요일',
  '일요일'
];

const String kNaverMapSearchBaseUrl = 'https://map.naver.com/v5/search';

const List<String> kExampleTagList = ['배드민턴', '등산', '서울', '2030'];

const String kOneDayGatheringCategory = 'oneDayGathering';
const String kClubGatheringCategory = 'clubGathering';
const String kDailyCategory = 'daily';
const String kUserCategory = 'user';

const List<CommonCategory> kAllCommonCategoryList = CommonCategory.values;
List<CommonCategory> kEachCommonCategoryList = CommonCategory.values
    .where((category) => category != CommonCategory.all)
    .toList();

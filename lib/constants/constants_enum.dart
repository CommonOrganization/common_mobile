import 'dart:ui';

enum Country {
  ghana,
  gabon,
  guyana,
  gambia,
  guam,
  guadeloupe,
  guatemala,
  grenada,
  greece,
  greenland,
  guinea,
  guineaBissau,
  namibia,
  nauru,
  nigeria,
  southSudan,
  southAfrica,
  theNetherlands,
  nepal,
  norway,
  newCaledonia,
  newZealand,
  niue,
  niger,
  nicaragua,
  republicOfKorea,
  denmark,
  dominicanR,
  dominica,
  germany,
  eastTimor,
  laos,
  liberia,
  latvia,
  russia,
  lebanon,
  lesotho,
  romania,
  luxembourg,
  rwanda,
  libya,
  lithuania,
  liechtenstein,
  madagascar,
  martinique,
  marshallIslands,
  mayotte,
  macao,
  malawi,
  malaysia,
  mali,
  mexico,
  monaco,
  morocco,
  mauritius,
  mauritania,
  mozambique,
  montenegro,
  montserrat,
  maldova,
  maldives,
  malta,
  mongolia,
  unitedStatesOfAmerica,
  myanmar,
  micronesia,
  vanuatu,
  bahrain,
  barbados,
  vatican,
  bahamas,
  bangladesh,
  bermuda,
  benin,
  venezuela,
  vietnam,
  belgium,
  belarus,
  belize,
  bosniaAndHerzegovina,
  botswana,
  bolivia,
  burundi,
  burkinaFaso,
  bhutan,
  macedonia,
  bulgaria,
  brazil,
  brunei,
  samoa,
  saudiArabia,
  sanMarino,
  saintPierreAndMiquelon,
  westernSahara,
  senegal,
  serbia,
  seychelles,
  saintLucia,
  saintHelena,
  somalia,
  solomonIslands,
  sudan,
  suriname,
  sriLanka,
  sweden,
  switzerland,
  spain,
  slovakia,
  slovenia,
  syria,
  sierraLeone,
  sintMaarten,
  singapore,
  unitedArabEmirates,
  aruba,
  armenia,
  argentina,
  americanSamoa,
  iceland,
  haiti,
  ireland,
  azerbaijan,
  afghanistan,
  andorra,
  albania,
  algeria,
  angola,
  antiguaAndBarbuda,
  anguilla,
  eritrea,
  eswatini,
  estonia,
  ecuador,
  ethiopia,
  elSalvador,
  unitedKingdom,
  yemen,
  oman,
  australia,
  austria,
  honduras,
  jordan,
  uganda,
  uruguay,
  uzbekistan,
  ukraine,
  iraq,
  iran,
  israel,
  egypt,
  italy,
  india,
  indonesia,
  japan,
  jamaica,
  zambia,
  equatorialGuinea,
  democraticPeoplesRepublicOfKorea,
  georgia,
  centralAfrica,
  taiwan,
  china,
  djibouti,
  gibraltar,
  zimbabwe,
  chad,
  czech,
  chile,
  cameroon,
  capeVerde,
  kazakstan,
  qatar,
  cambodia,
  canada,
  kenya,
  caymanIslands,
  theComoros,
  costaRica,
  ivoryCoast,
  colombia,
  congo,
  democraticRepublicOfTheCongo,
  cuba,
  kuwait,
  cookIslands,
  croatia,
  kyrgizstan,
  kiribati,
  cyprus,
  tajikistan,
  tanzania,
  thailand,
  turkey,
  togo,
  tokelau,
  tonga,
  turkmenistan,
  tuvalu,
  tunisia,
  trinidadAndTobago,
  panama,
  paraguay,
  pakistan,
  papuaNewGuinea,
  palau,
  stateOfPalestine,
  peru,
  portugal,
  falklangIslands,
  poland,
  puertoRico,
  france,
  fiji,
  finland,
  thePhilippines,
  hungary,
  hongKong,
}

extension CountryMap on Country {
  static Map names = {
    Country.ghana: '가나',
    Country.gabon: '가봉',
    Country.guyana: '가이아나',
    Country.gambia: '감비아',
    Country.guam: '괌',
    Country.guadeloupe: '과들루프',
    Country.guatemala: '과테말라',
    Country.grenada: '그레나다',
    Country.greece: '그리스',
    Country.greenland: '그린란드',
    Country.guinea: '기니',
    Country.guineaBissau: '기니비사우',
    Country.namibia: '나미비아',
    Country.nauru: '나우루',
    Country.nigeria: '나이지리아',
    Country.southSudan: '남수단',
    Country.southAfrica: '남아프리카공화국',
    Country.theNetherlands: '네덜란드',
    Country.nepal: '네팔',
    Country.norway: '노르웨이',
    Country.newCaledonia: '누벨칼레도니',
    Country.newZealand: '뉴질랜드',
    Country.niue: '니우에',
    Country.niger: '니제르',
    Country.nicaragua: '니카라과',
    Country.republicOfKorea: '대한민국',
    Country.denmark: '덴마크',
    Country.dominicanR: '도미니카공화국',
    Country.dominica: '도미니카연방',
    Country.germany: '독일',
    Country.eastTimor: '동티모르',
    Country.laos: '라오스',
    Country.liberia: '라이베리아',
    Country.latvia: '라트비아',
    Country.russia: '러시아',
    Country.lebanon: '레바논',
    Country.lesotho: '레소토',
    Country.romania: '루마니아',
    Country.luxembourg: '룩셈부르크',
    Country.rwanda: '르완다',
    Country.libya: '리비아',
    Country.lithuania: '리투아니아',
    Country.liechtenstein: '리히텐슈타인',
    Country.madagascar: '마다가스카르',
    Country.martinique: '마르티니크',
    Country.marshallIslands: '마셜제도',
    Country.mayotte: '마요트',
    Country.macao: '마카오',
    Country.malawi: '말라위',
    Country.malaysia: '말레이시아',
    Country.mali: '말리',
    Country.mexico: '멕시코',
    Country.monaco: '모나코',
    Country.morocco: '모로코',
    Country.mauritius: '모리셔스',
    Country.mauritania: '모리타니',
    Country.mozambique: '모잠비크',
    Country.montenegro: '몬테네그로',
    Country.montserrat: '몬트세랫',
    Country.maldova: '몰도바',
    Country.maldives: '몰디브',
    Country.malta: '몰타',
    Country.mongolia: '몽골',
    Country.unitedStatesOfAmerica: '미국',
    Country.myanmar: '미얀마',
    Country.micronesia: '미크로네시아연방',
    Country.vanuatu: '바누아투',
    Country.bahrain: '바레인',
    Country.barbados: '바베이도스',
    Country.vatican: '바티칸시국',
    Country.bahamas: '바하마',
    Country.bangladesh: '방글라데시',
    Country.bermuda: '버뮤다',
    Country.benin: '베냉',
    Country.venezuela: '베네수엘라',
    Country.vietnam: '베트남',
    Country.belgium: '벨기에',
    Country.belarus: '벨라루스',
    Country.belize: '벨리즈',
    Country.bosniaAndHerzegovina: '보스니아헤르체고비나',
    Country.botswana: '보츠와나',
    Country.bolivia: '볼리비아',
    Country.burundi: '부룬디',
    Country.burkinaFaso: '부르키나파소',
    Country.bhutan: '부탄',
    Country.macedonia: '북마케도니아',
    Country.bulgaria: '불가리아',
    Country.brazil: '브라질',
    Country.brunei: '브루나이',
    Country.samoa: '사모아',
    Country.saudiArabia: '사우디아라비아',
    Country.sanMarino: '산마리노',
    Country.saintPierreAndMiquelon: '생피에르미클롱',
    Country.westernSahara: '서사하라',
    Country.senegal: '세네갈',
    Country.serbia: '세르비아',
    Country.seychelles: '세이셸',
    Country.saintLucia: '세인트루시아',
    Country.saintHelena: '세인트헬레나',
    Country.somalia: '소말리아',
    Country.solomonIslands: '솔로몬제도',
    Country.sudan: '수단',
    Country.suriname: '수리남',
    Country.sriLanka: '스리랑카',
    Country.sweden: '스웨덴',
    Country.switzerland: '스위스',
    Country.spain: '스페인',
    Country.slovakia: '슬로바키아',
    Country.slovenia: '슬로베니아',
    Country.syria: '시리아',
    Country.sierraLeone: '시에라리온',
    Country.sintMaarten: '신트마르턴',
    Country.singapore: '싱가포르',
    Country.unitedArabEmirates: '아랍에미리트',
    Country.aruba: '아루바',
    Country.armenia: '아르메니아',
    Country.argentina: '아르헨티나',
    Country.americanSamoa: '아메리칸사모아',
    Country.iceland: '아이슬란드',
    Country.haiti: '아이티',
    Country.ireland: '아일랜드',
    Country.azerbaijan: '아제르바이잔',
    Country.afghanistan: '아프가니스탄',
    Country.andorra: '안도라',
    Country.albania: '알바니아',
    Country.algeria: '알제리',
    Country.angola: '앙골라',
    Country.antiguaAndBarbuda: '앤티가바부다',
    Country.anguilla: '앵귈라',
    Country.eritrea: '에리트레아',
    Country.eswatini: '에스와티니',
    Country.estonia: '에스토니아',
    Country.ecuador: '에콰도르',
    Country.ethiopia: '에티오피아',
    Country.elSalvador: '엘살바도르',
    Country.unitedKingdom: '영국',
    Country.yemen: '예멘',
    Country.oman: '오만',
    Country.australia: '오스트레일리아',
    Country.austria: '오스트리아',
    Country.honduras: '온두라스',
    Country.jordan: '요르단',
    Country.uganda: '우간다',
    Country.uruguay: '우루과이',
    Country.uzbekistan: '우즈베키스탄',
    Country.ukraine: '우크라이나',
    Country.iraq: '이라크',
    Country.iran: '이란',
    Country.israel: '이스라엘',
    Country.egypt: '이집트',
    Country.italy: '이탈리아',
    Country.india: '인도',
    Country.indonesia: '인도네시아',
    Country.japan: '일본',
    Country.jamaica: '자메이카',
    Country.zambia: '잠비아',
    Country.equatorialGuinea: '적도기니',
    Country.democraticPeoplesRepublicOfKorea: '북한',
    Country.georgia: '조지아',
    Country.centralAfrica: '중앙아프리카공화국',
    Country.taiwan: '대만',
    Country.china: '중국',
    Country.djibouti: '지부티',
    Country.gibraltar: '지브롤터',
    Country.zimbabwe: '짐바브웨',
    Country.chad: '차드',
    Country.czech: '체코',
    Country.chile: '칠레',
    Country.cameroon: '카메룬',
    Country.capeVerde: '카보베르데',
    Country.kazakstan: '카자흐스탄',
    Country.qatar: '카타르',
    Country.cambodia: '캄보디아',
    Country.canada: '캐나다',
    Country.kenya: '케냐',
    Country.caymanIslands: '케이맨제도',
    Country.theComoros: '코모로',
    Country.costaRica: '코스타리카',
    Country.ivoryCoast: '코트디부아르',
    Country.colombia: '콜롬비아',
    Country.congo: '콩고',
    Country.democraticRepublicOfTheCongo: '콩고민주공화국',
    Country.cuba: '쿠바',
    Country.kuwait: '쿠웨이트',
    Country.cookIslands: '쿡제도',
    Country.croatia: '크로아티아',
    Country.kyrgizstan: '키르기스스탄',
    Country.kiribati: '키리바시',
    Country.cyprus: '키프로스',
    Country.tajikistan: '타지키스탄',
    Country.tanzania: '탄자니아',
    Country.thailand: '태국',
    Country.turkey: '터키',
    Country.togo: '토고',
    Country.tokelau: '토켈라우',
    Country.tonga: '통가',
    Country.turkmenistan: '투르크메니스탄',
    Country.tuvalu: '투발루',
    Country.tunisia: '튀니지',
    Country.trinidadAndTobago: '트리니다드토바고',
    Country.panama: '파나마',
    Country.paraguay: '파라과이',
    Country.pakistan: '파키스탄',
    Country.papuaNewGuinea: '파푸아뉴기니',
    Country.palau: '팔라우',
    Country.stateOfPalestine: '팔레스타인',
    Country.peru: '페루',
    Country.portugal: '포르투갈',
    Country.falklangIslands: '포클랜드제도',
    Country.poland: '폴란드',
    Country.puertoRico: '푸에르토리코',
    Country.france: '프랑스',
    Country.fiji: '피지',
    Country.finland: '핀란드',
    Country.thePhilippines: '필리핀',
    Country.hungary: '헝가리',
    Country.hongKong: '홍콩',
  };
  static Map codes = {
    Country.ghana: 233,
    Country.gabon: 241,
    Country.guyana: 592,
    Country.gambia: 220,
    Country.guam: 1671,
    Country.guadeloupe: 590,
    Country.guatemala: 502,
    Country.grenada: 1473,
    Country.greece: 30,
    Country.greenland: 299,
    Country.guinea: 224,
    Country.guineaBissau: 245,
    Country.namibia: 264,
    Country.nauru: 674,
    Country.nigeria: 234,
    Country.southSudan: 211,
    Country.southAfrica: 27,
    Country.theNetherlands: 31,
    Country.nepal: 977,
    Country.norway: 47,
    Country.newCaledonia: 687,
    Country.newZealand: 64,
    Country.niue: 683,
    Country.niger: 227,
    Country.nicaragua: 505,
    Country.republicOfKorea: 82,
    Country.denmark: 45,
    Country.dominicanR: 1809,
    Country.dominica: 1767,
    Country.germany: 49,
    Country.eastTimor: 670,
    Country.laos: 856,
    Country.liberia: 231,
    Country.latvia: 371,
    Country.russia: 7,
    Country.lebanon: 961,
    Country.lesotho: 266,
    Country.romania: 40,
    Country.luxembourg: 352,
    Country.rwanda: 250,
    Country.libya: 218,
    Country.lithuania: 370,
    Country.liechtenstein: 423,
    Country.madagascar: 261,
    Country.martinique: 596,
    Country.marshallIslands: 692,
    Country.mayotte: 269,
    Country.macao: 853,
    Country.malawi: 265,
    Country.malaysia: 60,
    Country.mali: 223,
    Country.mexico: 52,
    Country.monaco: 377,
    Country.morocco: 212,
    Country.mauritius: 230,
    Country.mauritania: 222,
    Country.mozambique: 258,
    Country.montenegro: 382,
    Country.montserrat: 1664,
    Country.maldova: 373,
    Country.maldives: 960,
    Country.malta: 356,
    Country.mongolia: 976,
    Country.unitedStatesOfAmerica: 1,
    Country.myanmar: 95,
    Country.micronesia: 691,
    Country.vanuatu: 678,
    Country.bahrain: 973,
    Country.barbados: 1246,
    Country.vatican: 379,
    Country.bahamas: 1242,
    Country.bangladesh: 880,
    Country.bermuda: 1441,
    Country.benin: 229,
    Country.venezuela: 58,
    Country.vietnam: 84,
    Country.belgium: 32,
    Country.belarus: 375,
    Country.belize: 501,
    Country.bosniaAndHerzegovina: 387,
    Country.botswana: 267,
    Country.bolivia: 591,
    Country.burundi: 257,
    Country.burkinaFaso: 226,
    Country.bhutan: 975,
    Country.macedonia: 389,
    Country.bulgaria: 359,
    Country.brazil: 55,
    Country.brunei: 673,
    Country.samoa: 685,
    Country.saudiArabia: 966,
    Country.sanMarino: 378,
    Country.saintPierreAndMiquelon: 508,
    Country.westernSahara: 212,
    Country.senegal: 221,
    Country.serbia: 381,
    Country.seychelles: 248,
    Country.saintLucia: 1758,
    Country.saintHelena: 290,
    Country.somalia: 252,
    Country.solomonIslands: 677,
    Country.sudan: 249,
    Country.suriname: 597,
    Country.sriLanka: 94,
    Country.sweden: 46,
    Country.switzerland: 41,
    Country.spain: 34,
    Country.slovakia: 421,
    Country.slovenia: 386,
    Country.syria: 963,
    Country.sierraLeone: 232,
    Country.sintMaarten: 1721,
    Country.singapore: 65,
    Country.unitedArabEmirates: 971,
    Country.aruba: 297,
    Country.armenia: 374,
    Country.argentina: 54,
    Country.americanSamoa: 1684,
    Country.iceland: 354,
    Country.haiti: 509,
    Country.ireland: 353,
    Country.azerbaijan: 994,
    Country.afghanistan: 93,
    Country.andorra: 376,
    Country.albania: 355,
    Country.algeria: 213,
    Country.angola: 244,
    Country.antiguaAndBarbuda: 1268,
    Country.anguilla: 1264,
    Country.eritrea: 291,
    Country.eswatini: 268,
    Country.estonia: 372,
    Country.ecuador: 593,
    Country.ethiopia: 251,
    Country.elSalvador: 503,
    Country.unitedKingdom: 44,
    Country.yemen: 967,
    Country.oman: 968,
    Country.australia: 61,
    Country.austria: 43,
    Country.honduras: 504,
    Country.jordan: 962,
    Country.uganda: 256,
    Country.uruguay: 598,
    Country.uzbekistan: 998,
    Country.ukraine: 380,
    Country.iraq: 964,
    Country.iran: 98,
    Country.israel: 972,
    Country.egypt: 20,
    Country.italy: 39,
    Country.india: 91,
    Country.indonesia: 62,
    Country.japan: 81,
    Country.jamaica: 1876,
    Country.zambia: 260,
    Country.equatorialGuinea: 240,
    Country.democraticPeoplesRepublicOfKorea: 850,
    Country.georgia: 995,
    Country.centralAfrica: 236,
    Country.taiwan: 886,
    Country.china: 86,
    Country.djibouti: 253,
    Country.gibraltar: 350,
    Country.zimbabwe: 263,
    Country.chad: 235,
    Country.czech: 420,
    Country.chile: 56,
    Country.cameroon: 237,
    Country.capeVerde: 238,
    Country.kazakstan: 7,
    Country.qatar: 974,
    Country.cambodia: 855,
    Country.canada: 1,
    Country.kenya: 254,
    Country.caymanIslands: 1345,
    Country.theComoros: 269,
    Country.costaRica: 506,
    Country.ivoryCoast: 225,
    Country.colombia: 57,
    Country.congo: 242,
    Country.democraticRepublicOfTheCongo: 243,
    Country.cuba: 53,
    Country.kuwait: 965,
    Country.cookIslands: 682,
    Country.croatia: 385,
    Country.kyrgizstan: 996,
    Country.kiribati: 686,
    Country.cyprus: 357,
    Country.tajikistan: 992,
    Country.tanzania: 255,
    Country.thailand: 66,
    Country.turkey: 90,
    Country.togo: 228,
    Country.tokelau: 690,
    Country.tonga: 676,
    Country.turkmenistan: 993,
    Country.tuvalu: 688,
    Country.tunisia: 216,
    Country.trinidadAndTobago: 1868,
    Country.panama: 507,
    Country.paraguay: 595,
    Country.pakistan: 92,
    Country.papuaNewGuinea: 675,
    Country.palau: 680,
    Country.stateOfPalestine: 970,
    Country.peru: 51,
    Country.portugal: 351,
    Country.falklangIslands: 500,
    Country.poland: 48,
    Country.puertoRico: 1787,
    Country.france: 33,
    Country.fiji: 679,
    Country.finland: 358,
    Country.thePhilippines: 63,
    Country.hungary: 36,
    Country.hongKong: 852,
  };

  String get name => names[this];
  int get code => codes[this];
}

enum Gender { male, female }

extension GenderMap on Gender {
  static Map names = {
    Gender.male: '남성',
    Gender.female: '여성',
  };

  static Map values = {
    Gender.male: 'male',
    Gender.female: 'female',
  };

  static Map types = {
    'male': Gender.male,
    'female': Gender.female,
  };

  String get name => names[this];
  String get value => values[this];
  String getTypes(String value) => types[value];
}

enum City {
  seoul,
  gyeonggi,
  incheon,
  busan,
  daegu,
  gwangju,
  daejeon,
  ulsan,
  sejong,
  gangwon,
  chungbuk,
  chungnam,
  jeonbuk,
  jeonnam,
  gyeongbuk,
  gyeongnam,
  jeju
}

extension CityMap on City {
  static Map names = {
    City.seoul: '서울',
    City.busan: '부산',
    City.daegu: '대구',
    City.incheon: '인천',
    City.gwangju: '광주',
    City.daejeon: '대전',
    City.ulsan: '울산',
    City.sejong: '세종',
    City.gyeonggi: '경기',
    City.gangwon: '강원',
    City.chungbuk: '충북',
    City.chungnam: '충남',
    City.jeonbuk: '전북',
    City.jeonnam: '전남',
    City.gyeongbuk: '경북',
    City.gyeongnam: '경남',
    City.jeju: '제주',
  };

  static Map counties = {
    City.seoul: [
      '전체',
      '종로구',
      '중구',
      '용산구',
      '성동구',
      '광진구',
      '동대문구',
      '중랑구',
      '성북구',
      '강북구',
      '도봉구',
      '노원구',
      '은평구',
      '서대문구',
      '마포구',
      '양천구',
      '강서구',
      '구로구',
      '금천구',
      '영등포구',
      '동작구',
      '관악구',
      '서초구',
      '강남구',
      '송파구',
      '강동구',
    ],
    City.busan: [
      '전체',
      '중구',
      '서구',
      '동구',
      '영도구',
      '부산진구',
      '동래구',
      '남구',
      '북구',
      '해운대구',
      '사하구',
      '금정구',
      '강서구',
      '연제구',
      '수영구',
      '사상구',
      '기장군',
    ],
    City.daegu: ['전체', '중구', '동구', '서구', '남구', '북구', '수성구', '달서구', '달성군'],
    City.incheon: [
      '전체',
      '중구',
      '동구',
      '미추홀구',
      '연수구',
      '남동구',
      '부평구',
      '계양구',
      '서구',
      '강화군',
      '옹진군'
    ],
    City.gwangju: ['전체', '동구', '서구', '남구', '북구', '광산구'],
    City.daejeon: ['전체', '동구', '중구', '서구', '유성구', '대덕구'],
    City.ulsan: ['전체', '중구', '남구', '동구', '북구', '울주군'],
    City.sejong: [
      '전체',
      '반곡동',
      '소담동',
      '보람동',
      '대평동',
      '가람동',
      '한솔동',
      '나성동',
      '새롬동',
      '다정동',
      '어진동',
      '종촌동',
      '고운동',
      '아름동',
      '도담동',
      '산울동',
      '해밀동',
      '합강동',
      '집현동',
      '세종동',
      '누리동',
      '한별동',
      '다솜동',
      '용호동',
      '조치원읍',
      '연기면',
      '연동면',
      '금남면',
      '장군면',
      '연서면',
      '전의면',
      '전동면',
      '소정면'
    ],
    City.gyeonggi: [
      '전체',
      '수원시',
      '성남시',
      '고양시',
      '용인시',
      '부천시',
      '안산시',
      '안양시',
      '과천시',
      '구리시',
      '남양주시',
      '오산시',
      '시흥시',
      '군포시',
      '의왕시',
      '하남시',
      '장안구',
      '권선구',
      '팔달구',
      '영통구',
      '수정구',
      '중원구',
      '분당구',
      '의정부시',
      '만안구',
      '동안구',
      '광명시',
      '평택시',
      '동두천시',
      '상록구',
      '단원구',
      '덕양구',
      '일산동구',
      '일산서구',
      '처인구',
      '기흥구',
      '수지구',
      '파주시',
      '이천시',
      '안성시',
      '김포시',
      '화성시',
      '광주시',
      '양주시',
      '포천시',
      '여주시',
      '연천군',
      '가평군',
      '양평군',
    ],
    City.gangwon: [
      '전체',
      '춘천시',
      '원주시',
      '강릉시',
      '동해시',
      '태백시',
      '속초시',
      '삼척시',
      '홍천군',
      '횡성군',
      '영월군',
      '평창군',
      '정선군',
      '철원군',
      '화천군',
      '양구군',
      '인제군',
      '고성군',
      '양양군',
    ],
    City.chungbuk: [
      '전체',
      '청주시',
      '상당구',
      '서원구',
      '흥덕구',
      '청원구',
      '충주시',
      '제천시',
      '보은군',
      '옥천군',
      '영동군',
      '증평군',
      '진천군',
      '괴산군',
      '음성군',
      '단양군',
    ],
    City.chungnam: [
      '전체',
      '천안시',
      '동남구',
      '서북구',
      '공주시',
      '보령시',
      '아산시',
      '서산시',
      '논산시',
      '계룡시',
      '당진시',
      '금산군',
      '부여군',
      '서천군',
      '청양군',
      '홍성군',
      '예산군',
      '태안군',
    ],
    City.jeonbuk: [
      '전체',
      '전주시',
      '완산구',
      '덕진구',
      '군산시',
      '익산시',
      '정읍시',
      '남원시',
      '김제시',
      '완주군',
      '진안군',
      '무주군',
      '장수군',
      '임실군',
      '순창군',
      '고창군',
      '부안군',
    ],
    City.jeonnam: [
      '전체',
      '목포시',
      '여수시',
      '순천시',
      '나주시',
      '광양시',
      '담양군',
      '곡성군',
      '구례군',
      '고흥군',
      '보성군',
      '화순군',
      '장흥군',
      '강진군',
      '해남군',
      '영암군',
      '무안군',
      '함평군',
      '영광군',
      '장성군',
      '완도군',
      '진도군',
      '신안군',
    ],
    City.gyeongbuk: [
      '전체',
      '포항시',
      '남구',
      '북구',
      '경주시',
      '김천시',
      '안동시',
      '구미시',
      '영주시',
      '영천시',
      '상주시',
      '문경시',
      '경산시',
      '군위군',
      '의성군',
      '청송군',
      '영양군',
      '영덕군',
      '청도군',
      '고령군',
      '성주군',
      '칠곡군',
      '예천군',
      '봉화군',
      '울진군',
      '울릉군',
    ],
    City.gyeongnam: [
      '전체',
      '창원시',
      '의창구',
      '성산수',
      '마산합포구',
      '마산회원구',
      '진해구',
      '진주시',
      '통영시',
      '사천시',
      '김해시',
      '밀양시',
      '거제시',
      '양산시',
      '의령군',
      '함안군',
      '창녕군',
      '고성군',
      '남해군',
      '하동군',
      '산청군',
      '함양군',
      '거창군',
      '합천군',
    ],
    City.jeju: [
      '전체',
      '제주시',
      '서귀포시',
    ],
  };

  //TODO 추후 읍면동 필요할때 추가 예정
  // static Map dongs = {
  //   City.seoul: {
  //     '종로구': ['전체'],
  //   },
  //   City.busan: {},
  //   City.daegu: {},
  //   City.incheon:{},
  //   City.gwangju: {},
  //   City.daejeon: {},
  //   City.ulsan: {},
  //   City.sejong: {},
  //   City.gyeonggi: {},
  //   City.gangwon: {},
  //   City.chungbuk: {},
  //   City.chungnam: {},
  //   City.jeonbuk:{},
  //   City.jeonnam: {},
  //   City.gyeongbuk: {},
  //   City.gyeongnam: {},
  //   City.jeju: {},
  // };
  String get name => names[this];
  List<String> get county => counties[this];
  //TODO 추후 읍면동 필요할때 추가 예정
}

enum CommonCategory {
  language,
  investment,
  study,
  photo,
  game,
  sports,
  music,
  dance,
  concert,
  movie,
  book,
  social,
  hiking,
  travel,
  making,
  cooking,
  coffee,
  pet,
  volunteer,
  free,
}

extension CommonCategoryMap on CommonCategory {
  static Map names = {
    CommonCategory.language: 'language',
    CommonCategory.investment: 'investment',
    CommonCategory.study: 'study',
    CommonCategory.photo: 'photo',
    CommonCategory.game: 'game',
    CommonCategory.sports: 'sports',
    CommonCategory.music: 'music',
    CommonCategory.dance: 'dance',
    CommonCategory.concert: 'concert',
    CommonCategory.movie: 'movie',
    CommonCategory.book: 'book',
    CommonCategory.social: 'social',
    CommonCategory.hiking: 'hiking',
    CommonCategory.travel: 'travel',
    CommonCategory.making: 'making',
    CommonCategory.cooking: 'cooking',
    CommonCategory.coffee: 'coffee',
    CommonCategory.pet: 'pet',
    CommonCategory.volunteer: 'volunteer',
    CommonCategory.free: 'free',
  };

  static Map categories = {
    'language': CommonCategory.language,
    'investment': CommonCategory.investment,
    'study': CommonCategory.study,
    'photo': CommonCategory.photo,
    'game': CommonCategory.game,
    'sports': CommonCategory.sports,
    'music': CommonCategory.music,
    'dance': CommonCategory.dance,
    'concert': CommonCategory.concert,
    'movie': CommonCategory.movie,
    'book': CommonCategory.book,
    'social': CommonCategory.social,
    'hiking': CommonCategory.hiking,
    'travel': CommonCategory.travel,
    'making': CommonCategory.making,
    'cooking': CommonCategory.cooking,
    'coffee': CommonCategory.coffee,
    'pet': CommonCategory.pet,
    'volunteer': CommonCategory.volunteer,
    'free': CommonCategory.free,
  };

  static Map titles = {
    CommonCategory.language: '외국ㆍ언어',
    CommonCategory.investment: '주식ㆍ재테크',
    CommonCategory.study: '스터디',
    CommonCategory.photo: '사진ㆍ영상',
    CommonCategory.game: '게임ㆍ오락',
    CommonCategory.sports: '운동',
    CommonCategory.music: '음악ㆍ악기',
    CommonCategory.dance: '댄스ㆍ무용',
    CommonCategory.concert: '문화ㆍ공연',
    CommonCategory.movie: '영화ㆍ드라마',
    CommonCategory.book: '책ㆍ글쓰기',
    CommonCategory.social: '사교ㆍ인맥',
    CommonCategory.hiking: '등산',
    CommonCategory.travel: '여행ㆍ캠핑',
    CommonCategory.making: '공예ㆍ만들기',
    CommonCategory.cooking: '요리ㆍ제조',
    CommonCategory.coffee: '맛집ㆍ카페',
    CommonCategory.pet: '반려동물',
    CommonCategory.volunteer: '봉사활동',
    CommonCategory.free: '자유주제',
  };

  static Map images = {
    CommonCategory.language: 'assets/category/language.png',
    CommonCategory.investment: 'assets/category/investment.png',
    CommonCategory.study: 'assets/category/study.png',
    CommonCategory.photo: 'assets/category/photo.png',
    CommonCategory.game: 'assets/category/game.png',
    CommonCategory.sports: 'assets/category/sports.png',
    CommonCategory.music: 'assets/category/music.png',
    CommonCategory.dance: 'assets/category/dance.png',
    CommonCategory.concert: 'assets/category/concert.png',
    CommonCategory.movie: 'assets/category/movie.png',
    CommonCategory.book: 'assets/category/book.png',
    CommonCategory.social: 'assets/category/social.png',
    CommonCategory.hiking: 'assets/category/hiking.png',
    CommonCategory.travel: 'assets/category/travel.png',
    CommonCategory.making: 'assets/category/making.png',
    CommonCategory.cooking: 'assets/category/cooking.png',
    CommonCategory.coffee: 'assets/category/coffee.png',
    CommonCategory.pet: 'assets/category/pet.png',
    CommonCategory.volunteer: 'assets/category/volunteer.png',
    CommonCategory.free: 'assets/category/free.png',
  };

  static Map miniImages = {
    CommonCategory.language: 'assets/mini_category/language.png',
    CommonCategory.investment: 'assets/mini_category/investment.png',
    CommonCategory.study: 'assets/mini_category/study.png',
    CommonCategory.photo: 'assets/mini_category/photo.png',
    CommonCategory.game: 'assets/mini_category/game.png',
    CommonCategory.sports: 'assets/mini_category/sports.png',
    CommonCategory.music: 'assets/mini_category/music.png',
    CommonCategory.dance: 'assets/mini_category/dance.png',
    CommonCategory.concert: 'assets/mini_category/concert.png',
    CommonCategory.movie: 'assets/mini_category/movie.png',
    CommonCategory.book: 'assets/mini_category/book.png',
    CommonCategory.social: 'assets/mini_category/social.png',
    CommonCategory.hiking: 'assets/mini_category/hiking.png',
    CommonCategory.travel: 'assets/mini_category/travel.png',
    CommonCategory.making: 'assets/mini_category/making.png',
    CommonCategory.cooking: 'assets/mini_category/cooking.png',
    CommonCategory.coffee: 'assets/mini_category/coffee.png',
    CommonCategory.pet: 'assets/mini_category/pet.png',
    CommonCategory.volunteer: 'assets/mini_category/volunteer.png',
    CommonCategory.free: 'assets/mini_category/free.png',
  };

  static Map backgroundColors = {
    CommonCategory.language: const Color(0xFFB0E1FF),
    CommonCategory.investment: const Color(0xFFFFC0B2),
    CommonCategory.study: const Color(0xFFFFD0D0),
    CommonCategory.photo: const Color(0xFFFFB8BE),
    CommonCategory.game: const Color(0xFFD5D3D2),
    CommonCategory.sports: const Color(0xFFB3A19D),
    CommonCategory.music: const Color(0xFFFFC2CD),
    CommonCategory.dance: const Color(0xFFFFEADE),
    CommonCategory.concert: const Color(0xFFFFDCB0),
    CommonCategory.movie: const Color(0xFFDBDBD3),
    CommonCategory.book: const Color(0xFFF8E9D8),
    CommonCategory.social: const Color(0xFFCDF1FF),
    CommonCategory.hiking: const Color(0xFFAEE9C8),
    CommonCategory.travel: const Color(0xFFCFD1FA),
    CommonCategory.making: const Color(0xFFFFF1C5),
    CommonCategory.cooking: const Color(0xFFFFD992),
    CommonCategory.coffee: const Color(0xFFCEE7FF),
    CommonCategory.pet: const Color(0xFFE5CBB5),
    CommonCategory.volunteer: const Color(0xFFFFD5D9),
    CommonCategory.free: const Color(0xFFFFF6D9),
  };

  String get name => names[this];
  static CommonCategory getCategory(String text) => categories[text];
  String get title => titles[this];
  String get image => images[this];
  String get miniImage => miniImages[this];
  Color get backgroundColor => backgroundColors[this];
}

enum GatheringType { oneDay, clubOneDay, club }

extension GatheringTypeMap on GatheringType {
  static Map names = {
    GatheringType.oneDay: 'oneDay',
    GatheringType.clubOneDay: 'clubOneDay',
  };

  static Map types = {
    'oneDay': GatheringType.oneDay,
    'clubOneDay': GatheringType.clubOneDay,
  };

  static Map titles = {
    GatheringType.oneDay: '하루모임',
    GatheringType.clubOneDay: '소모임의 하루모임',
  };

  static Map contents = {
    GatheringType.oneDay: '누구나 자유롭게 참여할 수 있는 하루모임을 열어요.',
    GatheringType.clubOneDay: '내가 가입했거나 운영하는 소모임의 하루모임을 열어요.',
  };

  static Map unselectedIcons = {
    GatheringType.oneDay: 'assets/icons/svg/earth_inactive_22px.svg',
    GatheringType.clubOneDay: 'assets/icons/svg/group_inactive_22px.svg',
  };

  static Map selectedIcons = {
    GatheringType.oneDay: 'assets/icons/svg/earth_active_22px.svg',
    GatheringType.clubOneDay: 'assets/icons/svg/group_active_22px.svg',
  };

  String get name => names[this];
  GatheringType getType(String text) => types[text];
  String get title => titles[this];
  String get content => contents[this];
  String get unselectedIcon => unselectedIcons[this];
  String get selectedIcon => selectedIcons[this];
}

enum RecruitWay { firstCome, approval }

extension RecruitWayMap on RecruitWay {
  static Map names = {
    RecruitWay.firstCome: 'firstCome',
    RecruitWay.approval: 'approval',
  };

  static Map recruitWays = {
    'firstCome': RecruitWay.firstCome,
    'approval': RecruitWay.approval,
  };

  static Map titles = {
    RecruitWay.firstCome: '선착순',
    RecruitWay.approval: '승인제',
  };

  static Map contents = {
    RecruitWay.firstCome: '멤버들의 신청과 동시에 참여가 완료돼요.\n누구나 참여할 수 있어서 신청률이 높아요.',
    RecruitWay.approval:
        '호스트가 직접 멤버를 수락하거나 거절 할 수 있어요.\n질문을 통해 취향이 통하는 사람들과 만날 수 있어요.',
  };

  static Map unselectedIcons = {
    RecruitWay.firstCome: 'assets/icons/svg/clock_inactive_22px.svg',
    RecruitWay.approval: 'assets/icons/svg/inbox_inactive_22px.svg',
  };

  static Map selectedIcons = {
    RecruitWay.firstCome: 'assets/icons/svg/clock_active_22px.svg',
    RecruitWay.approval: 'assets/icons/svg/inbox_active_22px.svg',
  };

  String get name => names[this];
  RecruitWay getRecruitWay(String text) => recruitWays[text];
  String get title => titles[this];
  String get content => contents[this];
  String get selectedIcon => selectedIcons[this];
  String get unselectedIcon => unselectedIcons[this];
}
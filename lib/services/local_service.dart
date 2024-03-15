import 'dart:convert';
import 'dart:developer';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user/user.dart';

class LocalService {
  static final LocalService _instance = LocalService();
  factory LocalService() => _instance;

  static SharedPreferences? _sharedPreferences;

  static const String _userInfoKey = 'userInfo';
  static const String _userPhoneKey = 'userPhone';
  static const String _searchWorkKey = 'searchWord';
  static const String _blockObjectListKey = 'blockObjectList';

  static Future<void> _setSharedPreferences() async {
    _sharedPreferences = await SharedPreferences.getInstance();
  }

  static Future<void> clearSharedPreferences() async {
    if (_sharedPreferences == null) return;
    await _sharedPreferences!.clear();
  }

  static Future<void> logoutClearUserData() async {
    if (_sharedPreferences == null) return;
    await _sharedPreferences!.remove(_userInfoKey);
  }

  static Future<bool> saveUserData(User user) async {
    try {
      if (_sharedPreferences == null) {
        await _setSharedPreferences();
      }

      Map<String, dynamic> userDataMap = user.toJson();
      DateTime nowDate = DateTime.now();
      userDataMap['date'] = nowDate.toString();

      String userJsonString = jsonEncode(userDataMap);

      await _sharedPreferences?.setString(_userInfoKey, userJsonString);
      return true;
    } catch (e) {
      log('LocalController - saveUserData Failed : $e');
      return false;
    }
  }

  static Future<User?> getUserInfo() async {
    try {
      if (_sharedPreferences == null) {
        await _setSharedPreferences();
      }
      String? jsonString = _sharedPreferences?.getString(_userInfoKey);
      if (jsonString == null) return null;

      Map<String, dynamic> userInfo = jsonDecode(jsonString);
      String dateString = userInfo['date'];
      DateTime date = DateTime.parse(dateString);
      DateTime nowDate = DateTime.now();

      int dayDifference = nowDate.difference(date).inDays;

      if (dayDifference > 7) return null;

      return User.fromJson(userInfo);
    } catch (e) {
      log('LocalController - getUserInfo Failed : $e');
      return null;
    }
  }

  static Future<bool> saveUserPhone(String userPhone) async {
    try {
      if (_sharedPreferences == null) {
        await _setSharedPreferences();
      }
      await _sharedPreferences?.setString(_userPhoneKey, userPhone);
      return true;
    } catch (e) {
      log('LocalController - saveUserPhone Failed : $e');
      return false;
    }
  }

  static Future<String?> getUserPhone() async {
    try {
      if (_sharedPreferences == null) {
        await _setSharedPreferences();
      }
      String? userPhone = _sharedPreferences?.getString(_userPhoneKey);
      return userPhone;
    } catch (e) {
      log('LocalController - getUserPhone Failed : $e');
      return null;
    }
  }

  static Future<bool> addSearchWord(String text) async {
    try {
      if (_sharedPreferences == null) {
        await _setSharedPreferences();
      }
      List<String> searchWordList = await getSearchWord();
      if (searchWordList.contains(text)) {
        searchWordList.remove(text);
      }
      await _sharedPreferences
          ?.setStringList(_searchWorkKey, [text, ...searchWordList]);
      return true;
    } catch (e) {
      log('LocalController - addSearchWord Failed : $e');
      return false;
    }
  }

  static Future<bool> removeSearchWord(int index) async {
    try {
      if (_sharedPreferences == null) {
        await _setSharedPreferences();
      }

      List<String> searchWordList = await getSearchWord();
      searchWordList.removeAt(index);

      await _sharedPreferences?.setStringList(_searchWorkKey, searchWordList);
      return true;
    } catch (e) {
      log('LocalController - removeSearchWord Failed : $e');
      return false;
    }
  }

  static Future<bool> clearSearchWord() async {
    try {
      if (_sharedPreferences == null) {
        await _setSharedPreferences();
      }

      await _sharedPreferences?.remove(_searchWorkKey);
      return true;
    } catch (e) {
      log('LocalController - clearSearchWord Failed : $e');
      return false;
    }
  }

  static Future<List<String>> getSearchWord() async {
    try {
      if (_sharedPreferences == null) {
        await _setSharedPreferences();
      }
      List<String> searchWordList =
          _sharedPreferences?.getStringList(_searchWorkKey) ?? [];
      int listSize = searchWordList.length > 10 ? 10 : searchWordList.length;
      return searchWordList.sublist(0, listSize);
    } catch (e) {
      log('LocalController - getSearchWord Failed : $e');
      return [];
    }
  }

  /* 차단 유저 관련 */
  static Future<bool> blockNewObject(String id) async {
    try {
      if (_sharedPreferences == null) {
        await _setSharedPreferences();
      }
      List<String> blockObjectList = await getBlockObjectList();
      if (blockObjectList.contains(id)) {
        return true;
      }
      blockObjectList.add(id);
      await _sharedPreferences?.setStringList(_blockObjectListKey, blockObjectList);
      return true;
    } catch (e) {
      log('LocalController - blockNewObject Failed : $e');
      return false;
    }
  }

  static Future<bool> removeBlockedObject(String id) async {
    try {
      if (_sharedPreferences == null) {
        await _setSharedPreferences();
      }

      List<String> blockObjectList = await getBlockObjectList();
      blockObjectList.remove(id);
      await _sharedPreferences?.setStringList(_blockObjectListKey, blockObjectList);
      return true;
    } catch (e) {
      log('LocalController - removeSearchWord Failed : $e');
      return false;
    }
  }

  static Future<List<String>> getBlockObjectList() async {
    try {
      if (_sharedPreferences == null) {
        await _setSharedPreferences();
      }
      List<String> blockObjectList =
          _sharedPreferences?.getStringList(_blockObjectListKey) ?? [];

      return blockObjectList;
    } catch (e) {
      log('LocalController - getBlockObject Failed : $e');
      return [];
    }
  }
}

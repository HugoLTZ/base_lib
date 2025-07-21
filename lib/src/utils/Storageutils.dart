import 'package:shared_preferences/shared_preferences.dart';

/// 基于SharedPreferences封装的本地存储工具类
class StorageUtils {
  /// 获取指定键对应的字符串值
  ///
  /// ### 参数:
  /// - `key` : 要检索的键名（不可为null或空字符串）
  static Future<dynamic> get(String key) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(key);
  }

  /// 将字符串值存储到指定键
  ///
  /// ### 参数:
  /// - `key` : 要设置的键名（不可为null或空字符串）
  /// - `value` : 要存储的字符串值（不可为null）
  static Future<void> put(String key, String value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, value);
  }

  /// 删除指定键的存储项
  ///
  /// ### 参数:
  /// - `key` : 要删除的键名（不可为null或空字符串）
  static Future<void> delete(String key) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(key);
  }
}

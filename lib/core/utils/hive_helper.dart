import 'package:hive/hive.dart';

/// Utility class để quản lý Hive box trong ứng dụng
class HiveHelper {
  static const String taskBox = 'tasks';
  static const String scheduleBox = 'schedule_items';
  static const String mealPlanBox = 'meal_plans';
  static const String diaryBox = 'diary_entries';
  static const String moodBox = 'mood_records';

  /// Mở box theo tên, trả về box đã mở nếu đã tồn tại
  static Future<Box<T>> openBox<T>(String boxName) async {
    if (Hive.isBoxOpen(boxName)) {
      return Hive.box<T>(boxName);
    }
    return await Hive.openBox<T>(boxName);
  }

  /// Đóng một box cụ thể
  static Future<void> closeBox(String boxName) async {
    if (Hive.isBoxOpen(boxName)) {
      await Hive.box(boxName).close();
    }
  }

  /// Đóng tất cả box đang mở
  static Future<void> closeAllBoxes() async {
    await Hive.close();
  }
}

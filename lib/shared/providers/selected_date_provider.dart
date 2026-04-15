import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Provider quản lý ngày đang được chọn xuyên suốt app.
/// Khởi tạo với ngày hiện tại (chỉ lấy phần date, bỏ time).
final selectedDateProvider = StateProvider<DateTime>((ref) {
  final now = DateTime.now();
  return DateTime(now.year, now.month, now.day);
});

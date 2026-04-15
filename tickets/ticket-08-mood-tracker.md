# Ticket 08 — Feature: Mood Tracker

## Mô tả
Xây dựng hệ thống theo dõi cảm xúc hàng ngày với biểu tượng emoji và thống kê theo tuần.

## Công việc
- [ ] Tạo `features/mood_tracker/providers/mood_provider.dart` — quản lý mood records
- [ ] Tạo `features/mood_tracker/screens/mood_screen.dart` — màn hình chính mood tracker
- [ ] Tạo `features/mood_tracker/widgets/mood_selector.dart` — widget chọn mood (😊 😢 😡 😴 🥰)
- [ ] Tạo `features/mood_tracker/widgets/mood_calendar.dart` — lịch hiển thị mood mỗi ngày trong tháng
- [ ] Tạo `features/mood_tracker/widgets/mood_weekly_chart.dart` — biểu đồ mood theo tuần
- [ ] Cho phép thêm ghi chú ngắn kèm mood
- [ ] Hiển thị mood hôm nay nổi bật

## Tiêu chí hoàn thành
- Chọn và lưu mood mỗi ngày
- Xem lại mood trên calendar và biểu đồ tuần
- Dữ liệu persist với Hive

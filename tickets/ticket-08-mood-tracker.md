# Ticket 08 — Feature: Mood Tracker

## Mô tả
Xây dựng hệ thống theo dõi cảm xúc hàng ngày với biểu tượng emoji và thống kê theo tuần.

## Công việc
- [x] Tạo `features/mood_tracker/providers/mood_provider.dart` — quản lý mood records
- [x] Tạo `features/mood_tracker/screens/mood_screen.dart` — màn hình chính mood tracker
- [x] Tạo `features/mood_tracker/widgets/mood_selector.dart` — widget chọn mood (😊 😢 😡 😴 🥰)
- [x] Tạo `features/mood_tracker/widgets/mood_calendar.dart` — lịch hiển thị mood mỗi ngày trong tháng
- [x] Tạo `features/mood_tracker/widgets/mood_weekly_chart.dart` — biểu đồ mood theo tuần
- [x] Cho phép thêm ghi chú ngắn kèm mood
- [x] Hiển thị mood hôm nay nổi bật

## Ghi chú
- Mood được lưu vào Hive theo ngày, tất cả records được load khi mở màn hình → mood ngày trước vẫn được giữ lại và hiển thị trên calendar/biểu đồ tuần
- MoodSelector chỉ cho phép lưu mood cho ngày hôm nay (by design)
- Khung xám bên dưới mood selector là MoodWeeklyChart — hiển thị bar xám nhạt cho những ngày chưa có mood data, đây là behavior bình thường

## Tiêu chí hoàn thành
- Chọn và lưu mood mỗi ngày
- Xem lại mood trên calendar và biểu đồ tuần
- Dữ liệu persist với Hive

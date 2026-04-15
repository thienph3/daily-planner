# Ticket 03 — Thiết lập Local Storage với Hive

## Mô tả
Cấu hình Hive cho lưu trữ dữ liệu offline, tạo các model cơ bản và adapter.

## Công việc
- [ ] Khởi tạo Hive trong `main.dart`
- [ ] Tạo model `Task` (id, title, description, isCompleted, date, priority, category)
- [ ] Tạo model `ScheduleItem` (id, title, startTime, endTime, date, color)
- [ ] Tạo model `MealPlan` (id, date, breakfast, lunch, dinner, snacks)
- [ ] Tạo model `DiaryEntry` (id, date, content, mood)
- [ ] Tạo model `MoodRecord` (id, date, mood, note)
- [ ] Tạo Hive TypeAdapter cho mỗi model
- [ ] Tạo `core/utils/hive_helper.dart` — helper mở/đóng box

## Tiêu chí hoàn thành
- Tất cả model serialize/deserialize đúng với Hive
- Dữ liệu persist sau khi đóng app

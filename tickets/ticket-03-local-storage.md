# Ticket 03 — Thiết lập Local Storage với Hive

## Mô tả
Cấu hình Hive cho lưu trữ dữ liệu offline, tạo các model cơ bản và adapter.

## Công việc
- [x] Khởi tạo Hive trong `main.dart`
- [x] Tạo model `Task` (id, title, description, isCompleted, date, priority, category) — typeId: 0
- [x] Tạo model `ScheduleItem` (id, title, startTime, endTime, date, color) — typeId: 1
- [x] Tạo model `MealPlan` (id, date, mealType, content) — typeId: 2
- [x] Tạo model `DiaryEntry` (id, date, content, mood) — typeId: 3
- [x] Tạo model `MoodRecord` (id, date, mood, note) — typeId: 4
- [x] Tạo model `Category` (id, name, emoji) — typeId: 5
- [x] Tạo model `BookCategory` (id, name, emoji) — typeId: 6
- [x] Tạo model `Book` (id, title, categoryId, isRead) — typeId: 7
- [x] Tạo model `Belonging` (id, name, status, location) — typeId: 8
- [x] Tạo enum `BelongingStatus` — typeId: 9
- [x] Tạo Hive TypeAdapter cho mỗi model
- [x] Tạo `core/utils/hive_helper.dart` — helper mở/đóng box
- [x] Đăng ký tất cả adapters trong `main.dart`

## Tiêu chí hoàn thành
- Tất cả model serialize/deserialize đúng với Hive
- Dữ liệu persist sau khi đóng app

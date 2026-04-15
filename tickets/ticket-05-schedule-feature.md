# Ticket 05 — Feature: Thời gian biểu theo giờ

## Mô tả
Xây dựng tính năng lên lịch hoạt động theo từng khung giờ trong ngày.

## Công việc
- [ ] Tạo `features/schedule/providers/schedule_provider.dart` — quản lý danh sách schedule items
- [ ] Tạo `features/schedule/screens/schedule_screen.dart` — hiển thị timeline theo giờ (6:00 - 23:00)
- [ ] Tạo `features/schedule/widgets/time_slot_card.dart` — card cho mỗi khung giờ
- [ ] Tạo `features/schedule/widgets/add_schedule_dialog.dart` — dialog thêm/sửa hoạt động
- [ ] Hiển thị timeline dọc với các slot giờ
- [ ] Hỗ trợ chọn màu cho mỗi hoạt động (pastel colors)
- [ ] Highlight khung giờ hiện tại
- [ ] Chọn ngày bằng date picker kawaii

## Tiêu chí hoàn thành
- Thêm/sửa/xóa hoạt động theo giờ
- Timeline hiển thị trực quan, dễ đọc
- Dữ liệu persist với Hive

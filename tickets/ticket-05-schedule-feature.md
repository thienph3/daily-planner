# Ticket 05 — Feature: Thời gian biểu theo giờ

## Mô tả
Xây dựng tính năng lên lịch hoạt động theo từng khung giờ trong ngày.

## Công việc
- [x] Tạo `features/schedule/providers/schedule_provider.dart` — quản lý danh sách schedule items
- [x] Tạo `features/schedule/screens/schedule_screen.dart` — hiển thị timeline theo giờ (**0:00 - 24:00**, mở rộng từ 6-23h)
- [x] Tạo `features/schedule/widgets/time_slot_card.dart` — card cho mỗi khung giờ
- [x] Tạo `features/schedule/widgets/add_schedule_dialog.dart` — dialog thêm/sửa hoạt động
- [x] Hiển thị timeline dọc với các slot giờ
- [x] Hỗ trợ chọn màu cho mỗi hoạt động (pastel colors)
- [x] Highlight khung giờ hiện tại
- [x] Chọn ngày bằng date picker kawaii

## Thay đổi
- Timeline mở rộng từ 0:00 đến 24:00 (trước đó giới hạn 6:00-23:00)

## Tiêu chí hoàn thành
- Thêm/sửa/xóa hoạt động theo giờ
- Timeline hiển thị đầy đủ 24 giờ, trực quan, dễ đọc
- Dữ liệu persist với Hive

# Ticket 07 — Feature: Nhật ký cá nhân

## Mô tả
Xây dựng tính năng ghi chú cảm xúc và tổng kết ngày.

## Công việc
- [ ] Tạo `features/diary/providers/diary_provider.dart` — quản lý diary entries
- [ ] Tạo `features/diary/screens/diary_screen.dart` — hiển thị danh sách nhật ký theo ngày
- [ ] Tạo `features/diary/screens/diary_editor_screen.dart` — màn hình viết/sửa nhật ký
- [ ] Tạo `features/diary/widgets/diary_card.dart` — card preview nhật ký (ngày, mood, đoạn trích)
- [ ] Text editor đơn giản với placeholder gợi ý
- [ ] Gắn mood emoji cho mỗi entry
- [ ] Hiển thị danh sách nhật ký dạng list, sắp xếp theo ngày mới nhất

## Tiêu chí hoàn thành
- Viết, sửa, xóa nhật ký
- Mỗi entry gắn được mood
- Dữ liệu persist với Hive

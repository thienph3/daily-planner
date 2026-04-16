# Ticket 07 — Feature: Nhật ký cá nhân

## Mô tả
Xây dựng tính năng ghi chú cảm xúc và tổng kết ngày.

## Công việc
- [x] Tạo `features/diary/providers/diary_provider.dart` — quản lý diary entries
- [x] Tạo `features/diary/screens/diary_screen.dart` — hiển thị danh sách nhật ký theo ngày
- [x] Tạo `features/diary/screens/diary_editor_screen.dart` — màn hình viết/sửa nhật ký
- [x] Tạo `features/diary/widgets/diary_card.dart` — card preview nhật ký (ngày, mood, đoạn trích)
- [x] Text editor đơn giản với placeholder gợi ý
- [x] Gắn mood emoji cho mỗi entry
- [x] Hiển thị danh sách nhật ký dạng list, sắp xếp theo ngày mới nhất

## Bug fix
- [x] Sửa lỗi FAB "thêm nhật ký" không mở được editor — đổi `context.go` thành `context.push` cho route `/diary/editor` (cả thêm mới và sửa)

## Tiêu chí hoàn thành
- Viết, sửa, xóa nhật ký
- Mỗi entry gắn được mood
- FAB và tap vào card đều mở được editor
- Dữ liệu persist với Hive

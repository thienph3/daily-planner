# Ticket 14 — Feature: Quản lý đồ dùng/vật dụng

## Mô tả
Xây dựng tính năng quản lý đồ dùng cá nhân với trạng thái sử dụng (chưa dùng, đang dùng, đã dùng) và vị trí cất giữ.

## Công việc
- [x] Tạo `features/belongings/models/belonging.dart` — model Belonging (id, name, status, location) + enum BelongingStatus lưu Hive (typeId: 8, 9)
- [x] Tạo `features/belongings/providers/belonging_provider.dart` — CRUD provider
- [x] Tạo `features/belongings/screens/belonging_screen.dart` — màn hình quản lý đồ dùng
- [x] 3 trạng thái: Chưa dùng, Đang dùng, Đã dùng — chuyển đổi nhanh bằng ChoiceChip
- [x] Trường "Đang cất ở đâu?" để ghi vị trí
- [x] Truy cập từ tab Thêm → Đồ dùng
- [x] Route: `/belongings`

## Tiêu chí hoàn thành
- CRUD đồ dùng hoạt động đầy đủ
- Chuyển đổi trạng thái nhanh chóng
- Dữ liệu persist với Hive
- UI đúng kawaii style guide

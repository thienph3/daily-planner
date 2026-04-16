# Ticket 13 — Feature: Quản lý sách

## Mô tả
Xây dựng tính năng quản lý sách cá nhân, bao gồm tên sách, danh mục sách (chọn từ danh sách, không phải free-text), và trạng thái đã đọc/chưa đọc.

## Công việc
- [x] Tạo `features/books/models/book.dart` — model Book (id, title, categoryId, isRead) lưu Hive (typeId: 7)
- [x] Tạo `features/books/models/book_category.dart` — model BookCategory (id, name, emoji) lưu Hive (typeId: 6)
- [x] Tạo `features/books/providers/book_provider.dart` — CRUD provider cho Book và BookCategory
- [x] Tạo `features/books/screens/book_screen.dart` — màn hình quản lý sách
- [x] Danh mục sách quản lý qua bottom sheet trong màn hình sách
- [x] Khi thêm/sửa sách, chọn danh mục từ dropdown (không phải free-text)
- [x] Toggle trạng thái đã đọc/chưa đọc
- [x] Truy cập từ tab Thêm → Sách
- [x] Route: `/books`

## Tiêu chí hoàn thành
- CRUD sách hoạt động đầy đủ
- Danh mục sách quản lý riêng, chọn từ dropdown
- Dữ liệu persist với Hive
- UI đúng kawaii style guide

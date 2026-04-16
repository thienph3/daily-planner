# Ticket 15 — Feature: Ghi chú theo lớp học

## Mô tả
Xây dựng tính năng sổ tay giáo viên — quản lý danh sách lớp học và ghi chú riêng cho từng lớp. Mỗi ghi chú có thể gắn tag: Bài giảng, Học sinh, Nhắc nhở, Khác.

## Công việc
- [x] Tạo `features/classes/models/class_room.dart` — model ClassRoom (id, name, emoji, color) lưu Hive (typeId: 10)
- [x] Tạo `features/classes/models/class_note.dart` — model ClassNote (id, classId, content, date, tag) + enum NoteTag lưu Hive (typeId: 11, 12)
- [x] Tạo `features/classes/providers/class_provider.dart` — CRUD provider cho ClassRoom và ClassNote
- [x] Tạo `features/classes/screens/class_list_screen.dart` — danh sách lớp, hiển thị số ghi chú, CRUD lớp
- [x] Tạo `features/classes/screens/class_notes_screen.dart` — ghi chú của 1 lớp, CRUD ghi chú, filter theo tag
- [x] Xóa lớp sẽ xóa luôn tất cả ghi chú của lớp đó
- [x] Truy cập từ tab Thêm → Lớp học
- [x] Route: `/classes`, `/classes/:classId`

## Tiêu chí hoàn thành
- CRUD lớp học và ghi chú hoạt động đầy đủ
- Ghi chú gắn tag phân loại (Bài giảng / Học sinh / Nhắc nhở / Khác)
- Dữ liệu persist với Hive
- UI đúng kawaii style guide

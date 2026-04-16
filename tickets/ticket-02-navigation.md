# Ticket 02 — Thiết lập Navigation & Bottom Navigation Bar

## Mô tả
Cấu hình GoRouter, tạo bottom navigation bar với các tab chính của app, và layout shell cho các màn hình.

## Công việc
- [x] Tạo `routes/app_router.dart` — định nghĩa routes với GoRouter
- [x] Tạo `shared/widgets/main_shell.dart` — scaffold chung với BottomNavigationBar
- [x] Tạo placeholder screen cho mỗi feature
- [x] Style bottom nav bar theo kawaii theme (icon cute, pastel colors)
- [x] Hỗ trợ page transition animation (fade, slide up)
- [x] Thêm routes cho Settings sub-pages: `/settings/categories`, `/settings/books`, `/settings/belongings`

## Thay đổi — Giảm bottom tab
- Trước: 6 tab (To-Do, Lịch trình, Bữa ăn, Nhật ký, Mood, Tiến độ) — quá nhiều
- Sau: 4 tab (To-Do, Lịch trình, Bữa ăn, Thêm)
- Tab "Thêm" (`/more`) hiển thị grid menu dẫn đến: Nhật ký, Mood, Tiến độ tuần, Sách, Đồ dùng, Cài đặt
- Nhật ký, Mood, Tiến độ, Sách, Đồ dùng chuyển thành standalone routes (push), không còn là shell branches

## Tiêu chí hoàn thành
- Chuyển tab mượt mà giữa 4 màn hình chính
- Tab "Thêm" dẫn đến các tính năng phụ
- Bottom nav bar gọn gàng, không bị chật
- URL-based navigation hoạt động

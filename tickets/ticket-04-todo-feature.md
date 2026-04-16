# Ticket 04 — Feature: To-Do List

## Mô tả
Xây dựng tính năng To-Do List cho phép người dùng tạo, sửa, xóa và đánh dấu hoàn thành công việc hàng ngày. Hỗ trợ carry-over task chưa hoàn thành sang ngày mới.

## Công việc

### CRUD Task
- [x] Tạo `features/todo/providers/todo_provider.dart` — Riverpod provider quản lý danh sách task
- [x] Tạo `features/todo/screens/todo_screen.dart` — màn hình chính hiển thị danh sách task theo ngày
- [x] Tạo `features/todo/widgets/task_card.dart` — card hiển thị 1 task (checkbox kawaii, title, priority badge)
- [x] Tạo `features/todo/widgets/add_task_dialog.dart` — dialog thêm task mới
- [x] Tạo `features/todo/widgets/edit_task_dialog.dart` — dialog sửa task
- [x] Hỗ trợ swipe để xóa task (có confirm dialog)
- [x] Đánh dấu hoàn thành/bỏ hoàn thành task

### Carry-over Task chưa hoàn thành
- [x] Khi mở app vào ngày mới, kiểm tra ngày trước có task chưa hoàn thành không
- [x] Hiển thị dialog thông báo carry-over
- [x] Hiển thị danh sách task chưa xong, cho user chọn từng task muốn carry-over
- [x] Clone các task được chọn sang ngày hôm nay
- [x] Task gốc ở ngày cũ giữ nguyên trạng thái
- [x] Nếu user bỏ qua dialog, không clone gì cả

### UI & UX
- [x] Hiển thị progress bar tổng quan (hoàn thành / tổng)
- [x] Filter theo trạng thái: tất cả, chưa xong, đã xong — **đổi sang popup menu gọn hơn thay vì nhiều filter chips**
- [x] Sắp xếp theo priority
- [x] Animation bounce khi đánh dấu hoàn thành

### Quản lý danh mục (mới)
- [x] Tạo `features/settings/models/category.dart` — model Category lưu Hive
- [x] Tạo `features/settings/providers/category_provider.dart` — CRUD danh mục
- [x] Tạo `features/settings/screens/category_management_screen.dart` — màn hình quản lý danh mục (mở từ Settings)
- [x] Đổi trường danh mục trong AddTaskDialog và EditTaskDialog từ free-text sang dropdown chọn từ danh sách danh mục đã tạo

## Tiêu chí hoàn thành
- Tạo, sửa, xóa task hoạt động đầy đủ
- Carry-over dialog hiển thị đúng khi có task chưa xong từ ngày trước
- Danh mục task được quản lý tập trung, chọn từ dropdown thay vì nhập tay
- Filter gọn gàng dạng popup menu
- Dữ liệu lưu vào Hive, persist sau restart
- UI đúng kawaii style guide

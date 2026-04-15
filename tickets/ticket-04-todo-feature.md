# Ticket 04 — Feature: To-Do List

## Mô tả
Xây dựng tính năng To-Do List cho phép người dùng tạo, sửa, xóa và đánh dấu hoàn thành công việc hàng ngày. Hỗ trợ carry-over task chưa hoàn thành sang ngày mới.

## Công việc

### CRUD Task
- [ ] Tạo `features/todo/providers/todo_provider.dart` — Riverpod provider quản lý danh sách task
- [ ] Tạo `features/todo/screens/todo_screen.dart` — màn hình chính hiển thị danh sách task theo ngày
- [ ] Tạo `features/todo/widgets/task_card.dart` — card hiển thị 1 task (checkbox kawaii, title, priority badge)
- [ ] Tạo `features/todo/widgets/add_task_dialog.dart` — dialog thêm task mới
- [ ] Tạo `features/todo/widgets/edit_task_dialog.dart` — dialog sửa task
- [ ] Hỗ trợ swipe để xóa task (có confirm dialog)
- [ ] Đánh dấu hoàn thành/bỏ hoàn thành task

### Carry-over Task chưa hoàn thành
- [ ] Khi mở app vào ngày mới, kiểm tra ngày trước có task chưa hoàn thành không
- [ ] Hiển thị dialog thông báo: "Bạn có X task chưa hoàn thành từ hôm qua. Bạn muốn chuyển sang hôm nay không?"
- [ ] Hiển thị danh sách task chưa xong, cho user chọn từng task muốn carry-over (checkbox)
- [ ] Khi user xác nhận: clone các task được chọn sang ngày hôm nay (tạo bản copy mới, trạng thái chưa hoàn thành)
- [ ] Task gốc ở ngày cũ giữ nguyên trạng thái (không xóa, không sửa) — đảm bảo lịch sử chính xác
- [ ] Nếu user bỏ qua dialog, không clone gì cả

### UI & UX
- [ ] Hiển thị progress bar tổng quan (hoàn thành / tổng)
- [ ] Filter theo trạng thái: tất cả, chưa xong, đã xong
- [ ] Sắp xếp theo priority
- [ ] Animation bounce khi đánh dấu hoàn thành

## Tiêu chí hoàn thành
- Tạo, sửa, xóa task hoạt động đầy đủ
- Carry-over dialog hiển thị đúng khi có task chưa xong từ ngày trước
- Clone task giữ nguyên thông tin (title, description, priority) nhưng reset trạng thái về chưa hoàn thành
- Task gốc ở ngày cũ không bị thay đổi
- Dữ liệu lưu vào Hive, persist sau restart
- UI đúng kawaii style guide

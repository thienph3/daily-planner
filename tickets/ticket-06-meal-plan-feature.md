# Ticket 06 — Feature: Kế hoạch bữa ăn

## Mô tả
Xây dựng tính năng lập kế hoạch ăn uống theo 3 bữa chính và snack.

## Công việc
- [ ] Tạo `features/meal_plan/providers/meal_plan_provider.dart` — quản lý meal plan theo ngày
- [ ] Tạo `features/meal_plan/screens/meal_plan_screen.dart` — hiển thị 3 bữa + snack
- [ ] Tạo `features/meal_plan/widgets/meal_card.dart` — card cho mỗi bữa ăn (icon bữa sáng/trưa/tối)
- [ ] Tạo `features/meal_plan/widgets/edit_meal_dialog.dart` — dialog nhập/sửa bữa ăn
- [ ] Icon kawaii cho mỗi loại bữa (🍳 sáng, 🍱 trưa, 🍝 tối, 🍪 snack)
- [ ] Chọn ngày để xem/lập kế hoạch

## Tiêu chí hoàn thành
- Nhập và lưu kế hoạch bữa ăn cho mỗi ngày
- Hiển thị đẹp với icon kawaii
- Dữ liệu persist với Hive

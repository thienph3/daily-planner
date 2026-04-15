/// Enum đại diện cho các loại bữa ăn với emoji và label tương ứng.
enum MealType {
  breakfast(emoji: '🍳', label: 'Bữa sáng'),
  lunch(emoji: '🍱', label: 'Bữa trưa'),
  dinner(emoji: '🍝', label: 'Bữa tối'),
  snack(emoji: '🍪', label: 'Snack');

  final String emoji;
  final String label;

  const MealType({required this.emoji, required this.label});
}

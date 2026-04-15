import 'package:flutter/material.dart';

/// Widget wrapper tạo hiệu ứng bounce khi triggered.
/// Trigger khi `animate` chuyển từ false sang true.
class BounceAnimationWidget extends StatefulWidget {
  final Widget child;
  final bool animate;
  final Duration duration;
  final VoidCallback? onComplete;

  const BounceAnimationWidget({
    super.key,
    required this.child,
    this.animate = false,
    this.duration = const Duration(milliseconds: 300),
    this.onComplete,
  });

  @override
  State<BounceAnimationWidget> createState() => _BounceAnimationWidgetState();
}

class _BounceAnimationWidgetState extends State<BounceAnimationWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration);
    _scaleAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.15), weight: 40),
      TweenSequenceItem(tween: Tween(begin: 1.15, end: 0.95), weight: 30),
      TweenSequenceItem(tween: Tween(begin: 0.95, end: 1.0), weight: 30),
    ]).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        widget.onComplete?.call();
      }
    });
  }

  @override
  void didUpdateWidget(BounceAnimationWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.animate && !oldWidget.animate) {
      _controller.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(scale: _scaleAnimation, child: widget.child);
  }
}

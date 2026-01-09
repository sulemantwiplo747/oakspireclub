import 'package:flutter/material.dart';

class StaggeredItemAnimation extends StatefulWidget {
  /// The widget to animate
  final Widget child;

  /// The index determines the delay (higher index = later animation)
  final int index;

  /// Base delay between items (default: 150ms like your original)
  final Duration delayBetweenItems;

  /// Animation duration
  final Duration duration;

  /// Animation curve
  final Curve curve;

  /// Optional: starting offset (default same as yours)
  final Offset beginOffset;

  const StaggeredItemAnimation({
    super.key,
    required this.child,
    required this.index,
    this.delayBetweenItems = const Duration(milliseconds: 150),
    this.duration = const Duration(milliseconds: 800),
    this.curve = Curves.easeOut,
    this.beginOffset = const Offset(0, 0.3),
  });

  @override
  State<StaggeredItemAnimation> createState() => _StaggeredItemAnimationState();
}

class _StaggeredItemAnimationState extends State<StaggeredItemAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fade;
  late Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(vsync: this, duration: widget.duration);

    _fade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: widget.curve),
    );

    _slide = Tween<Offset>(begin: widget.beginOffset, end: Offset.zero).animate(
      CurvedAnimation(parent: _controller, curve: widget.curve),
    );

    // Start with staggered delay based on index
    Future.delayed(widget.delayBetweenItems * widget.index, () {
      if (mounted) {
        _controller.forward();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fade,
      child: SlideTransition(
        position: _slide,
        child: widget.child,
      ),
    );
  }
}
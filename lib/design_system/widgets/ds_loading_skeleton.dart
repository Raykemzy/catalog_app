import 'package:catalog_app/core/theme/app_theme.dart';
import 'package:flutter/material.dart';

class DsLoadingSkeleton extends StatefulWidget {
  const DsLoadingSkeleton({
    super.key,
    required this.height,
    this.width = double.infinity,
    this.radius = AppRadius.sm,
  });

  final double height;
  final double width;
  final double radius;

  @override
  State<DsLoadingSkeleton> createState() => _DsLoadingSkeletonState();
}

class _DsLoadingSkeletonState extends State<DsLoadingSkeleton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
      lowerBound: 0.55,
      upperBound: 1,
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.surfaceContainerHighest;
    return FadeTransition(
      opacity: _controller,
      child: Container(
        height: widget.height,
        width: widget.width,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(widget.radius),
        ),
      ),
    );
  }
}

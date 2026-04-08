import 'package:flutter/material.dart';

class GradientCard extends StatelessWidget {
  final List<Color> gradient;
  final Widget child;
  final double borderRadius;
  final EdgeInsetsGeometry padding;
  final double? width;
  final double? height;
  final AlignmentGeometry begin;
  final AlignmentGeometry end;
  final List<BoxShadow>? boxShadow;

  const GradientCard({
    super.key,
    required this.gradient,
    required this.child,
    this.borderRadius = 20,
    this.padding = const EdgeInsets.all(20),
    this.width,
    this.height,
    this.begin = Alignment.topLeft,
    this.end = Alignment.bottomRight,
    this.boxShadow,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      padding: padding,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        gradient: LinearGradient(colors: gradient, begin: begin, end: end),
        boxShadow:
            boxShadow ??
            [
              BoxShadow(
                color: gradient.first.withValues(alpha: 0.25),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
      ),
      child: child,
    );
  }
}

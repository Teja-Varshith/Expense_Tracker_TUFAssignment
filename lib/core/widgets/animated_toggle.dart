import 'package:flutter/material.dart';

class AnimatedToggle extends StatelessWidget {
  final List<String> labels;
  final int selectedIndex;
  final ValueChanged<int> onChanged;
  final double height;
  final double borderRadius;

  const AnimatedToggle({
    super.key,
    required this.labels,
    required this.selectedIndex,
    required this.onChanged,
    this.height = 44,
    this.borderRadius = 20,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final bgColor = isDark
        ? Colors.white.withValues(alpha: 0.08)
        : Colors.black.withValues(alpha: 0.06);
    final activeColor = isDark ? Colors.white : Colors.black;
    final inactiveTextColor = isDark
        ? Colors.white.withValues(alpha: 0.5)
        : Colors.black.withValues(alpha: 0.5);
    final activeTextColor = isDark ? Colors.black : Colors.white;

    return Container(
      height: height,
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final tabWidth = constraints.maxWidth / labels.length;
          return Stack(
            children: [
              AnimatedPositioned(
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeOutCubic,
                left: selectedIndex * tabWidth + 3,
                top: 3,
                bottom: 3,
                width: tabWidth - 6,
                child: Container(
                  decoration: BoxDecoration(
                    color: activeColor,
                    borderRadius: BorderRadius.circular(borderRadius - 3),
                    boxShadow: [
                      BoxShadow(
                        color: activeColor.withValues(alpha: 0.15),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                ),
              ),
              Row(
                children: List.generate(labels.length, (i) {
                  final isSelected = i == selectedIndex;
                  return Expanded(
                    child: GestureDetector(
                      onTap: () => onChanged(i),
                      behavior: HitTestBehavior.opaque,
                      child: Center(
                        child: AnimatedDefaultTextStyle(
                          duration: const Duration(milliseconds: 200),
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight:
                                isSelected ? FontWeight.w600 : FontWeight.w500,
                            color:
                                isSelected ? activeTextColor : inactiveTextColor,
                          ),
                          child: Text(labels[i]),
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ],
          );
        },
      ),
    );
  }
}

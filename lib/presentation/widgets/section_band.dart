import 'package:flutter/material.dart';

/// Full-bleed colored band that wraps a home-page module.
class SectionBand extends StatelessWidget {
  const SectionBand({
    super.key,
    required this.color,
    required this.child,
  });

  final Color color;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: color,
      child: SizedBox(
        width: double.infinity,
        child: child,
      ),
    );
  }
}

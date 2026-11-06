import 'package:flutter/material.dart';

import '../tokens/tomathics_radius.dart';

/// Static accessible placeholder for content being loaded.
class TomathicsSkeleton extends StatelessWidget {
  const TomathicsSkeleton({
    required this.width,
    required this.height,
    this.radius = TomathicsRadius.sm,
    super.key,
  }) : assert(width > 0),
       assert(height > 0);

  final double width;
  final double height;
  final double radius;

  @override
  Widget build(BuildContext context) {
    final palette = Theme.of(context).colorScheme;
    return Semantics(
      label: 'Carregando conteúdo',
      child: ExcludeSemantics(
        child: Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            color: palette.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(radius),
          ),
        ),
      ),
    );
  }
}

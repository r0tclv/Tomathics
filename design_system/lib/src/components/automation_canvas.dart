import 'package:flutter/material.dart';

import '../theme/tomathics_semantic_colors.dart';

/// A node placed on the automation graph.
@immutable
class AutomationCanvasNode {
  const AutomationCanvasNode({
    required this.id,
    required this.position,
    required this.child,
    this.inputAnchor = const Offset(0, 30),
    this.outputAnchor = const Offset(238, 30),
  });

  final String id;
  final Offset position;
  final Widget child;
  final Offset inputAnchor;
  final Offset outputAnchor;
}

/// A directed edge between two [AutomationCanvasNode] IDs.
@immutable
class AutomationCanvasConnection {
  const AutomationCanvasConnection({required this.from, required this.to});

  final String from;
  final String to;
}

/// Fixed-size editor canvas with a subtle dot grid and bezier connections.
///
/// Place this in a scroll view when its dimensions may exceed the viewport.
class AutomationCanvas extends StatelessWidget {
  const AutomationCanvas({
    required this.width,
    required this.height,
    required this.nodes,
    this.connections = const [],
    this.gridSize = 24,
    super.key,
  }) : assert(width > 0),
       assert(height > 0),
       assert(gridSize > 0);

  final double width;
  final double height;
  final List<AutomationCanvasNode> nodes;
  final List<AutomationCanvasConnection> connections;
  final double gridSize;

  @override
  Widget build(BuildContext context) {
    final semantic = Theme.of(context).extension<TomathicsSemanticColors>()!;
    final palette = Theme.of(context).colorScheme;
    final nodesById = {for (final node in nodes) node.id: node};
    assert(nodesById.length == nodes.length, 'Canvas node IDs must be unique.');
    final links = [
      for (final connection in connections)
        _CanvasLink(
          start:
              nodesById[connection.from]!.position +
              nodesById[connection.from]!.outputAnchor,
          end:
              nodesById[connection.to]!.position +
              nodesById[connection.to]!.inputAnchor,
        ),
    ];

    return SizedBox(
      width: width,
      height: height,
      child: Stack(
        clipBehavior: Clip.hardEdge,
        children: [
          Positioned.fill(
            child: CustomPaint(
              painter: _CanvasPainter(
                gridColor: semantic.canvasGrid,
                connectionColor: palette.secondary,
                gridSize: gridSize,
                links: links,
              ),
            ),
          ),
          for (final node in nodes)
            Positioned(
              left: node.position.dx,
              top: node.position.dy,
              child: node.child,
            ),
        ],
      ),
    );
  }
}

class _CanvasLink {
  const _CanvasLink({required this.start, required this.end});

  final Offset start;
  final Offset end;
}

class _CanvasPainter extends CustomPainter {
  const _CanvasPainter({
    required this.gridColor,
    required this.connectionColor,
    required this.gridSize,
    required this.links,
  });

  final Color gridColor;
  final Color connectionColor;
  final double gridSize;
  final List<_CanvasLink> links;

  @override
  void paint(Canvas canvas, Size size) {
    final dots = Paint()..color = gridColor;
    for (double x = gridSize / 2; x < size.width; x += gridSize) {
      for (double y = gridSize / 2; y < size.height; y += gridSize) {
        canvas.drawCircle(Offset(x, y), 1, dots);
      }
    }

    final line = Paint()
      ..color = connectionColor
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;
    for (final link in links) {
      final bend = (link.end.dx - link.start.dx).abs() * 0.5;
      final path = Path()
        ..moveTo(link.start.dx, link.start.dy)
        ..cubicTo(
          link.start.dx + bend,
          link.start.dy,
          link.end.dx - bend,
          link.end.dy,
          link.end.dx,
          link.end.dy,
        );
      canvas.drawPath(path, line);
    }
  }

  @override
  bool shouldRepaint(covariant _CanvasPainter oldDelegate) => true;
}

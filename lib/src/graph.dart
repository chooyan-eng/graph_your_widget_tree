import 'package:flutter/material.dart';
import 'package:graph_your_widget_tree/graph_your_widget_tree.dart';
import 'package:graph_your_widget_tree/src/calculator.dart';
import 'package:graph_your_widget_tree/src/graphed_widget.dart';

/// An entry point of the package.
/// Place [Graph] whereever you want to display the widget tree represented by [root].
class Graph extends StatelessWidget {
  const Graph({
    super.key,
    required this.root,
    this.onHover,
    this.onTap,
  });

  final WidgetEntry root;
  final void Function(WidgetEntry?)? onHover;
  final void Function(WidgetEntry)? onTap;

  static const _calculator = Calculator();
  static const _margin = 16.0;
  static const _connectionHeight = 60.0;

  @override
  Widget build(BuildContext context) {
    final boxSize = GraphTheme.of(context).size;
    final desiredGraphWidth = Graph._calculator.desiredGraphWidth(
      root,
      margin: Graph._margin,
      boxWidth: boxSize.width,
    );

    final desiredGraphHeight = Graph._calculator.desiredGraphHeight(
      root,
      boxHeight: boxSize.height,
      connectionHeight: Graph._connectionHeight,
    );

    final renderedEntries = Graph._calculator.renderedEntriesOf(
      root,
      graphWidth: desiredGraphWidth,
      offsetX: 0,
      depth: 0,
      margin: Graph._margin,
      boxSize: boxSize,
      connectionHeight: Graph._connectionHeight,
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.dispatchNotification(
        RenderDetailNotification(renderedEntries),
      );
    });

    return FittedBox(
      child: SizedBox(
        width: desiredGraphWidth,
        height: desiredGraphHeight,
        child: Stack(
          children: [
            ...renderedEntries.map(
              (info) => Positioned(
                left: info.position.dx,
                top: info.position.dy,
                child: GraphedWidget(
                  name: info.entry.name,
                  type: info.entry.type,
                  onHoverStart: () => onHover?.call(info.entry),
                  onHoverEnd: () => onHover?.call(null),
                  onTap: () => onTap?.call(info.entry),
                ),
              ),
            ),
            ...renderedEntries.map(
              (info) {
                final lines = Graph._calculator.linesFrom(
                  info.entry,
                  boxSize: boxSize,
                  allRenderedEntries: renderedEntries,
                );
                return lines.map((line) {
                  final theme = GraphTheme.of(
                    context,
                    type: line.$1.entry.type,
                  );
                  return CustomPaint(
                    painter: _ConnectionPainter(
                      from: line.$2,
                      to: line.$3,
                      color: theme.lineColor,
                      width: theme.lineWidth,
                    ),
                  );
                }).toList();
              },
            ).expand((e) => e),
          ],
        ),
      ),
    );
  }
}

class _ConnectionPainter extends CustomPainter {
  _ConnectionPainter({
    required this.from,
    required this.to,
    required this.color,
    required this.width,
  });

  final Offset from;
  final Offset to;
  final Color color;
  final double width;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = width;

    canvas.drawLine(from, to, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) =>
      from != (oldDelegate as _ConnectionPainter).from || to != oldDelegate.to;
}

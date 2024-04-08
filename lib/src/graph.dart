import 'package:flutter/material.dart';
import 'package:graph_your_widget_tree/graph_your_widget_tree.dart';
import 'package:graph_your_widget_tree/src/calculator.dart';
import 'package:graph_your_widget_tree/src/graphed_widget.dart';

/// An entry point of the package.
/// Place [Graph] whereever you want to display the widget tree represented by [root].
class Graph extends StatelessWidget {
  Graph({
    super.key,
    required this.root,
  });

  final WidgetEntry root;

  final _calculator = Calculator();

  final _margin = 16.0;
  final _connectionHeight = 60.0;

  @override
  Widget build(BuildContext context) {
    final boxSize = GraphTheme.of(context).size;
    final desiredGraphWidth = _calculator.desiredGraphWidth(
      root,
      margin: _margin,
      boxWidth: boxSize.width,
    );

    final desiredGraphHeight = _calculator.desiredGraphHeight(
      root,
      boxHeight: boxSize.height,
      connectionHeight: _connectionHeight,
    );

    final renderedEntries = _calculator.renderedEntriesOf(
      root,
      graphWidth: desiredGraphWidth,
      offsetX: 0,
      depth: 0,
      margin: _margin,
      boxSize: boxSize,
      connectionHeight: _connectionHeight,
    );

    return FittedBox(
      child: SizedBox(
        width: desiredGraphWidth,
        height: desiredGraphHeight,
        child: Stack(children: [
          ...renderedEntries.map(
            (info) => Positioned(
              left: info.position.dx,
              top: info.position.dy,
              child: GraphedWidget(
                name: info.entry.name,
                type: info.entry.type,
              ),
            ),
          ),
          ...renderedEntries.map(
            (info) {
              final lines = _calculator.linesFrom(
                info.entry,
                boxSize: boxSize,
                allRenderedEntries: renderedEntries,
              );
              return lines
                  .map((line) => CustomPaint(
                        painter: _ConnectionPainter(
                          from: line.$1,
                          to: line.$2,
                        ),
                      ))
                  .toList();
            },
          ).expand((e) => e),
        ]),
      ),
    );
  }
}

class _ConnectionPainter extends CustomPainter {
  _ConnectionPainter({
    required this.from,
    required this.to,
  });

  final Offset from;
  final Offset to;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black
      ..strokeWidth = 1;

    canvas.drawLine(from, to, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) =>
      from != (oldDelegate as _ConnectionPainter).from || to != oldDelegate.to;
}

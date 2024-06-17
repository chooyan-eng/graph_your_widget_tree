import 'dart:ui';

import 'package:graph_your_widget_tree/graph_your_widget_tree.dart';
import 'package:graph_your_widget_tree/src/rendered_entry.dart';

/// A utility class to calculate layout of the graph
class Calculator {
  const Calculator();

  /// calculate the desired width of the graph
  /// regardless of a given viewport
  double desiredGraphWidth(
    WidgetEntry entry, {
    required double margin,
    required double boxWidth,
  }) {
    final columns = entry.extraBranches + 1;
    final requiredMargins = columns - 1;
    return (columns * boxWidth) + (requiredMargins * margin);
  }

  /// calculate the desired height of the graph
  /// regardless of a given viewport
  double desiredGraphHeight(
    WidgetEntry entry, {
    required double connectionHeight,
    required double boxHeight,
  }) {
    final requiredConnections = entry.depth - 1;
    return (requiredConnections * connectionHeight) + (entry.depth * boxHeight);
  }

  /// calculate the desired width of [entry]'s subtrees
  List<double> desiredSubtreeWidths(
    WidgetEntry entry, {
    required double margin,
    required double boxWidth,
  }) {
    return entry.children.map((child) {
      return desiredGraphWidth(
        child,
        margin: margin,
        boxWidth: boxWidth,
      );
    }).toList();
  }

  /// calculate and generate [RenderedEntry]s from given parameters
  /// starting from [root] to every leaf.
  List<RenderedEntry> renderedEntriesOf(
    WidgetEntry root, {
    required double graphWidth,
    required double offsetX,
    required int depth, // start from 0
    required double margin,
    required Size boxSize,
    required double connectionHeight,
  }) {
    RenderedEntry renderedEntryOf(
      WidgetEntry entry,
    ) {
      final x = (graphWidth / 2) - (boxSize.width / 2) + offsetX;
      final y = (depth * boxSize.height) + (depth * connectionHeight);
      return RenderedEntry(
        entry: entry,
        position: Offset(x, y),
      );
    }

    final subtreeWidths = desiredSubtreeWidths(
      root,
      margin: margin,
      boxWidth: boxSize.width,
    );
    return root.children.fold<List<RenderedEntry>>(
      [renderedEntryOf(root)],
      (all, subEntry) {
        final index = root.children.indexOf(subEntry);
        final subOffsetX = subtreeWidths.take(index).fold(0.0, (sum, width) {
              return sum + width + margin;
            }) +
            offsetX;
        return [
          ...all,
          ...renderedEntriesOf(
            subEntry,
            graphWidth: subtreeWidths[index],
            offsetX: subOffsetX,
            depth: depth + 1,
            margin: margin,
            boxSize: boxSize,
            connectionHeight: connectionHeight,
          ),
        ];
      },
    );
  }

  /// calculate [Offset]s for lines connecting [root] to its children
  List<(RenderedEntry, Offset, Offset)> linesFrom(
    WidgetEntry root, {
    required Size boxSize,
    required List<RenderedEntry> allRenderedEntries,
  }) {
    final rootRenderedEntry = allRenderedEntries.firstWhere(
      (entry) => entry.entry == root,
    );

    final childrenRenderedEntries = root.children.map(
      (child) => allRenderedEntries.firstWhere(
        (entry) => entry.entry == child,
      ),
    );

    return childrenRenderedEntries.map(
      (childRenderedEntry) {
        final from = Rect.fromLTWH(
          rootRenderedEntry.position.dx,
          rootRenderedEntry.position.dy,
          boxSize.width,
          boxSize.height,
        ).bottomCenter;

        final to = Rect.fromLTWH(
          childRenderedEntry.position.dx,
          childRenderedEntry.position.dy,
          boxSize.width,
          boxSize.height,
        ).topCenter;
        return (childRenderedEntry, from, to);
      },
    ).toList();
  }
}

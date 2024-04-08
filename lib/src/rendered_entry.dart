import 'package:flutter/widgets.dart';
import 'package:graph_your_widget_tree/graph_your_widget_tree.dart';

/// An object preserving the result of layout calculation and other objects
/// for rendering a widget and related objects.
class RenderedEntry {
  RenderedEntry({
    required this.entry,
    required this.position,
  });

  /// [GlobalKey] to identify the widget and its [Offset]
  final key = GlobalKey();

  /// original [WidgetEntry] to be rendered
  final WidgetEntry entry;

  /// [Offset] to render the widget in the graph
  final Offset position;
}

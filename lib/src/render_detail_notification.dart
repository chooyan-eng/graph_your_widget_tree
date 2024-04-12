import 'package:flutter/widgets.dart';
import 'package:graph_your_widget_tree/src/rendered_entry.dart';

/// [Notification] to notify the rendered detail in every build.
class RenderDetailNotification extends Notification {
  RenderDetailNotification(this.detail);

  /// All the [RenderedEntry] that are rendered in the current build.
  final List<RenderedEntry> detail;
}

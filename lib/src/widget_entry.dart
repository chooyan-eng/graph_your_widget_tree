import 'dart:math';

import 'package:flutter/material.dart';

/// An object representing a widget and its children in a widget tree.
class WidgetEntry {
  const WidgetEntry._({
    required this.name,
    required this.children,
    this.marginBetweenSubtrees,
    this.type,
    this.key,
  });

  /// Creates a [WidgetEntry] with a single child.
  factory WidgetEntry.single({
    required String name,
    required WidgetEntry child,
    Enum? type,
    Key? key,
  }) =>
      WidgetEntry._(name: name, children: [child], type: type, key: key);

  /// Creates a [WidgetEntry] with multiple children.
  factory WidgetEntry.multiple({
    required String name,
    required List<WidgetEntry> children,
    double? marginBetweenSubtrees,
    Enum? type,
    Key? key,
  }) =>
      WidgetEntry._(
        name: name,
        children: children,
        marginBetweenSubtrees: marginBetweenSubtrees,
        type: type,
        key: key,
      );

  /// Creates a [WidgetEntry] with no children.
  factory WidgetEntry.leaf({
    required String name,
    Enum? type,
    Key? key,
  }) =>
      WidgetEntry._(name: name, children: [], type: type, key: key);

  /// The name of the widget.
  final String name;

  /// The children of the widget.
  final List<WidgetEntry> children;

  /// The desired margin between its subtrees.
  final double? marginBetweenSubtrees;

  /// The type of the widget.
  final Enum? type;

  /// [Key] to identify the entry.
  final Key? key;

  /// The number of extra branches below this entry.
  int get extraBranches {
    if (children.isEmpty) return 0;
    return children.fold(
      children.length - 1,
      (total, child) => total + child.extraBranches,
    );
  }

  /// The depth of the subtree below this entry.
  int get depth {
    if (children.isEmpty) return 1;
    return children.fold(
      1,
      (maxDepth, child) => max(maxDepth, child.depth + 1),
    );
  }
}

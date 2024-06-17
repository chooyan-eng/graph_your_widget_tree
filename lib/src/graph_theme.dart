import 'package:flutter/material.dart';
import 'package:graph_your_widget_tree/src/graph.dart';

/// [InheritedWidget] to provide styles of [Graph] and its internal widgets.
class GraphTheme extends StatelessWidget {
  const GraphTheme({
    super.key,
    required this.child,
    required this.defaultTheme,
    this.extraThemes = const {},
  });

  /// The child widget to be wrapped by this [GraphTheme].
  final Widget child;

  /// The default theme of [Graph] and its internal widgets.
  final GraphThemeData defaultTheme;

  /// Extra themes for each widget type represented by any enum.
  /// If [WidgetEntry] has a type, the theme of the widget is determined by this map.
  final Map<Enum, GraphThemeData> extraThemes;

  static const _defaultTheme = GraphThemeData();

  /// A static method to find [GraphThemeData] on the widget tree above given [context].
  /// When [type] is given, it returns the theme of the type, otherwise it returns [defaultTheme].
  static GraphThemeData of(BuildContext context, {Enum? type}) {
    final widget =
        context.dependOnInheritedWidgetOfExactType<_InheritedGraphTheme>();
    if (widget == null) {
      return _defaultTheme;
    }
    if (type == null) {
      return widget.theme.defaultTheme;
    }

    assert(
      widget.theme.extraThemes.containsKey(type),
      'No theme found for $type in GraphTheme',
    );

    return widget.theme.extraThemes[type]!;
  }

  @override
  Widget build(BuildContext context) {
    return _InheritedGraphTheme(
      theme: this,
      child: child,
    );
  }
}

class _InheritedGraphTheme extends InheritedWidget {
  const _InheritedGraphTheme({
    required super.child,
    required this.theme,
  });

  final GraphTheme theme;

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) {
    return theme.defaultTheme !=
            (oldWidget as _InheritedGraphTheme).theme.defaultTheme ||
        theme.extraThemes != oldWidget.theme.extraThemes;
  }
}

/// Data class to hold styles of each widget box.
class GraphThemeData {
  const GraphThemeData({
    this.borderColor = Colors.black,
    this.borderWidth = 1,
    this.lineColor = Colors.black,
    this.lineWidth = 1,
    this.backgroundColor,
    this.textStyle = const TextStyle(),
    this.size = const Size(120, 60),
  });

  /// The color of the border of the widget box.
  final Color borderColor;

  /// The width of the border of the widget box.
  final double borderWidth;

  /// The color of the border of the widget box.
  final Color lineColor;

  /// The width of the border of the widget box.
  final double lineWidth;

  /// The color of the background of the widget box.
  final Color? backgroundColor;

  /// The style of the text inside the widget box.
  final TextStyle? textStyle;

  /// The size of the widget box.
  /// [Size(120, 60)] by default.
  final Size size;
}

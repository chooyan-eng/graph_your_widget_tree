import 'package:flutter/material.dart';
import 'package:graph_your_widget_tree/graph_your_widget_tree.dart';

/// A widget that represents each piece of widget on the widget tree.
class GraphedWidget extends StatelessWidget {
  const GraphedWidget({
    super.key,
    required this.name,
    required this.onHoverStart,
    required this.onHoverEnd,
    required this.onTap,
    this.type,
  });

  /// The name of the widget
  final String name;

  final VoidCallback onHoverStart;
  final VoidCallback onHoverEnd;
  final VoidCallback onTap;

  /// The type of the widget, which can be represented by any enum class.
  /// This [type] is used to determine the theme of the widget.
  /// see [GraphTheme.extraThemes] for more details.
  final Enum? type;

  @override
  Widget build(BuildContext context) {
    final defaultTheme = GraphTheme.of(context);
    final theme = GraphTheme.of(context, type: type);
    return GestureDetector(
      onTap: () => onTap(),
      child: MouseRegion(
        onEnter: (_) => onHoverStart(),
        onExit: (_) => onHoverEnd(),
        child: Container(
          width: defaultTheme.size.width,
          height: defaultTheme.size.height,
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            border: Border.all(
              color: theme.borderColor,
              width: theme.borderWidth,
            ),
            color: theme.backgroundColor ?? defaultTheme.backgroundColor,
          ),
          alignment: Alignment.center,
          child: FittedBox(
            child: Text(
              name,
              textAlign: TextAlign.center,
              style: (theme.textStyle?.inherit ?? true)
                  ? defaultTheme.textStyle?.merge(theme.textStyle)
                  : theme.textStyle,
            ),
          ),
        ),
      ),
    );
  }
}

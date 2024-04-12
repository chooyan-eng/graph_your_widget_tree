import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:graph_your_widget_tree/graph_your_widget_tree.dart';

void main() {
  runApp(const MainApp());
}

enum BoxType {
  none,
  focus,
  highlighted,
}

enum WidgetAppearance { normal, focused, disabled }

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: NotificationListener<RenderDetailNotification>(
          onNotification: (notification) {
            // Do something with the rendered detail.
            return false;
          },
          child: Center(
            child: GraphTheme(
              defaultTheme: const GraphThemeData(),
              extraThemes: const {
                WidgetAppearance.focused: GraphThemeData(
                  textStyle: TextStyle(color: Colors.blue),
                  borderWidth: 4,
                  borderColor: Colors.blue,
                ),
                WidgetAppearance.disabled: GraphThemeData(
                  textStyle: TextStyle(color: Colors.grey),
                  borderWidth: 1,
                  borderColor: Colors.grey,
                ),
              },
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Graph(
                  root: WidgetEntry.single(
                    name: 'MaterialApp',
                    child: WidgetEntry.multiple(
                      name: 'Scaffold',
                      children: [
                        WidgetEntry.multiple(
                          name: 'AppBar',
                          children: [
                            WidgetEntry.single(
                              name: 'IconButton',
                              child: WidgetEntry.leaf(name: 'Icon'),
                              type: WidgetAppearance.focused,
                            ),
                          ],
                        ),
                        WidgetEntry.multiple(
                          name: 'Column',
                          children: [
                            WidgetEntry.leaf(name: 'Text'),
                            WidgetEntry.leaf(name: 'Text'),
                          ],
                        ),
                        WidgetEntry.leaf(
                          name: 'Floating\nActionButton',
                          type: WidgetAppearance.disabled,
                        ),
                      ],
                    ),
                  ),
                  onHover: (entry) {
                    log('hovered: ${entry?.name}');
                  },
                  onTap: (entry) {
                    log('tapped: ${entry.name}');
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

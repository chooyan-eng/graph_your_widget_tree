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

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: GraphTheme(
            defaultTheme: const GraphThemeData(
              textStyle: TextStyle(fontSize: 20),
            ),
            extraThemes: {
              BoxType.focus: GraphThemeData(
                borderColor: Colors.blue,
                backgroundColor: Colors.blue[50],
                borderWidth: 2,
                textStyle: const TextStyle(fontWeight: FontWeight.w700),
              ),
              BoxType.highlighted: const GraphThemeData(
                borderColor: Colors.red,
                borderWidth: 2,
                textStyle: TextStyle(color: Colors.red),
              ),
            },
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Graph(
                root: WidgetEntry.single(
                  name: 'MaterialApp',
                  child: WidgetEntry.multiple(
                    name: 'Scaffold',
                    type: BoxType.focus,
                    children: [
                      WidgetEntry.multiple(name: 'AppBar', children: [
                        WidgetEntry.single(
                          name: 'IconButton',
                          child: WidgetEntry.leaf(name: 'Icon'),
                        ),
                      ]),
                      WidgetEntry.multiple(name: 'Column', children: [
                        WidgetEntry.leaf(name: 'Text'),
                        WidgetEntry.leaf(
                          name: 'Text',
                          type: BoxType.highlighted,
                        ),
                      ]),
                      WidgetEntry.leaf(
                        name: 'Floating\nActionButton',
                        type: BoxType.focus,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

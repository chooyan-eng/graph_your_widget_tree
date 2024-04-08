import 'package:flutter_test/flutter_test.dart';
import 'package:graph_your_widget_tree/graph_your_widget_tree.dart';

void main() {
  group('when typical widget tree is given', () {
    final widgetEntry = WidgetEntry.single(
      name: 'MaterialApp',
      child: WidgetEntry.multiple(
        name: 'Scaffold',
        children: [
          WidgetEntry.multiple(name: 'AppBar', children: [
            WidgetEntry.leaf(name: 'IconButton'),
            WidgetEntry.leaf(name: 'Text'),
            WidgetEntry.leaf(name: 'IconButton'),
          ]),
          WidgetEntry.multiple(name: 'Column', children: [
            WidgetEntry.leaf(name: 'Text'),
            WidgetEntry.leaf(name: 'Text'),
            WidgetEntry.leaf(name: 'Text'),
          ]),
          WidgetEntry.leaf(name: 'FloatingActionButton'),
        ],
      ),
    );
    test('depth is 4', () {
      expect(widgetEntry.depth, 4);
    });

    test('extraBranches is 6 (7 branches in total)', () {
      expect(widgetEntry.extraBranches, 6);
    });
  });
}

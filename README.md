<!--
This README describes the package. If you publish this package to pub.dev,
this README's contents appear on the landing page for your package.

For information about how to write a good package README, see the guide for
[writing package pages](https://dart.dev/guides/libraries/writing-package-pages).

For general information about developing packages, see the Dart guide for
[creating packages](https://dart.dev/guides/libraries/create-library-packages)
and the Flutter guide for
[developing packages and plugins](https://flutter.dev/developing-packages).
-->

## graph_your_widget_tree

`graph_your_widget_tree` provides `Graph` widget that renders a model of a widget tree represented by `WidgetEntry` and its children.

This package mainly aims to be used with other packages making slide decks, such as [flutter_deck](https://pub.dev/packages/flutter_deck) or [slick_slides](https://pub.dev/packages/slick_slides), not for production apps.

## Features

This packages provides the features of 

- [x] Rendering a graph of a widget tree
- [x] Styling each node of the widgets
- [x] Detecting events from the widget tree
- [x] Notifying the result of layout calculation in detail

Every features is for making your slide decks more interactive.

## Getting started

As an quick introduction, you can place `Graph` widget like the code below.

```dart
Graph(
  root: WidgetEntry.single(
    name: 'MaterialApp',
    child: WidgetEntry.leaf(name: 'Scaffold'),
  ),
),
```

This `Graph` with root `WidgetEntry` named 'MaterialApp' and its child 'Scaffold' will draw the widget tree like below.

![A picture of a simple widget tree](https://github.com/chooyan-eng/graph_your_widget_tree/assets/20849526/ba17a9ff-bcd6-4e26-9027-3611f97318d4)

## Usage

### Basics

To make a graph of a widget tree, place `Graph` widget wherever you want to draw.

```dart
Graph(),
```

`Graph` requires a `WidgetEntry` object as a `root` of the widget tree.

```dart
Graph(
  root: WidgetEntry.single(),
)
```

`WidgetEntry` represents one node of the widget tree. As Flutter widgets has 3 patterns that

- Have one child, such like `SizedBox`, `Center`
- Have multiple children, such like `Column`, `Stack`
- Have no child, `leaf` in other words, such like `Image`, `RichText`

Therefore, `WidgetEntry` has three types of constructors, `WidgetEntry.single()`, `WidgetEntry.multiple()`, and `WidgetEntry.leaf()`.

All you need to do is to describe the structure of the widget tree with `WidgetEntry` and pass the root of the nodes to `Graph`.

For example, if the code below is run,

```dart
Graph(
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
            ),
          ],
        ),
        WidgetEntry.multiple(
          name: 'Column', children: [
            WidgetEntry.leaf(name: 'Text'),
            WidgetEntry.leaf(name: 'Text'),
          ],
        ),
        WidgetEntry.leaf(
          name: 'Floating\nActionButton',
        ),
      ],
    ),
  ),
),
```

This will render the widget tree below

![An image of a sample widget tree](https://github.com/chooyan-eng/graph_your_widget_tree/assets/20849526/ea482d40-ed49-4244-9cda-1886e1705ee7)

## Styles

Each `WidgetEntry` can be styled using `GraphTheme`.

As `GraphTheme` is an `InheritedWidget`, you can place this wherever you want as long as it is an ancestor of `Graph`.

```dart
GraphTheme(
  child: Graph(),
),
```

`GraphTheme` has two options for styling, `defaultTheme` and `extraThemes`.

`defaultTheme` is applied to all the `WidgetEntry`s as a default style.

For example, you can make all the texts and the borders of the boxes with the code below.

```dart
GraphTheme(
  child: Graph(),
  defaultTheme: const GraphThemeData(
    textStyle: TextStyle(fontWeight: FontWeight.w800),
    borderWidth: 4,
  ),
),
```

![An image of bolded text and boxes](https://github.com/chooyan-eng/graph_your_widget_tree/assets/20849526/866152c4-6bef-480f-8fca-a360db222652)

`extraThemes` is for styling specific `WidgetEntry`s individually.

As the type of `extraThemes` is `Map<Enum, GraphThemeData>`, you can define any `enum` type as keys of `extraThemes` and can set associated `GraphThemeData` as values.

```dart
enum WidgetAppearance { normal, focused, disabled }

GraphTheme(
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
  child: Graph(),
),
```

Then, if you want to apply one of the `extraThemes` to `WidgetEntry`, set `type` by passing one of the keys of `extraThemes`, `WidgetAppearance.focused` or `WidgetAppearance.disabled` in this case.

When you set `WidgetAppearance.focused` to `WidgetEntry` of 'IconButton', and `WidgetAppearance.disabled` to `FloatingActionButton',

```dart
Graph(
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
),
```

`Graph` will render the widget tree below.

![An image of styled boxes](https://github.com/chooyan-eng/graph_your_widget_tree/assets/20849526/9b37d61f-466d-4975-a852-b840c673ad20)

### Rebuilding and updating the UI

As all the layouts and styles are updated on every rebuilding, you can manage the state of 'how each widget should be displayed' with whatever method you want, such as `StatefulWidget`, `riverpod` or even `Get`.

This enables you to make slide decks with dinamically animating widget trees.

## Events 

`Graph` has currently 2 callbacks `onHover` and `onTap`. Both callbacks are called when each event happens on a `WidgetEntry`.

```dart
Graph(
  onHover: (entry) {
    log('hovered: ${entry?.name}');
  },
  onTap: (entry) {
    log('tapped: ${entry.name}');
  },
)
```

## Notification

By placing `NotificationListener<RenderDetailNotification>` somewhere above `Graph`, you can listen every update of a rendered widget tree.

```dart
NotificationListener<RenderDetailNotification> {
  onNotification: (notification) {
    // Do something with the rendered detail.
    return false;
  },
  child: SomeWidget(
    child: Graph(),
  ),
}
```

As `notification` has all the detail about rendered widgets on `Graph`, it enables you to overlay additional widgets based on positions of the widgets.

See [Flutter doc](https://api.flutter.dev/flutter/widgets/NotificationListener-class.html) for more information about `NotificationListener`.
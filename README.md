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

`graph_your_widget_tree` provides `Graph` widget that renders a model of a widget tree represented by [WidgetEntry] and its children.

This package mainly aims to be used with other packages making slide decks, such as [flutter_deck]() or [slick_slides](), not for production apps.

## Features

This packages provides the features of 

- Rendering a graph of a widget tree
- Styling each node of the widgets
- Detecting events from the widget tree
- Notifying the result of layout calculation in detail

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


TODO(chooyan-eng): write in detail

See `/example`.
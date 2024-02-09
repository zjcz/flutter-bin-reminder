import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bin_reminder/widgets/bins_list.dart';
import 'package:bin_reminder/models/bin.dart';

Widget createList(
    List<Bin> bins, Function(Bin) onEdit, Function(Bin) onDelete) {
  BinsList list = BinsList(
    binList: Future<List<Bin>>.value(bins),
    onDeleteBin: onDelete,
    onEditBin: onEdit,
  );

  return MaterialApp(home: Scaffold(body: list));
}

void main() {
  group('List View Tile Widget Tests', () {
    testWidgets('Testing Bin List View Tile', (tester) async {
      String desc = 'New Bin Description Text goes here...';
      Bin b = Bin(
          id: 1,
          name: desc,
          binType: BinType.wheelie,
          binColor: BinColor.green,
          collectionDate: DateTime.now(),
          collectionFrequency: CollectionFrequency.fortnightly,
          isPaused: false);

      await tester.pumpWidget(createList([b], (bin) {}, (bin) {}));
      await tester.pumpAndSettle();

      expect(find.byType(ListView), findsOneWidget);
      expect(find.byType(ListTile), findsOneWidget);
      expect(find.text(desc), findsOneWidget);
    });

    testWidgets('Testing Bin List View Tile for empty list', (tester) async {
      await tester.pumpWidget(createList([], (bin) {}, (bin) {}));
      await tester.pumpAndSettle();

      expect(find.byType(ListView), findsNothing);
      expect(find.byType(ListTile), findsNothing);
      expect(find.text('No bins found.  Click + to add one'), findsOneWidget);
    });

    testWidgets('Testing tapping for edit', (tester) async {
      final onEditCompleter = Completer<Bin>();
      final onDeleteCompleter = Completer<Bin>();
      Bin b1 = Bin(
          id: 1,
          name: 'New Bin Description',
          binType: BinType.wheelie,
          binColor: BinColor.green,
          collectionDate: DateTime.now(),
          collectionFrequency: CollectionFrequency.fortnightly,
          isPaused: false);
      Bin b2 = Bin(
          id: 2,
          name: 'New Bin Description 2',
          binType: BinType.wheelie,
          binColor: BinColor.green,
          collectionDate: DateTime.now(),
          collectionFrequency: CollectionFrequency.fortnightly,
          isPaused: false);
      Bin b3 = Bin(
          id: 3,
          name: 'New Bin Description 3',
          binType: BinType.wheelie,
          binColor: BinColor.green,
          collectionDate: DateTime.now(),
          collectionFrequency: CollectionFrequency.fortnightly,
          isPaused: false);

      await tester.pumpWidget(createList(
          [b1, b2, b3], onEditCompleter.complete, onDeleteCompleter.complete));
      await tester.pumpAndSettle();

      await tester.tap(find.byType(ListTile).last);
      await tester.pumpAndSettle();

      expect(onEditCompleter.isCompleted, isTrue);
      expect(onDeleteCompleter.isCompleted, isFalse);

      // check the correct value was passed in the callback
      Bin toEdit = await onEditCompleter.future;
      expect(toEdit, b3);
    });

    testWidgets('Testing tapping for delete', (tester) async {
      final onEditCompleter = Completer<Bin>();
      final onDeleteCompleter = Completer<Bin>();
      Bin b1 = Bin(
          id: 1,
          name: 'New Bin Description',
          binType: BinType.wheelie,
          binColor: BinColor.green,
          collectionDate: DateTime.now(),
          collectionFrequency: CollectionFrequency.fortnightly,
          isPaused: false);
      Bin b2 = Bin(
          id: 2,
          name: 'New Bin Description 2',
          binType: BinType.wheelie,
          binColor: BinColor.green,
          collectionDate: DateTime.now(),
          collectionFrequency: CollectionFrequency.fortnightly,
          isPaused: false);
      Bin b3 = Bin(
          id: 3,
          name: 'New Bin Description 3',
          binType: BinType.wheelie,
          binColor: BinColor.green,
          collectionDate: DateTime.now(),
          collectionFrequency: CollectionFrequency.fortnightly,
          isPaused: false);

      await tester.pumpWidget(createList(
          [b1, b2, b3], onEditCompleter.complete, onDeleteCompleter.complete));
      await tester.pumpAndSettle();

      // first step presses the ... button to display the menu options
      await tester.tap(find.byType(IconButton).last);
      await tester.pumpAndSettle();

      // need second step to select the remove menu item
      await tester.tap(find.widgetWithText(MenuItemButton, 'Remove'));
      await tester.pumpAndSettle();

      expect(onEditCompleter.isCompleted, isFalse);
      expect(onDeleteCompleter.isCompleted, isTrue);

      // check the correct value was passed in the callback
      Bin toDelete = await onDeleteCompleter.future;
      expect(toDelete, b3);
    });
  });
}

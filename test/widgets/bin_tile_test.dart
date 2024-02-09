import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bin_reminder/widgets/bin_tile.dart';
import 'package:bin_reminder/models/bin.dart';
import 'dart:async';

Widget createTile(Bin bin, Function() onEdit, Function() onDelete) {
  BinTile tile = BinTile(
    bin: bin,
    onDeleteCallback: onDelete,
    onEditCallback: onEdit,
  );

  return MaterialApp(home: Scaffold(body: tile));
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

      await tester.pumpWidget(createTile(b, () {}, () {}));

      expect(find.text(desc), findsOneWidget);
    });

    testWidgets('Testing next collection due today description',
        (tester) async {
      Bin b = Bin(
          id: 1,
          name: 'New Bin Description',
          binType: BinType.wheelie,
          binColor: BinColor.green,
          collectionDate: DateTime.now(),
          collectionFrequency: CollectionFrequency.fortnightly,
          isPaused: false);

      await tester.pumpWidget(createTile(b, () {}, () {}));

      expect(find.text('Due Today'), findsOneWidget);
    });

    testWidgets('Testing next collection due tomorrow description',
        (tester) async {
      Bin b = Bin(
          id: 1,
          name: 'New Bin Description',
          binType: BinType.wheelie,
          binColor: BinColor.green,
          collectionDate: DateTime.now().add(const Duration(days: 1)),
          collectionFrequency: CollectionFrequency.fortnightly,
          isPaused: false);

      await tester.pumpWidget(createTile(b, () {}, () {}));

      expect(find.text('Due Tomorrow'), findsOneWidget);
    });

    testWidgets('Testing collection paused description', (tester) async {
      Bin b = Bin(
          id: 1,
          name: 'New Bin Description',
          binType: BinType.wheelie,
          binColor: BinColor.green,
          collectionDate: DateTime.now().add(const Duration(days: 1)),
          collectionFrequency: CollectionFrequency.fortnightly,
          isPaused: true);

      await tester.pumpWidget(createTile(b, () {}, () {}));

      expect(find.text('Paused'), findsOneWidget);
    });

    testWidgets('Testing tapping for edit', (tester) async {
      final onEditCompleter = Completer<void>();
      final onDeleteCompleter = Completer<void>();
      Bin b = Bin(
          id: 1,
          name: 'New Bin Description',
          binType: BinType.wheelie,
          binColor: BinColor.green,
          collectionDate: DateTime.now(),
          collectionFrequency: CollectionFrequency.fortnightly,
          isPaused: false);

      await tester.pumpWidget(
          createTile(b, onEditCompleter.complete, onDeleteCompleter.complete));

      await tester.tap(find.byType(ListTile));
      await tester.pumpAndSettle();

      expect(onEditCompleter.isCompleted, isTrue);
      expect(onDeleteCompleter.isCompleted, isFalse);
    });

    testWidgets('Testing tapping for delete', (tester) async {
      final onEditCompleter = Completer<void>();
      final onDeleteCompleter = Completer<void>();
      Bin b = Bin(
          id: 1,
          name: 'New Bin Description',
          binType: BinType.wheelie,
          binColor: BinColor.green,
          collectionDate: DateTime.now(),
          collectionFrequency: CollectionFrequency.fortnightly,
          isPaused: false);

      await tester.pumpWidget(
          createTile(b, onEditCompleter.complete, onDeleteCompleter.complete));

      // first step presses the ... button to display the menu options
      await tester.tap(find.byType(IconButton));
      await tester.pumpAndSettle();

      // need second step to select the remove menu item
      await tester.tap(find.widgetWithText(MenuItemButton, 'Remove'));
      await tester.pumpAndSettle();

      expect(onEditCompleter.isCompleted, isFalse);
      expect(onDeleteCompleter.isCompleted, isTrue);
    });
  });
}

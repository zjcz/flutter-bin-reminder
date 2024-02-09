import 'package:bin_reminder/widgets/collection_frequency_selector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bin_reminder/models/bin.dart';
import 'dart:async';

Widget createSelector(CollectionFrequency? collectionFrequency,
    Function(CollectionFrequency?) onSelectionChanged) {
  CollectionFrequencySelector selector = CollectionFrequencySelector(
    collectionFrequency: collectionFrequency,
    errorText: null,
    edgeInsets: null,
    onSelectionChanged: onSelectionChanged,
  );

  return MaterialApp(home: Scaffold(body: selector));
}

void main() {
  group('Collection Frequency Selector Widget Tests', () {
    testWidgets('Testing Collection Frequency Selector', (tester) async {
      await tester.pumpWidget(createSelector(null, (value) {}));

      expect(find.byType(DropdownMenu<CollectionFrequency>), findsOneWidget);
    });

    testWidgets('Testing Collection Frequency Selector Entries',
        (tester) async {
      await tester.pumpWidget(createSelector(null, (value) {}));

      expect(find.byType(MenuItemButton),
          findsExactly(CollectionFrequency.values.length));
    });

    testWidgets('Testing Change Selection to weekly', (tester) async {
      final onSelectionChangedCompleter = Completer<CollectionFrequency>();

      await tester.pumpWidget(
          createSelector(null, onSelectionChangedCompleter.complete));

      await tester.tap(find.byType(DropdownMenu<CollectionFrequency>));
      await tester.pumpAndSettle();
      await tester.tap(find
          .widgetWithText(MenuItemButton, CollectionFrequency.weekly.name)
          .last);
      await tester.pump();

      expect(onSelectionChangedCompleter.isCompleted, isTrue);
      CollectionFrequency selection = await onSelectionChangedCompleter.future;
      expect(selection, CollectionFrequency.weekly);
    });

    testWidgets('Testing Change Selection to fortnightly', (tester) async {
      final onSelectionChangedCompleter = Completer<CollectionFrequency>();

      await tester.pumpWidget(
          createSelector(null, onSelectionChangedCompleter.complete));

      await tester.tap(find.byType(DropdownMenu<CollectionFrequency>));
      await tester.pumpAndSettle();
      await tester.tap(find
          .widgetWithText(MenuItemButton, CollectionFrequency.fortnightly.name)
          .last);
      await tester.pump();

      expect(onSelectionChangedCompleter.isCompleted, isTrue);
      CollectionFrequency selection = await onSelectionChangedCompleter.future;
      expect(selection, CollectionFrequency.fortnightly);
    });

    testWidgets('Testing Change Selection to monthly', (tester) async {
      final onSelectionChangedCompleter = Completer<CollectionFrequency>();

      await tester.pumpWidget(
          createSelector(null, onSelectionChangedCompleter.complete));

      await tester.tap(find.byType(DropdownMenu<CollectionFrequency>));
      await tester.pumpAndSettle();
      await tester.tap(find
          .widgetWithText(MenuItemButton, CollectionFrequency.monthly.name)
          .last);
      await tester.pump();

      expect(onSelectionChangedCompleter.isCompleted, isTrue);
      CollectionFrequency selection = await onSelectionChangedCompleter.future;
      expect(selection, CollectionFrequency.monthly);
    });
  });
}

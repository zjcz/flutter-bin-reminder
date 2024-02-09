import 'package:bin_reminder/widgets/bin_color_selector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bin_reminder/models/bin.dart';
import 'dart:async';

Widget createSelector(
    BinColor? binColor, Function(BinColor?) onSelectionChanged) {
  BinColorSelector selector = BinColorSelector(
    binColor: binColor,
    errorText: null,
    edgeInsets: null,
    onSelectionChanged: onSelectionChanged,
  );

  return MaterialApp(home: Scaffold(body: selector));
}

void main() {
  group('Bin Color Selector Widget Tests', () {
    testWidgets('Testing Bin Color Selector', (tester) async {
      await tester.pumpWidget(createSelector(null, (value) {}));

      expect(find.byType(DropdownMenu<BinColor>), findsOneWidget);
    });

    testWidgets('Testing Bin Color Selector Entries', (tester) async {
      await tester.pumpWidget(createSelector(null, (value) {}));

      expect(find.byType(MenuItemButton), findsExactly(BinColor.values.length));
    });

    testWidgets('Testing Bin Color to black', (tester) async {
      final onSelectionChangedCompleter = Completer<BinColor>();

      await tester.pumpWidget(
          createSelector(null, onSelectionChangedCompleter.complete));

      await tester.tap(find.byType(DropdownMenu<BinColor>));
      await tester.pumpAndSettle();
      await tester
          .tap(find.widgetWithText(MenuItemButton, BinColor.black.name).last);
      await tester.pump();

      expect(onSelectionChangedCompleter.isCompleted, isTrue);
      BinColor selection = await onSelectionChangedCompleter.future;
      expect(selection, BinColor.black);
    });

    testWidgets('Testing Bin Color to green', (tester) async {
      final onSelectionChangedCompleter = Completer<BinColor>();

      await tester.pumpWidget(
          createSelector(null, onSelectionChangedCompleter.complete));

      await tester.tap(find.byType(DropdownMenu<BinColor>));
      await tester.pumpAndSettle();
      await tester
          .tap(find.widgetWithText(MenuItemButton, BinColor.green.name).last);
      await tester.pump();

      expect(onSelectionChangedCompleter.isCompleted, isTrue);
      BinColor selection = await onSelectionChangedCompleter.future;
      expect(selection, BinColor.green);
    });

    testWidgets('Testing Bin Color to yellow', (tester) async {
      final onSelectionChangedCompleter = Completer<BinColor>();

      await tester.pumpWidget(
          createSelector(null, onSelectionChangedCompleter.complete));

      await tester.tap(find.byType(DropdownMenu<BinColor>));
      await tester.pumpAndSettle();
      await tester
          .tap(find.widgetWithText(MenuItemButton, BinColor.yellow.name).last);
      await tester.pump();

      expect(onSelectionChangedCompleter.isCompleted, isTrue);
      BinColor selection = await onSelectionChangedCompleter.future;
      expect(selection, BinColor.yellow);
    });
  });
}

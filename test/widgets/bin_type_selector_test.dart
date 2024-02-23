import 'package:bin_reminder/widgets/bin_type_selector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bin_reminder/models/bin.dart';
import 'dart:async';

Widget createSelector(BinType? binType, Function(BinType?) onSelectionChanged) {
  BinTypeSelector selector = BinTypeSelector(
    binType: binType,
    errorText: null,
    edgeInsets: null,
    onSelectionChanged: onSelectionChanged,
  );

  return MaterialApp(home: Scaffold(body: selector));
}

void main() {
  group('Bin Type Selector Widget Tests', () {
    testWidgets('Testing Bin Type Selector', (tester) async {
      await tester.pumpWidget(createSelector(null, (value) {}));

      expect(find.byType(DropdownMenu<BinType>), findsOneWidget);
    });

    testWidgets('Testing Bin Type Selector Entries', (tester) async {
      await tester.pumpWidget(createSelector(null, (value) {}));

      expect(find.byType(MenuItemButton), findsExactly(BinType.values.length));
    });

    testWidgets('Testing Bin Type to bag', (tester) async {
      final onSelectionChangedCompleter = Completer<BinType>();

      await tester.pumpWidget(
          createSelector(null, onSelectionChangedCompleter.complete));

      await tester.tap(find.byType(DropdownMenu<BinType>));
      await tester.pumpAndSettle();
      await tester
          .tap(find.widgetWithText(MenuItemButton, BinType.bag.name).last);
      await tester.pump();

      expect(onSelectionChangedCompleter.isCompleted, isTrue);
      BinType selection = await onSelectionChangedCompleter.future;
      expect(selection, BinType.bag);
    });

    testWidgets('Testing Bin Type to bin', (tester) async {
      final onSelectionChangedCompleter = Completer<BinType>();

      await tester.pumpWidget(
          createSelector(null, onSelectionChangedCompleter.complete));

      await tester.tap(find.byType(DropdownMenu<BinType>));
      await tester.pumpAndSettle();
      await tester
          .tap(find.widgetWithText(MenuItemButton, BinType.bin.name).last);
      await tester.pump();

      expect(onSelectionChangedCompleter.isCompleted, isTrue);
      BinType selection = await onSelectionChangedCompleter.future;
      expect(selection, BinType.bin);
    });

    testWidgets('Testing Bin Type to box', (tester) async {
      final onSelectionChangedCompleter = Completer<BinType>();

      await tester.pumpWidget(
          createSelector(null, onSelectionChangedCompleter.complete));

      await tester.tap(find.byType(DropdownMenu<BinType>));
      await tester.pumpAndSettle();
      await tester
          .tap(find.widgetWithText(MenuItemButton, BinType.box.name).last);
      await tester.pump();

      expect(onSelectionChangedCompleter.isCompleted, isTrue);
      BinType selection = await onSelectionChangedCompleter.future;
      expect(selection, BinType.box);
    });

    testWidgets('Testing Bin Type to wheelie', (tester) async {
      final onSelectionChangedCompleter = Completer<BinType>();

      await tester.pumpWidget(
          createSelector(null, onSelectionChangedCompleter.complete));

      await tester.tap(find.byType(DropdownMenu<BinType>));
      await tester.pumpAndSettle();
      await tester
          .tap(find.widgetWithText(MenuItemButton, BinType.wheelie.name).last);
      await tester.pump();

      expect(onSelectionChangedCompleter.isCompleted, isTrue);
      BinType selection = await onSelectionChangedCompleter.future;
      expect(selection, BinType.wheelie);
    });

    testWidgets('Testing Bin Type to industrial', (tester) async {
      final onSelectionChangedCompleter = Completer<BinType>();

      await tester.pumpWidget(
          createSelector(null, onSelectionChangedCompleter.complete));

      await tester.tap(find.byType(DropdownMenu<BinType>));
      await tester.pumpAndSettle();
      await tester.tap(
          find.widgetWithText(MenuItemButton, BinType.industrial.name).last);
      await tester.pump();

      expect(onSelectionChangedCompleter.isCompleted, isTrue);
      BinType selection = await onSelectionChangedCompleter.future;
      expect(selection, BinType.industrial);
    });
  });
}

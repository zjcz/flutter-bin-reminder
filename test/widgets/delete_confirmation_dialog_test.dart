import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bin_reminder/widgets/delete_confirmation_dialog.dart';
import 'dart:async';

Widget createDialog(Function onClick) {
  return MaterialApp(
      home: Scaffold(
    body: DeleteConfirmationDialog(
      onConfirmDelete: onClick,
    ),
  ));
}

void main() {
  group('Delete Confirmation Dialog Widget Tests', () {
    testWidgets('Testing Dialog Text', (tester) async {
      await tester.pumpWidget(createDialog(() {}));
      expect(find.text('Remove this Bin?'), findsOneWidget);
      expect(
          find.text(
              'Are you sure you want to remove this bin?  You will no longer receive reminders about it'),
          findsOneWidget);
    });

    testWidgets('Testing Dialog confirm', (tester) async {
      final completer = Completer<void>();
      await tester.pumpWidget(createDialog(completer.complete));

      expect(find.text('Remove this Bin?'), findsOneWidget);
      await tester.tap(find.text('Confirm'));
      await tester.pumpAndSettle();

      expect(completer.isCompleted, isTrue);
      expect(find.text('Remove this Bin?'), findsNothing);
    });

    testWidgets('Testing Dialog cancel', (tester) async {
      final completer = Completer<void>();
      await tester.pumpWidget(createDialog(completer.complete));

      expect(find.text('Remove this Bin?'), findsOneWidget);
      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle();

      expect(completer.isCompleted, isFalse);
      expect(find.text('Remove this Bin?'), findsNothing);
    });
  });
}

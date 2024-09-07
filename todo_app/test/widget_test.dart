import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:todo_app/main.dart';

void main() {
  testWidgets('Todo list displays and updates correctly',
      (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(TodoApp());

    // Wait for the widget tree to settle.
    await tester.pumpAndSettle();

    // Check if the 'No todos found' text is displayed initially.
    expect(find.text('No todos found'), findsOneWidget);

    // Simulate adding a new todo.
    await tester.tap(find.byIcon(Icons.add));
    await tester.pumpAndSettle();

    // Enter 'Test Todo' in the dialog.
    await tester.enterText(find.byType(TextField), 'Test Todo');
    await tester.tap(find.text('Add'));
    await tester.pumpAndSettle();

    // Verify the new todo appears in the list.
    expect(find.text('Test Todo'), findsOneWidget);
  });
}

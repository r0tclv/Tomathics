import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tomathics_design_system/tomathics_design_system.dart';

void main() {
  test('light and dark themes expose the semantic tokens', () {
    for (final theme in [TomathicsTheme.light(), TomathicsTheme.dark()]) {
      expect(theme.useMaterial3, isTrue);
      expect(theme.extension<TomathicsSemanticColors>(), isNotNull);
    }
    expect(
      TomathicsTheme.light().brightness,
      isNot(TomathicsTheme.dark().brightness),
    );
  });

  testWidgets('status badges expose a readable label and icon', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: TomathicsTheme.dark(),
        home: const Scaffold(
          body: TomathicsStatusBadge(status: TomathicsStatus.waiting),
        ),
      ),
    );

    expect(find.text('Aguardando'), findsOneWidget);
    expect(find.byIcon(Icons.schedule_rounded), findsOneWidget);
  });
}

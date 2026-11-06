import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tomathics_design_system/tomathics_design_system.dart';

void main() {
  testWidgets('canvas paints a connection between its node IDs', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: TomathicsTheme.dark(),
        home: const Scaffold(
          body: AutomationCanvas(
            width: 520,
            height: 120,
            connections: [AutomationCanvasConnection(from: 'one', to: 'two')],
            nodes: [
              AutomationCanvasNode(
                id: 'one',
                position: Offset(8, 8),
                child: Text('Etapa 1'),
              ),
              AutomationCanvasNode(
                id: 'two',
                position: Offset(280, 8),
                child: Text('Etapa 2'),
              ),
            ],
          ),
        ),
      ),
    );

    expect(find.text('Etapa 1'), findsOneWidget);
    expect(find.text('Etapa 2'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('node card communicates its kind and title', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: TomathicsTheme.light(),
        home: const Scaffold(
          body: AutomationNodeCard(
            title: 'Produzir pão',
            kind: AutomationNodeKind.action,
          ),
        ),
      ),
    );

    expect(find.text('AÇÃO'), findsOneWidget);
    expect(find.text('Produzir pão'), findsOneWidget);
  });

  testWidgets('objective progress is bounded and displays its goal', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: TomathicsTheme.dark(),
        home: const Scaffold(
          body: ObjectiveProgressCard(
            title: 'Objetivo #12',
            completed: 12,
            total: 10,
            status: TomathicsStatus.completed,
          ),
        ),
      ),
    );

    expect(find.text('Objetivo #12'), findsOneWidget);
    expect(find.text('12'), findsOneWidget);
  });
}

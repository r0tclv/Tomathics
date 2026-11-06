import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tomathics_design_system/tomathics_design_system.dart';

void main() {
  testWidgets('all automation states render with readable labels', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: TomathicsTheme.dark(),
        home: Scaffold(
          body: Wrap(
            children: [
              for (final status in TomathicsStatus.values)
                TomathicsStatusBadge(status: status),
            ],
          ),
        ),
      ),
    );

    expect(find.text('Em execução'), findsOneWidget);
    expect(find.text('Concluído'), findsOneWidget);
    expect(find.text('Aguardando'), findsOneWidget);
    expect(find.text('Pausado'), findsOneWidget);
    expect(find.text('Atenção'), findsOneWidget);
    expect(find.text('Falhou'), findsOneWidget);
    expect(find.text('Inativo'), findsOneWidget);
    expect(find.text('Bloqueado'), findsOneWidget);
    expect(find.text('Desconectado'), findsOneWidget);
    expect(find.text('Leitura desatualizada'), findsOneWidget);
  });

  testWidgets('state view supports empty states and recovery actions', (
    tester,
  ) async {
    var actionCalled = false;
    await tester.pumpWidget(
      MaterialApp(
        theme: TomathicsTheme.light(),
        home: Scaffold(
          body: TomathicsStateView(
            state: TomathicsViewState.offline,
            actionLabel: 'Tentar de novo',
            onAction: () => actionCalled = true,
          ),
        ),
      ),
    );

    expect(find.text('Motor desconectado'), findsOneWidget);
    await tester.tap(find.text('Tentar de novo'));
    expect(actionCalled, isTrue);
  });

  testWidgets('message banner shows distinct tone and optional action', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: TomathicsTheme.light(),
        home: const Scaffold(
          body: TomathicsMessageBanner(
            title: 'Receita bloqueada',
            message: 'Nenhum produtor de queijo foi encontrado.',
            tone: TomathicsBannerTone.warning,
            actionLabel: 'Ver dependências',
            onAction: _noop,
          ),
        ),
      ),
    );

    expect(find.text('Receita bloqueada'), findsOneWidget);
    expect(find.text('Ver dependências'), findsOneWidget);
  });

  testWidgets('text field exposes label, hint, and validation', (tester) async {
    final formKey = GlobalKey<FormState>();
    await tester.pumpWidget(
      MaterialApp(
        theme: TomathicsTheme.dark(),
        home: Scaffold(
          body: Form(
            key: formKey,
            child: TomathicsTextField(
              label: 'Nome da receita',
              hint: 'Ex.: Fazer pão',
              required: true,
              validator: (value) =>
                  value == null || value.isEmpty ? 'Campo obrigatório' : null,
            ),
          ),
        ),
      ),
    );

    expect(find.text('Nome da receita'), findsOneWidget);
    expect(find.text('Ex.: Fazer pão'), findsOneWidget);
    expect(formKey.currentState!.validate(), isFalse);
    await tester.pump();
    expect(find.text('Campo obrigatório'), findsOneWidget);
  });

  test('icon catalog groups the core app concepts', () {
    expect(TomathicsIcons.navigation.editor, isA<IconData>());
    expect(TomathicsIcons.nodes.trigger, isA<IconData>());
    expect(TomathicsIcons.nodes.repeat, isA<IconData>());
    expect(TomathicsIcons.targets.emulator, isA<IconData>());
    expect(TomathicsIcons.resources.inventory, isA<IconData>());
  });

  testWidgets('activity and shortcut components label their information', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: TomathicsTheme.dark(),
        home: const Scaffold(
          body: Column(
            children: [
              TomathicsActivityTile(
                title: 'Pão produzido',
                detail: 'Objetivo #12 · lote 4/10',
                time: 'há 2 min',
                status: TomathicsStatus.completed,
              ),
              TomathicsShortcutHint(
                keys: ['Ctrl', 'S'],
                label: 'Salvar receita',
              ),
            ],
          ),
        ),
      ),
    );

    expect(find.text('Pão produzido'), findsOneWidget);
    expect(find.text('Salvar receita'), findsOneWidget);
    expect(find.text('Ctrl'), findsOneWidget);
    expect(find.text('S'), findsOneWidget);
  });

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

void _noop() {}

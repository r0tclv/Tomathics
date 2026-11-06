import 'package:flutter/material.dart';
import 'package:tomathics_design_system/tomathics_design_system.dart';

void main() => runApp(const TomathicsGalleryApp());

class TomathicsGalleryApp extends StatefulWidget {
  const TomathicsGalleryApp({super.key});

  @override
  State<TomathicsGalleryApp> createState() => _TomathicsGalleryAppState();
}

class _TomathicsGalleryAppState extends State<TomathicsGalleryApp> {
  ThemeMode _themeMode = ThemeMode.dark;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tomathics · Design system',
      debugShowCheckedModeBanner: false,
      theme: TomathicsTheme.light(),
      darkTheme: TomathicsTheme.dark(),
      themeMode: _themeMode,
      home: GalleryPage(
        isDark: _themeMode == ThemeMode.dark,
        onThemeChanged: (dark) => setState(
          () => _themeMode = dark ? ThemeMode.dark : ThemeMode.light,
        ),
      ),
    );
  }
}

class GalleryPage extends StatelessWidget {
  const GalleryPage({
    required this.isDark,
    required this.onThemeChanged,
    super.key,
  });

  final bool isDark;
  final ValueChanged<bool> onThemeChanged;

  @override
  Widget build(BuildContext context) {
    final palette = Theme.of(context).colorScheme;
    final width = MediaQuery.sizeOf(context).width;
    return Scaffold(
      body: Row(
        children: [
          if (width >= 900) _Sidebar(isDark: isDark),
          Expanded(
            child: Column(
              children: [
                _TopBar(isDark: isDark, onThemeChanged: onThemeChanged),
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.all(width < 600 ? 16 : 32),
                    child: Center(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 1120),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _PageHeading(isDark: isDark),
                            const SizedBox(height: 32),
                            _Section(
                              title: 'Cores e estados',
                              subtitle:
                                  'Uma linguagem visual para ler o sistema de relance.',
                              child: const _ColorSamples(),
                            ),
                            const SizedBox(height: 24),
                            const _Section(
                              title: 'Editor de fluxo',
                              subtitle:
                                  'Canvas com grade e conexões para o mapa de dependências.',
                              child: _FlowSamples(),
                            ),
                            const SizedBox(height: 24),
                            _Section(
                              title: 'Hierarquia tipográfica',
                              subtitle:
                                  'Sans-serif nativa para interface; monoespaçada para dados.',
                              child: const _TypeSamples(),
                            ),
                            const SizedBox(height: 24),
                            _Section(
                              title: 'Componentes de produto',
                              subtitle:
                                  'Receitas, grafo de automação e progresso de objetivos.',
                              child: LayoutBuilder(
                                builder: (context, constraints) {
                                  if (constraints.maxWidth < 700) {
                                    return const Column(
                                      children: [
                                        _ProductSamples(),
                                        SizedBox(height: 16),
                                        _RecipeSamples(),
                                      ],
                                    );
                                  }
                                  return const Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Expanded(child: _ProductSamples()),
                                      SizedBox(width: 16),
                                      Expanded(child: _RecipeSamples()),
                                    ],
                                  );
                                },
                              ),
                            ),
                            const SizedBox(height: 24),
                            _Section(
                              title: 'Ações e superfícies',
                              subtitle:
                                  'Ações principais, secundárias e estados de feedback.',
                              child: const _ActionSamples(),
                            ),
                            const SizedBox(height: 24),
                            Text(
                              'TOMATHICS  /  DESIGN SYSTEM  /  V0.1',
                              style: Theme.of(context).textTheme.labelSmall
                                  ?.copyWith(color: palette.onSurfaceVariant),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Sidebar extends StatelessWidget {
  const _Sidebar({required this.isDark});

  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final palette = Theme.of(context).colorScheme;
    return Container(
      width: 236,
      decoration: BoxDecoration(
        color: palette.surface,
        border: Border(right: BorderSide(color: palette.outlineVariant)),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: palette.primary,
                  borderRadius: TomathicsRadius.mdAll,
                ),
                child: Icon(
                  Icons.account_tree_rounded,
                  size: 20,
                  color: palette.onPrimary,
                ),
              ),
              const SizedBox(width: 10),
              Text('tomathics', style: Theme.of(context).textTheme.titleMedium),
            ],
          ),
          const SizedBox(height: 36),
          _NavItem(
            icon: Icons.dashboard_outlined,
            label: 'Visão geral',
            selected: true,
          ),
          const _NavItem(icon: Icons.hub_outlined, label: 'Editor de nós'),
          const _NavItem(icon: Icons.account_tree_outlined, label: 'Receitas'),
          const _NavItem(icon: Icons.monitor_heart_outlined, label: 'Monitor'),
          const _NavItem(icon: Icons.bolt_outlined, label: 'Rotinas'),
          const Spacer(),
          Text(
            isDark ? 'DARK MODE' : 'LIGHT MODE',
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: palette.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Editor visual de automações',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: palette.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.icon,
    required this.label,
    this.selected = false,
  });

  final IconData icon;
  final String label;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    final palette = Theme.of(context).colorScheme;
    return Container(
      margin: const EdgeInsets.only(bottom: 4),
      decoration: BoxDecoration(
        color: selected ? palette.primaryContainer : Colors.transparent,
        borderRadius: TomathicsRadius.smAll,
      ),
      child: ListTile(
        dense: true,
        leading: Icon(
          icon,
          size: 19,
          color: selected ? palette.primary : palette.onSurfaceVariant,
        ),
        title: Text(
          label,
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
            color: selected ? palette.primary : palette.onSurface,
          ),
        ),
      ),
    );
  }
}

class _TopBar extends StatelessWidget {
  const _TopBar({required this.isDark, required this.onThemeChanged});

  final bool isDark;
  final ValueChanged<bool> onThemeChanged;

  @override
  Widget build(BuildContext context) {
    final palette = Theme.of(context).colorScheme;
    return Container(
      height: 64,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      decoration: BoxDecoration(
        color: palette.surface,
        border: Border(bottom: BorderSide(color: palette.outlineVariant)),
      ),
      child: Row(
        children: [
          Icon(Icons.grid_view_rounded, size: 18, color: palette.primary),
          const SizedBox(width: 10),
          Text(
            'Design system',
            style: Theme.of(context).textTheme.titleSmall,
          ),
          const Spacer(),
          Text(
            'TEMA',
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: palette.onSurfaceVariant,
            ),
          ),
          const SizedBox(width: 8),
          Icon(
            isDark ? Icons.dark_mode_outlined : Icons.light_mode_outlined,
            size: 18,
            color: palette.onSurfaceVariant,
          ),
          Switch(value: isDark, onChanged: onThemeChanged),
        ],
      ),
    );
  }
}

class _PageHeading extends StatelessWidget {
  const _PageHeading({required this.isDark});

  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final palette = Theme.of(context).colorScheme;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'SISTEMA DE DESIGN  /  2026',
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: palette.secondary,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Construa fluxos.\nEnxergue o sistema.',
                style: Theme.of(context).textTheme.headlineLarge,
              ),
              const SizedBox(height: 8),
              Text(
                'Uma linguagem visual para transformar automações em algo claro, observável e seu.',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: palette.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
        if (MediaQuery.sizeOf(context).width >= 600)
          _CanvasMotif(isDark: isDark),
      ],
    );
  }
}

class _CanvasMotif extends StatelessWidget {
  const _CanvasMotif({required this.isDark});

  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final palette = Theme.of(context).colorScheme;
    final semantic = TomathicsTheme.semantic(context);
    return Container(
      width: 190,
      height: 110,
      margin: const EdgeInsets.only(left: 20),
      decoration: BoxDecoration(
        color: palette.surface,
        borderRadius: TomathicsRadius.lgAll,
        border: Border.all(color: palette.outlineVariant),
      ),
      child: CustomPaint(
        painter: _MiniGraphPainter(
          grid: semantic.canvasGrid,
          connector: palette.secondary,
          nodeA: palette.primary,
          nodeB: semantic.nodeAction,
          nodeC: semantic.nodeCondition,
        ),
        child: Center(
          child: Icon(
            Icons.account_tree_rounded,
            color: palette.onSurface.withValues(alpha: 0.1),
            size: 42,
          ),
        ),
      ),
    );
  }
}

class _MiniGraphPainter extends CustomPainter {
  const _MiniGraphPainter({
    required this.grid,
    required this.connector,
    required this.nodeA,
    required this.nodeB,
    required this.nodeC,
  });

  final Color grid;
  final Color connector;
  final Color nodeA;
  final Color nodeB;
  final Color nodeC;

  @override
  void paint(Canvas canvas, Size size) {
    final gridPaint = Paint()
      ..color = grid
      ..strokeWidth = 1;
    for (double x = 12; x < size.width; x += 16) {
      for (double y = 12; y < size.height; y += 16) {
        canvas.drawCircle(Offset(x, y), 1, gridPaint);
      }
    }
    final line = Paint()
      ..color = connector
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;
    final path = Path()
      ..moveTo(48, 38)
      ..cubicTo(80, 38, 72, 72, 105, 72)
      ..cubicTo(130, 72, 124, 42, 150, 42);
    canvas.drawPath(path, line);
    for (final (x, y, color) in <(double, double, Color)>[
      (48, 38, nodeA),
      (105, 72, nodeB),
      (150, 42, nodeC),
    ]) {
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromCenter(center: Offset(x, y), width: 30, height: 24),
          const Radius.circular(6),
        ),
        Paint()..color = color,
      );
      canvas.drawCircle(
        Offset(x + 15, y),
        3,
        Paint()
          ..color = color
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.5,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _MiniGraphPainter oldDelegate) =>
      grid != oldDelegate.grid ||
      connector != oldDelegate.connector ||
      nodeA != oldDelegate.nodeA ||
      nodeB != oldDelegate.nodeB ||
      nodeC != oldDelegate.nodeC;
}

class _Section extends StatelessWidget {
  const _Section({
    required this.title,
    required this.subtitle,
    required this.child,
  });

  final String title;
  final String subtitle;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 4),
        Text(
          subtitle,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 16),
        child,
      ],
    );
  }
}

class _ColorSamples extends StatelessWidget {
  const _ColorSamples();

  @override
  Widget build(BuildContext context) {
    final palette = Theme.of(context).colorScheme;
    final semantic = TomathicsTheme.semantic(context);
    final samples = <(String, Color)>[
      ('Primária', palette.primary),
      ('Ciano', palette.secondary),
      ('Concluído', semantic.success),
      ('Atenção', semantic.warning),
      ('Falha', semantic.danger),
      ('Cena', semantic.nodeScene),
      ('Condição', semantic.nodeCondition),
      ('Ação', semantic.nodeAction),
      ('Espera', semantic.nodeWait),
    ];
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: [
        for (final (label, color) in samples)
          Container(
            width: 112,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: palette.surface,
              borderRadius: TomathicsRadius.mdAll,
              border: Border.all(color: palette.outlineVariant),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 32,
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: TomathicsRadius.smAll,
                  ),
                ),
                const SizedBox(height: 8),
                Text(label, style: Theme.of(context).textTheme.labelMedium),
                Text(
                  '#${color.toARGB32().toRadixString(16).substring(2).toUpperCase()}',
                  style: TomathicsTypography.code.copyWith(
                    fontSize: 10,
                    color: palette.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

class _TypeSamples extends StatelessWidget {
  const _TypeSamples();

  @override
  Widget build(BuildContext context) {
    final palette = Theme.of(context).colorScheme;
    return TomathicsPanel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Display · 36 / 700', style: Theme.of(context).textTheme.displayLarge),
          Text(
            'Headline · 24 / 650',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          Text('Título · 18 / 600', style: Theme.of(context).textTheme.titleLarge),
          Text(
            'Texto de leitura · 14 / 400',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: palette.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'OBJETIVO #12  ·  10/30  ·  00:03:20',
            style: TomathicsTypography.code.copyWith(color: palette.secondary),
          ),
        ],
      ),
    );
  }
}

class _ProductSamples extends StatelessWidget {
  const _ProductSamples();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ObjectiveProgressCard(
          title: 'Objetivo · 10 sanduíches',
          completed: 4,
          total: 10,
          estimate: '~ 12 min',
          lastRead: 'Última leitura da tela há 40 s',
          status: TomathicsStatus.running,
        ),
      ],
    );
  }
}

class _FlowSamples extends StatelessWidget {
  const _FlowSamples();

  @override
  Widget build(BuildContext context) {
    return TomathicsPanel(
      padding: EdgeInsets.zero,
      child: ClipRRect(
        borderRadius: TomathicsRadius.lgAll,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: AutomationCanvas(
            width: 820,
            height: 190,
            connections: const [
              AutomationCanvasConnection(from: 'scan', to: 'check'),
              AutomationCanvasConnection(from: 'check', to: 'bake'),
            ],
            nodes: const [
              AutomationCanvasNode(
                id: 'scan',
                position: Offset(24, 46),
                child: AutomationNodeCard(
                  title: 'Ler estoque',
                  subtitle: 'Capturar tela',
                  kind: AutomationNodeKind.scene,
                  hasInput: false,
                ),
              ),
              AutomationCanvasNode(
                id: 'check',
                position: Offset(290, 20),
                child: AutomationNodeCard(
                  title: 'Verificar trigo',
                  subtitle: 'Estoque ≥ 3',
                  kind: AutomationNodeKind.condition,
                  selected: true,
                ),
              ),
              AutomationCanvasNode(
                id: 'bake',
                position: Offset(556, 46),
                child: AutomationNodeCard(
                  title: 'Produzir pão',
                  subtitle: 'Padaria · ×10',
                  kind: AutomationNodeKind.action,
                  status: TomathicsStatus.running,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RecipeSamples extends StatelessWidget {
  const _RecipeSamples();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        RecipeContractCard(
          title: 'Fazer pão',
          location: 'Alvo: Hay Day · Padaria',
          consumes: const ['3 × Trigo', '1 vaga na máquina'],
          produces: const ['1 × Pão'],
        ),
        const SizedBox(height: 16),
        TomathicsPanel(
          title: 'Etapas do plano',
          subtitle: 'Dependências para o objetivo atual',
          child: const Column(
            children: [
              _PlanStep(
                title: 'Colher trigo',
                detail: '30 unidades reservadas',
                status: TomathicsStatus.completed,
              ),
              _PlanStep(
                title: 'Produzir pão',
                detail: 'Padaria ocupada · 3:20',
                status: TomathicsStatus.running,
              ),
              _PlanStep(
                title: 'Montar sanduíches',
                detail: 'Aguardando pão',
                status: TomathicsStatus.waiting,
                last: true,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _PlanStep extends StatelessWidget {
  const _PlanStep({
    required this.title,
    required this.detail,
    required this.status,
    this.last = false,
  });

  final String title;
  final String detail;
  final TomathicsStatus status;
  final bool last;

  @override
  Widget build(BuildContext context) {
    final palette = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(
            last ? Icons.subdirectory_arrow_right_rounded : Icons.route_rounded,
            size: 16,
            color: palette.onSurfaceVariant,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: Theme.of(context).textTheme.labelLarge),
                Text(
                  detail,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: palette.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          TomathicsStatusBadge(status: status, compact: true),
        ],
      ),
    );
  }
}

class _ActionSamples extends StatelessWidget {
  const _ActionSamples();

  @override
  Widget build(BuildContext context) {
    final palette = Theme.of(context).colorScheme;
    return TomathicsPanel(
      child: Wrap(
        spacing: 12,
        runSpacing: 12,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          const TomathicsButton(
            label: 'Novo objetivo',
            icon: Icons.add_rounded,
            onPressed: _noop,
          ),
          const TomathicsButton(
            label: 'Pré-visualizar plano',
            variant: TomathicsButtonVariant.outline,
            icon: Icons.account_tree_outlined,
            onPressed: _noop,
          ),
          const TomathicsButton(
            label: 'Pausar rotina',
            variant: TomathicsButtonVariant.quiet,
            icon: Icons.pause_rounded,
            onPressed: _noop,
          ),
          const TomathicsButton(
            label: 'Cancelar',
            variant: TomathicsButtonVariant.danger,
            icon: Icons.stop_rounded,
            onPressed: _noop,
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: palette.surfaceContainerLow,
              borderRadius: TomathicsRadius.smAll,
            ),
            child: Text(
              'Foco · contorno visível',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
        ],
      ),
    );
  }
}

void _noop() {}

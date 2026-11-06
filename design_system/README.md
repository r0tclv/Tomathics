# Tomathics Design System

Pacote Flutter independente com tokens, temas claro/escuro e componentes
reutilizáveis para o editor visual, as receitas, os alvos e o monitor de
objetivos. `example/` é uma galeria executável e um catálogo de estados e
padrões da interface, não apenas uma tela de demonstração.

## Abrir a galeria

```powershell
cd example
flutter pub get
flutter run
```

O seletor no canto superior alterna entre os temas. A galeria também inclui
ícones agrupados, todos os tipos de nó, estados de execução, formulários,
controles interativos, estados vazio/erro/offline, métricas e exemplos
executáveis de diálogo, snackbar e painel inferior. A navegação **Login (demo)**
abre uma tela de acesso visual com exemplos de senha incorreta, Caps Lock e
campos vazios; nenhum dado é autenticado e o botão **Entrar** retorna à galeria.

## Usar no app

Adicione o pacote local ao `pubspec.yaml` do app:

```yaml
dependencies:
  tomathics_design_system:
    path: ../design_system
```

Configure ambos os temas no `MaterialApp`:

```dart
MaterialApp(
  theme: TomathicsTheme.light(),
  darkTheme: TomathicsTheme.dark(),
  themeMode: ThemeMode.system,
  home: const MyAppHome(),
)
```

Importe `package:tomathics_design_system/tomathics_design_system.dart`.

## Fundamentos visuais

- **Marca:** azul-violeta para ações e seleção; ciano para conexões e atividade.
- **Modos:** dark-first para o editor, sem deixar o modo claro como cidadão de
  segunda classe.
- **Estados:** sucesso, atenção, falha, informação e espera usam cor, ícone e
  rótulo, não cor isolada.
- **Grafo:** nós de cena, condição, ação, espera e fluxo têm cores próprias;
  use-as consistentemente no editor e no mapa de dependências.
- **Tipografia:** hierarquia sans-serif nativa; valores, IDs e tempos podem usar
  `TomathicsTypography.code` para alinhamento tabular.
- **Ritmo e forma:** escala de espaçamento em múltiplos de 4 px e cantos de 8 a
  20 px; use os tokens em vez de números soltos.
- **Acessibilidade:** mantenha rótulos visíveis, contraste e foco de teclado;
  não comunique estados somente pela cor.

## Tokens

| Grupo | API |
|---|---|
| Cores de marca e superfície | `TomathicsColors.light`, `.dark` |
| Estados e cores do grafo | `TomathicsSemanticColors` |
| Temas Material 3 | `TomathicsTheme.light()`, `.dark()` |
| Tipografia | `TomathicsTypography` |
| Espaçamento | `TomathicsSpacing` |
| Raios | `TomathicsRadius` |
| Movimento | `TomathicsDurations` |
| Ícones semânticos | `TomathicsIcons.navigation`, `.nodes`, `.states`, `.actions`, `.targets`, `.resources` |
| Breakpoints e larguras | `TomathicsLayout` |
| Elevação | `TomathicsElevation` |

## Catálogo de componentes

| Componente | Para usar em |
|---|---|
| `TomathicsButton` | Ações primárias, secundárias, discretas e destrutivas |
| `TomathicsTextField` | Formulários, validação e busca |
| `TomathicsPanel` | Painéis do inspetor, biblioteca e monitor |
| `TomathicsStatusBadge` | Estado textual e visual de execução/conexão |
| `TomathicsMessageBanner` | Avisos, sucesso, atenção e falha com ação opcional |
| `TomathicsStateView` | Carregando, vazio, sem resultado, erro, offline e permissão |
| `TomathicsSkeleton` | Placeholder para dados em carregamento |
| `TomathicsMetricCard` | Resumos e indicadores operacionais |
| `TomathicsActivityTile` | Histórico de execução, eventos e leituras |
| `TomathicsShortcutHint` | Teclas de atalho do editor desktop |
| `AutomationNodeCard` | Gatilhos, cenas, observação, condições, ações, espera e repetição |
| `AutomationCanvas` | Grade do editor e conectores entre nós |
| `RecipeContractCard` | Insumos e produtos de uma receita |
| `ObjectiveProgressCard` | Progresso, estimativa e idade da leitura do objetivo |

## Cobertura visual na galeria

- Navegação, variáveis tipográficas, paletas claro/escuro e cores semânticas.
- Estados de motor: execução, conclusão, espera, pausa, atenção, falha,
  inatividade, bloqueio, desconexão e leitura desatualizada.
- Estados de tela: carregamento, vazio, busca sem resultado, erro, offline e
  permissão necessária.
- Nós do fluxo, mapa conectado, contratos, dependências, métricas, skeletons,
  formulários, filtros, chips, segmented buttons, checkbox, switch e slider.
- AlertDialog, snackbar acionável e bottom sheet.
- Tabela desktop para biblioteca, feed de atividade e atalhos de teclado.

Todos os componentes são exemplos iniciais de comportamento visual: conecte-os
às regras e aos dados reais da aplicação, sem duplicar cores, status ou estilos
na camada de telas.

O pacote não baixa fontes nem ícones externos: mantém o build independente e
usa os ícones Material incluídos no Flutter.

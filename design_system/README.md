# Tomathics Design System

Pacote Flutter independente com tokens, temas claro/escuro e componentes
iniciais para o editor visual, as receitas e o monitor de objetivos.

## Abrir a galeria

```powershell
cd example
flutter pub get
flutter run
```

O seletor no canto superior alterna entre os temas. A galeria demonstra cores,
estados semânticos, tipografia, cartões de nós, contratos de receitas,
progresso e ações.

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

O pacote não baixa fontes nem ícones externos: mantém o build independente e
usa os ícones Material incluídos no Flutter.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:tomathics_design_system_gallery/main.dart';

void main() {
  testWidgets('gallery presents the Tomathics design language', (tester) async {
    await tester.pumpWidget(const TomathicsGalleryApp());

    expect(find.text('Design system'), findsOneWidget);
    expect(find.text('SISTEMA DE DESIGN  /  2026'), findsOneWidget);
    expect(find.text('Editor de fluxo'), findsOneWidget);
    expect(find.byIcon(Icons.dark_mode_outlined), findsOneWidget);
    expect(
      Theme.of(tester.element(find.byType(GalleryPage))).brightness,
      Brightness.dark,
    );
    expect(tester.takeException(), isNull);
    await tester.tap(find.byKey(const ValueKey('theme-mode-switch')));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.byIcon(Icons.light_mode_outlined), findsOneWidget);
    expect(
      Theme.of(tester.element(find.byType(GalleryPage))).brightness,
      Brightness.light,
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('gallery remains usable at a mobile width', (tester) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const TomathicsGalleryApp());

    expect(find.text('Construa fluxos.\nEnxergue o sistema.'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('login demo previews states and enters without validation', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const TomathicsGalleryApp());
    await tester.tap(find.byKey(const ValueKey('open-login-demo')));
    await tester.pumpAndSettle();

    expect(find.text('Acesse seu workspace'), findsOneWidget);
    expect(
      find.text('Demonstração visual: nenhuma credencial é validada.'),
      findsOneWidget,
    );
    expect(tester.takeException(), isNull);

    await tester.ensureVisible(
      find.byKey(const ValueKey('login-preview-incorrect')),
    );
    await tester.tap(find.byKey(const ValueKey('login-preview-incorrect')));
    await tester.pumpAndSettle();
    expect(find.text('Senha incorreta.'), findsOneWidget);
    expect(find.text('Não foi possível entrar'), findsOneWidget);
    expect(tester.takeException(), isNull);

    await tester.ensureVisible(
      find.byKey(const ValueKey('login-preview-capslock')),
    );
    await tester.tap(find.byKey(const ValueKey('login-preview-capslock')));
    await tester.pumpAndSettle();
    expect(find.text('Caps Lock ativado'), findsOneWidget);
    expect(tester.takeException(), isNull);

    await tester.ensureVisible(find.byKey(const ValueKey('login-demo-submit')));
    await tester.tap(find.byKey(const ValueKey('login-demo-submit')));
    await tester.pump();
    expect(find.text('Design system'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('login demo renders on the desktop layout', (tester) async {
    tester.view.physicalSize = const Size(1440, 900);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const TomathicsGalleryApp());
    await tester.tap(find.text('Login (demo)'));
    await tester.pump();

    expect(find.text('Seu próximo fluxo começa aqui.'), findsOneWidget);
    expect(find.text('Acesse seu workspace'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}

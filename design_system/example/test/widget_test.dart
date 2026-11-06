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
}

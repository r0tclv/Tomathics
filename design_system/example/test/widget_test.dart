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

    await tester.tap(find.byType(Switch));
    await tester.pumpAndSettle();

    expect(find.byIcon(Icons.light_mode_outlined), findsOneWidget);
    expect(
      Theme.of(tester.element(find.byType(GalleryPage))).brightness,
      Brightness.light,
    );
    expect(tester.takeException(), isNull);
  });
}

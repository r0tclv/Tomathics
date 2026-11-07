Tomathics
=========

O pacote Flutter de design system e sua galeria estão em:
design_system/

O mock em memória e seu contrato inicial estão em:
mock_backend/

Consulte design_system/README.md para instalar o pacote no app, usar os tokens
e executar a galeria com Flutter. A galeria permite alternar entre tema claro
e escuro e mostra componentes de receitas, objetivos e editor visual, além de
uma tela de Login demonstrativa sem autenticação.

Consulte mock_backend/README.md para os limites, exemplos e validação do mock.
Este pacote é uma biblioteca Dart em memória, não um servidor HTTP:

  cd mock_backend
  flutter pub get
  flutter test
  flutter analyze

Para abrir a galeria:

  cd design_system/example
  flutter pub get
  flutter run

Para validar:

  cd design_system
  flutter test
  flutter analyze
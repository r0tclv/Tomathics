# Tomathics Design System Gallery

Aplicação de demonstração e catálogo visual do pacote
`tomathics_design_system`.

```powershell
Set-Location 'C:\dev\Tomathics\design_system\example'
flutter pub get
flutter run -d chrome
```

## Conteúdo da demonstração

A galeria permite alternar entre os temas claro e escuro e consultar tokens,
componentes, iconografia, exemplos de nós/conexões, estados de execução,
formulários, controles, métricas, atividades, tabelas, atalhos, diálogos e
notificações.

A navegação **Login (demo)** abre uma tela responsiva com exemplos visuais de
senha incorreta, Caps Lock e campos vazios. Os estados são selecionados na
própria demonstração; não há validação de credenciais nem detecção real de Caps
Lock. **Entrar** retorna à galeria. A tela não cria sessão e não representa
autenticação do produto.

Esta aplicação é um catálogo visual do pacote, não um app de produto conectado
a backend.

Para revisar o pacote e esta galeria:

```powershell
Set-Location 'C:\dev\Tomathics\design_system\example'
flutter test
flutter analyze
```

Os testes também verificam a apresentação da galeria, alternância de tema, uso
em largura mobile, os estados do Login demo, retorno sem validação e layout
desktop.

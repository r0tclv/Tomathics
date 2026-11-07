# Tomathics Mock Backend

Pacote Dart independente com um mock em memória para iniciar o desenvolvimento
das telas do Tomathics. Não é um servidor HTTP, não persiste dados e não executa
automações reais. O pacote ainda não está conectado à galeria do Design System.

## Executar testes

```powershell
Set-Location 'C:\dev\Tomathics\mock_backend'
flutter pub get
flutter analyze
flutter test
```

## Uso inicial

```dart
import 'package:tomathics_mock_backend/tomathics_mock_backend.dart';

final repository = InMemoryTomathicsRepository();
final page = await repository.listRecipes();
final session = await repository.signInDemo();
```

O mock disponibiliza uma implementação em memória de
`TomathicsRepository`, com:

- receitas iniciais genéricas, busca e paginação `offset`/`limit`;
- criar, consultar, substituir campos editáveis, duplicar, arquivar e restaurar;
- grafo serializável com nós, conexões, posições e configuração discriminada
  pelo tipo;
- validação estrutural básica e erros com `statusCode`, `code`, `message` e
  `fieldErrors`;
- cenários automáticos de execução `success`, `failure` e `waiting`, eventos
  pagináveis e cancelamento;
- sessão fixa de demonstração, sem validar credenciais;
- `reset()` para repor os dados iniciais e `dispose()` para parar timers.

Exemplo de execução:

```dart
final recipe = page.data.first;
final execution = await repository.startExecution(
  recipe.id,
  scenario: ExecutionScenario.success,
);
final current = await repository.getExecution(execution.id);
final events = await repository.listExecutionEvents(execution.id);
```

As transições de execução avançam automaticamente no intervalo configurado
por `executionTickInterval` (900 ms por padrão). O cenário é selecionado ao
chamar `startExecution`. Leia o estado com polling usando `getExecution`; os
eventos ficam disponíveis separadamente.

## Fronteira de aplicação

As telas devem depender de `TomathicsRepository`, não diretamente da classe em
memória. O mock pode então ser substituído por uma implementação HTTP que siga
o futuro contrato REST sem acoplar widgets ao transporte. Esta é a fronteira
inicial recomendada; integração com um app de produto ainda não foi feita.

## Limites e decisões provisórias

O contrato de produto continua em definição. Para tornar o mock executável,
esta primeira fundação escolhe valores provisórios e deliberadamente pequenos:

- dois exemplos de receita com um alvo genérico fictício;
- `name` e `targetId` obrigatórios; validação estrutural de IDs/conexões e
  posições finitas no grafo;
- página padrão de 20 e limite máximo de 100;
- ordenação de receitas por nome e busca textual por nome/descrição;
- atualização substitui o conjunto de campos editáveis recebido em
  `RecipeDraft`; não há edição parcial de campos;
- duplicação cria receita ativa com sufixo `(cópia)` e reutiliza o grafo;
- arquivadas não podem ser editadas ou executadas; chamadas inválidas e
  transições incompatíveis retornam conflito;
- execução percorre `queued`, `running`, `waiting` e estado terminal conforme o
  cenário; falha tem mensagem simulada;
- cenários selecionáveis implementados: sucesso, falha e espera. `paused` faz
  parte do enum do domínio, mas não é emitido automaticamente enquanto pausa e
  retomada não forem especificadas;
- `fieldErrors` é um mapa de nome de campo para lista de mensagens;
- `statusCode` guarda uma sugestão de mapeamento HTTP, mas nenhum transporte
  HTTP está implementado.

Esses defaults não fecham as decisões de produto. Em particular, configurações
específicas dos sete tipos de nó, alvos reais, ciclos do grafo, pausa/retomada,
filtros definitivos, status HTTP, forma final de `fieldErrors` e contrato
OpenAPI ainda precisam ser acordados.

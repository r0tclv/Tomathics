# Tomathics — registro do Design System e contrato do mock

**Data do registro:** 6 de novembro de 2026  
**Objetivo:** preservar o histórico do trabalho, as decisões já tomadas e as
questões ainda abertas para retomar o desenvolvimento sem confundir propostas
com requisitos confirmados.

> Este documento registra decisões e planejamento. Ele não implementa o mock,
> uma API HTTP, autenticação ou execução de automações.

## 1. Estado atual do projeto

- O Design System Flutter e sua galeria estão em `design_system/`.
- A galeria tem temas claro e escuro, exemplos dos componentes e estados
  reutilizáveis, além de uma tela de Login demonstrativa.
- Não há mock de backend implementado neste registro.
- O contrato descrito aqui é uma referência REST/JSON para o futuro. A escolha
  atual para o mock de desenvolvimento é executá-lo dentro do Flutter, sem
  servidor HTTP local.
- A tela Login (demo) da galeria é somente visual: não valida credenciais e
  retorna à galeria. A sessão fixa de demonstração mencionada adiante é uma
  decisão para o futuro mock, não uma funcionalidade existente nessa tela.

## 2. Histórico do Design System

### 2.1 Direção visual

O Design System foi criado para o Tomathics, produto de automação visual,
inspirado na temática e no layout do BotTasker, mas adaptado à identidade e aos
conceitos do próprio produto.

As escolhas visuais incluem:

- azul-violeta para marca, seleção e ações principais;
- ciano para conexões e atividade do grafo;
- cores semânticas para estados de execução, conexão e feedback;
- temas Material 3 claro e escuro, com abordagem dark-first;
- tipografia hierárquica e Material Icons, sem dependências externas de fonte
  ou ícones;
- tokens para espaçamento, raios, elevação, ícones e breakpoints.

### 2.2 Componentes e catálogo

A galeria reúne exemplos de:

- campos, botões, painéis, banners e estados de tela;
- estados de execução e conexão;
- cartões de métricas, skeletons e atividades;
- canvas, nós e conexões para o editor visual;
- controles, filtros, tabelas, diálogos, snackbars e atalhos;
- paletas, hierarquia tipográfica, escalas e layouts.

Os componentes são uma base visual para as telas futuras. Regras de negócio,
dados reais e integrações devem ser conectados pela aplicação; a galeria não
representa um backend implementado.

### 2.3 Login demonstrativo

Foi acrescentada uma entrada **Login (demo)** à galeria. A tela contém:

- campos de e-mail e senha, com controle para mostrar/ocultar a senha;
- opção visual “Manter conectado” e link demonstrativo de recuperação de senha;
- exemplos selecionáveis de estado padrão, senha incorreta, Caps Lock e campos
  vazios;
- alternância claro/escuro e retorno à galeria;
- layout responsivo para telas compactas e desktop.

Os estados são prévias visuais selecionadas na própria tela. Caps Lock não é
detectado pelo teclado. Nenhuma credencial é validada e pressionar **Entrar**
retorna à galeria.

Referências:

- [Guia do Design System](../design_system/README.md)
- [Galeria Flutter](../design_system/example/lib/main.dart)
- [Tela de Login demonstrativa](../design_system/example/lib/login_demo_page.dart)
- [Testes da galeria](../design_system/example/test/widget_test.dart)

Para executar a galeria em PowerShell:

```powershell
Set-Location 'C:\dev\Tomathics\design_system\example'
flutter run -d chrome
```

### 2.4 Validação registrada

Após adicionar o Login demonstrativo:

- `flutter analyze` na galeria passou sem problemas;
- os testes da galeria passaram em largura mobile e desktop;
- `flutter build web` concluiu com sucesso;
- hot reload da galeria concluiu com sucesso.

O build web mostrou um aviso não bloqueante referente à fonte de Cupertino Icons;
os ícones Material usados pelo Tomathics foram incluídos no build.

## 3. Decisões confirmadas para o mock e o contrato

Estas escolhas foram feitas explicitamente durante a conversa:

| Assunto | Decisão |
|---|---|
| Estilo conceitual da API futura | REST/JSON, com prefixo `/api/v1` |
| Escopo inicial do backend real | Catálogo de receitas |
| Local de execução do primeiro mock | Dentro do Flutter, em memória |
| Alvos | Genéricos por enquanto; plataformas concretas não definidas |
| Representação da receita | Um único formato canônico de grafo, com `nodes` e `edges` |
| Tipos iniciais de nó | Gatilho, cena, observação, condição, ação, espera e repetição |
| Configuração dos nós | Tipada conforme o tipo de nó; campos concretos ficam para depois |
| Extensões do grafo | Extensões opcionais podem acomodar necessidades futuras; formato ainda não definido |
| Ciclo de vida da receita | Arquivar e restaurar, preservando o histórico |
| Paginação | `offset`/`limit`, com filtros previstos |
| Erros | Formato contendo `code`, `message` e `fieldErrors` |
| Atualização do monitor | Polling por consultas periódicas |
| Histórico do monitor | Eventos consultáveis por execução, com paginação |
| Estados de execução previstos | `queued`, `running`, `waiting`, `paused`, `completed`, `failed`, `cancelled` |
| Simulação | Progressão automática e cenário selecionável no mock |
| Autenticação real | Fora do escopo atual |
| Login futuro do mock | Não validar credenciais; entrada abre uma sessão fixa de demonstração |

### Importante: mock em Flutter não é mock server HTTP

O mock escolhido inicialmente é uma implementação em memória dentro do processo
Flutter. Ele pode exercitar os fluxos de tela e imitar os comportamentos
esperados, mas não recebe requisições HTTP nem testa serialização ou transporte.

O contrato REST/JSON é uma referência para a futura API. Uma interface de
repositório foi sugerida como forma de permitir que as telas usem primeiro o
mock em memória e, no futuro, uma implementação HTTP. Essa fronteira de
arquitetura ainda precisa ser confirmada antes de implementação.

## 4. Esboço de rotas

Os métodos e caminhos abaixo são uma proposta de organização baseada nas
operações discutidas. Eles ainda não foram aprovados como uma especificação
final, não têm códigos HTTP definidos e não implicam que as rotas existam hoje.

### 4.1 Catálogo

| Operação | Rota candidata | Estado |
|---|---|---|
| Listar receitas | `GET /api/v1/recipes` | Decidida como operação; filtros ainda pendentes |
| Criar receita | `POST /api/v1/recipes` | Operação decidida; campos e validações pendentes |
| Consultar receita | `GET /api/v1/recipes/{id}` | Operação decidida |
| Editar receita | `PATCH /api/v1/recipes/{id}` | Operação decidida; regras de edição pendentes |
| Duplicar receita | `POST /api/v1/recipes/{id}/duplicate` | Operação decidida; conteúdo da cópia pendente |
| Arquivar receita | `POST /api/v1/recipes/{id}/archive` | Operação decidida |
| Restaurar receita | `POST /api/v1/recipes/{id}/restore` | Operação decidida |

Não foi definida uma operação de exclusão permanente. A orientação atual é
arquivar, mantendo a possibilidade de preservar histórico.

### 4.2 Execuções futuras ou simuladas

| Operação | Rota candidata | Estado |
|---|---|---|
| Iniciar execução | `POST /api/v1/recipes/{id}/executions` | Prevista para futuro; pode ser simulada no mock |
| Consultar execução | `GET /api/v1/executions/{id}` | Prevista para polling |
| Cancelar execução | `POST /api/v1/executions/{id}/cancel` | Prevista; regras de transição pendentes |
| Consultar eventos | `GET /api/v1/executions/{id}/events` | Prevista com paginação |

`paused` está entre os estados previstos, mas ainda não foram decididas as
operações de pausar e retomar. Definir essas operações e suas regras faz parte
do fechamento do ciclo de execução.

## 5. Modelos conceituais — não são schemas finais

Os nomes e exemplos desta seção servem para orientar as próximas decisões. Não
devem ser tratados como campos obrigatórios ou como contrato validado.

### 5.1 Receita

Campos considerados até agora:

- `id`
- `name`
- `description`
- `status`
- `targetId`
- `graph`
- timestamps de criação/alteração

Ainda não foi decidido se esses são os nomes finais, quais são obrigatórios,
quais valores `status` aceita, nem o formato ou fuso dos timestamps.

### 5.2 Grafo

O formato canônico terá coleções `nodes` e `edges`.

Um nó foi descrito conceitualmente como:

```json
{
  "id": "node-id",
  "type": "action",
  "title": "Nome exibido",
  "position": { "x": 0, "y": 0 },
  "config": {}
}
```

Uma conexão liga um nó de origem a um nó de destino, com portas opcionais:

```json
{
  "id": "edge-id",
  "source": "source-node-id",
  "target": "target-node-id",
  "sourcePort": "optional-output",
  "targetPort": "optional-input"
}
```

Os exemplos são ilustrativos. Campos, nomes, limites, nulabilidade, semântica
de portas e esquema de configuração devem ser definidos por tipo de nó.

Os tipos iniciais propostos para o grafo são:

- gatilho;
- cena;
- observação;
- condição;
- ação;
- espera;
- repetição.

O catálogo visual já pode conter convenções adicionais de ícones ou cores; isso
não significa que o payload de cada nó esteja especificado.

### 5.3 Respostas e erros

Para listagens, a convenção decidida é retornar dados e metadados de paginação,
com `offset`, `limit` e `total`. Um envelope candidato é:

```json
{
  "data": [],
  "pagination": {
    "offset": 0,
    "limit": 20,
    "total": 0
  }
}
```

O nome e a forma exata de `pagination` ainda não foram confirmados.

Erros devem conter `code`, `message` e `fieldErrors`. Ainda falta decidir se
`fieldErrors` será um mapa de campo para mensagens, uma lista de ocorrências ou
outro formato. Os status HTTP correspondentes também estão pendentes.

## 6. Comportamento esperado do mock em memória

Quando for implementado, o mock deve apoiar o desenvolvimento das telas e
oferecer comportamento previsível:

1. Fornecer dados iniciais de receitas e alvos genéricos.
2. Executar as operações de catálogo escolhidas e refletir as alterações
   durante a sessão do mock.
3. Manter as alterações apenas em memória; reiniciar o mock restaura os dados
   iniciais.
4. Abrir uma sessão fixa de demonstração sem validar e-mail ou senha.
5. Criar execuções simuladas e expor estados e eventos suficientes para o
   monitor.
6. Permitir escolher um cenário para reproduzir progressão automática, sem
   executar automações reais.
7. Representar erros de forma estruturada para as telas poderem demonstrar
   estados de falha.

Ainda não foram decididos o mecanismo de escolha dos cenários, o conjunto de
receitas de exemplo, os intervalos da progressão automática ou o formato da
identidade de demonstração.

## 7. Questões em aberto

Estas decisões ainda precisam ser tomadas antes de considerar o contrato
completo:

### Arquitetura e escopo

- Confirmar se o mock em memória é suficiente ou se será necessário um servidor
  HTTP local para testar requisições de verdade.
- Confirmar se as telas dependem de uma interface de repositório, para que o
  mock e uma futura API HTTP possam ser trocados sem alterar a UI.
- Decidir se e quando será produzida uma especificação OpenAPI. Ela foi
  recomendada, mas ainda não foi escolhida formalmente.

### Receitas, alvos e grafo

- Campos obrigatórios/opcionais, limites e valores de status da receita.
- Quais plataformas concretas existirão e quais dados formam um alvo genérico.
- Campos de configuração, entradas e saídas de cada tipo de nó.
- Formato, finalidade e validação das extensões opcionais.
- Validação de conexões, portas, referências a nós inexistentes, ciclos e nós
  desconectados.
- Filtros, ordenação e valores padrão da listagem.
- Quais campos e referências são incluídos ao duplicar uma receita.
- Se receitas arquivadas podem ser editadas ou duplicadas e como o histórico se
  comporta ao arquivar/restaurar.

### Execuções e monitor

- Transições válidas entre os estados de execução.
- Como pausar e retomar, incluindo operações/rotas e limites por estado.
- Quando cancelar é permitido e qual estado final representa cancelamento.
- Formato, ordenação e paginação dos eventos.
- Intervalo do polling e critério para interrompê-lo.
- Cenários selecionáveis, como sucesso, falha e espera, e como selecioná-los.
- Duração/intervalos da progressão automática e como reiniciar uma simulação.

### Sessão, respostas e erros

- Conteúdo da identidade fixa de demonstração, expiração e encerramento da
  sessão simulada.
- Status HTTP para sucesso, criação, validação, ausência de recurso e conflitos.
- Envelope exato para listagens e demais sucessos.
- Estrutura exata de `fieldErrors` e convenção para erros não associados a um
  campo.
- Convenções de data/hora, identificadores e ordenação estável.

## 8. Próxima sequência recomendada

Para evitar especificar configurações imaginárias, a próxima etapa deve começar
pelos fluxos do produto:

1. Escolher os primeiros alvos/plataformas ou confirmar que o primeiro ciclo
   será inteiramente genérico.
2. Descrever alguns fluxos reais que uma receita deve representar.
3. Derivar desses fluxos os dados de cada tipo de nó, incluindo entradas,
   saídas e validações.
4. Fechar os modelos de receita, alvo, grafo, execução e evento.
5. Definir as transições e os cenários reproduzíveis do mock, incluindo pausa e
   retomada.
6. Fechar paginação, filtros, ordenação, envelopes, erros e status HTTP.
7. Confirmar a fronteira entre mock em memória e repositório da aplicação.
8. Só então escrever a especificação final do contrato, com exemplos de
   sucesso, falha e cenários do monitor.

Ao retomar, preservar as decisões da seção 3. Os itens da seção 7 são pendências
reais; não devem ser preenchidos silenciosamente por suposição.

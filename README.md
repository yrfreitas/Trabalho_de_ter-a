# Entrega 1 — Modelo Conceitual (DER)
### Modelagem de um sistema de gestão de informações para uma organização de pequeno porte

---

# Modelagem de Banco de Dados para a JG Construções

> **Antes de entregar:** preencha as partes marcadas com *(preencher)* — são os dados que só quem fez a visita de campo tem (endereço, fotos, contato).

## Introdução

A JG Construções é uma empresa de reformas e pequenas obras que atende clientes pessoa física e jurídica, do orçamento inicial até a entrega da obra concluída. Antes de qualquer sistema, o controle de orçamentos, obras em andamento, equipe alocada e compra de material era feito de forma manual, sem um cadastro único que ligasse essas informações.

O objetivo deste trabalho é levantar os processos reais da organização e propor um modelo conceitual de banco de dados capaz de sustentar essa operação: do primeiro orçamento pedido por um cliente até o pagamento da última etapa da obra, passando por quem trabalhou nela e qual material foi comprado para executá-la.

A delimitação desta primeira entrega é o **núcleo do ciclo orçamento → obra**: cadastro de cliente, orçamento de serviços, execução da obra com equipe alocada, compra de material junto a fornecedores e controle de pagamento por etapa.

## Desenvolvimento

### Caracterização da Organização
*(vale 7,5% — Dimensão Conceitual)*

- **Nome e natureza da organização:** JG Construções — empresa privada com fins lucrativos, do ramo de reformas e construção civil de pequeno porte.
- **Contexto e porte:** *(preencher: quantos funcionários/prestadores fixos, quantas obras costuma ter em andamento ao mesmo tempo, área de atuação — bairro, cidade, região)*
- **Problemas e necessidades identificados:** antes do sistema proposto, orçamentos, obras, alocação de equipe e compra de material eram controlados de forma manual/dispersa, sem um cadastro único de clientes nem histórico organizado de qual funcionário trabalhou em qual obra, ou quanto foi gasto em material por obra.
- **Justificativa da escolha:** a organização foi escolhida porque o grupo tem acesso direto para levantamento de requisitos e verificação das regras de negócio com quem de fato administra a empresa.
- **Evidências da organização:**
  *(preencher: foto do local/de uma obra em andamento, link do Google Meu Negócio ou rede social da empresa, endereço completo e telefone/e-mail de contato do responsável)*

---

### Processos de Negócio
*(vale 10% — Dimensão Procedimental)*

**Principais processos mapeados:**

1. **Cadastro de cliente** — nome, CPF/CNPJ, telefone, e-mail e endereço.
2. **Orçamento** — a partir de um catálogo de serviços (com valor de referência), monta-se um orçamento para o cliente, item a item, com validade e valor total.
3. **Abertura da obra** — orçamento aprovado pelo cliente vira uma obra: endereço da obra, escopo, data de início/fim previstas.
4. **Alocação de equipe** — funcionários (fixos ou por vínculo temporário) são alocados na obra, cada um com sua função e período de atuação.
5. **Compra de material** — a obra gera compras de material junto a fornecedores, item a item, para execução dos serviços orçados.
6. **Execução dos serviços da obra** — cada serviço do orçamento é executado na obra, com quantidade executada e status próprio (pode divergir do que foi orçado).
7. **Pagamento por etapa** — o cliente paga a obra em etapas, cada uma com valor, forma de pagamento e status.

**Fluxogramas:**
*(anexar imagem — ver seção de anexos do repositório)*

Fluxo principal, em texto, para orientar o desenho do fluxograma:

```
Cliente pede orçamento
   → Orçamento é montado (itens do catálogo de serviços, com valor)
      → Cliente aprova o orçamento
         → Obra é aberta (endereço, escopo, prazo)
            ├─ Equipe é alocada na obra (funcionário + função + período)
            ├─ Material é comprado de fornecedor(es) para a obra
            ├─ Serviços orçados são executados na obra
            └─ Pagamento é recebido por etapa, até a conclusão
```

---

### Requisitos do Sistema
*(esta seção e a Seção 4 "Regras de Negócio" DIVIDEM 7,5% na dimensão conceitual — juntas valem 7,5%, não 7,5% cada — + 4% exclusivos desta seção na organização/documentação)*

#### Requisitos Funcionais

- O sistema deve permitir cadastrar um cliente com dados de contato e endereço.
- O sistema deve permitir montar um orçamento para um cliente, com um ou mais itens de serviço, cada um com quantidade e valor.
- O sistema deve permitir transformar um orçamento aprovado em uma obra.
- O sistema deve permitir alocar um ou mais funcionários a uma obra, registrando função e período de atuação.
- O sistema deve permitir registrar compras de material feitas para uma obra, associadas a um fornecedor.
- O sistema deve permitir registrar a execução de cada serviço orçado dentro da obra.
- O sistema deve permitir registrar pagamentos recebidos por etapa de uma obra.
- O sistema deve permitir consultar o histórico de obras e orçamentos de um cliente.
- O sistema deve permitir consultar quais funcionários trabalharam em qual obra.

#### Requisitos Não Funcionais

- **Integridade:** um orçamento não deve poder virar obra sem ter ao menos um item orçado.
- **Rastreabilidade:** toda compra de material deve manter o vínculo com o fornecedor e com a obra que a originou, para conferência de custo por obra.
- **Consistência financeira:** a soma dos pagamentos de uma obra deve poder ser confrontada com o valor total do orçamento que a originou.
- **Usabilidade:** o cadastro de uma nova obra a partir de um orçamento já aprovado não deve exigir redigitar os dados do cliente ou dos serviços.

---

### Regras de Negócio
*(esta seção DIVIDE com a Seção 3 "Requisitos do Sistema" os mesmos 7,5% da dimensão conceitual — juntas valem 7,5%, não 7,5% cada — + 4% exclusivos desta seção na documentação)*

- **Regras operacionais:**
  - Uma obra só pode ser aberta a partir de um orçamento aprovado pelo cliente (status do orçamento precisa refletir essa aprovação).
  - Um pagamento é sempre vinculado a uma obra específica e a uma etapa (número da etapa) — não existe pagamento solto, sem obra.
  - Uma compra de material só é registrada vinculada a uma obra e a um fornecedor — não existe compra "genérica" sem saber para qual obra foi.
  - Um funcionário só pode ser alocado a uma obra dentro do período em que seu vínculo com a empresa está ativo.
- **Restrições organizacionais:**
  - Fornecedor precisa ter CNPJ único cadastrado — evita duplicidade de cadastro do mesmo fornecedor.
  - Cliente precisa ter CPF/CNPJ único — mesma lógica, evita cliente duplicado.
  - Serviços têm valor de referência no catálogo, mas o valor efetivamente cobrado no orçamento pode ser diferente (negociação) — por isso o valor mora no item do orçamento, não só no catálogo.

---

### Dicionário de Dados Conceitual (Preliminar)
*(vale 10% — Dimensão Procedimental)*

**Entidade: Cliente**

| Atributo | Tipo | Descrição | Regra de negócio associada |
|----------|------|-----------|------------------------------|
| id_cliente | PK | Identificador único do cliente | Obrigatório, gerado pelo sistema |
| nome | Atributo | Nome completo ou razão social | Obrigatório |
| tipo_pessoa | Atributo | Pessoa física ou jurídica | Obrigatório; define se usa CPF ou CNPJ |
| cpf_cnpj | Atributo | Documento de identificação (fictício nos exemplos) | Obrigatório, único |
| telefone | Atributo | Telefone de contato | Obrigatório |
| email | Atributo | E-mail de contato | Opcional |
| endereço | Atributo | Endereço do cliente | Opcional |
| data_cadastro | Atributo | Data em que o cliente foi cadastrado | Obrigatório, gerado pelo sistema |

**Entidade: Obra**

| Atributo | Tipo | Descrição | Regra de negócio associada |
|----------|------|-----------|------------------------------|
| id_obra | PK | Identificador único da obra | Obrigatório |
| endereço_obra | Atributo | Local onde a obra será executada | Obrigatório |
| id_cliente | FK | Cliente responsável pela obra | Obrigatório |
| id_orcamento | FK | Orçamento aprovado que originou a obra | Obrigatório — obra só é criada a partir de um orçamento aprovado |
| descricao_escopo | Atributo | Resumo do escopo da obra | Opcional |
| data_inicio | Atributo | Data de início prevista/real | Obrigatório |
| data_fim | Atributo | Data de conclusão prevista/real | Opcional até conclusão |
| status | Atributo | Situação da obra | Deve ser um dos valores: planejada, em andamento, pausada, concluída |
| observacoes | Atributo | Anotações gerais sobre a obra | Opcional |

**Entidade: Serviço**

| Atributo | Tipo | Descrição | Regra de negócio associada |
|----------|------|-----------|------------------------------|
| id_servico | PK | Identificador único do serviço | Obrigatório |
| nome_servico | Atributo | Nome do serviço (ex.: pintura, elétrica) | Obrigatório |
| categoria | Atributo | Categoria do serviço (ex.: acabamento, instalação, estrutura) | Opcional |
| unidade_medida | Atributo | Unidade de cobrança/medição (ex.: m², hora, unidade) | Obrigatório |
| descricao | Atributo | Detalhamento do serviço | Opcional |
| valor_referencia | Atributo | Valor base de referência por unidade | Opcional |

**Entidade: Funcionário/Prestador**

| Atributo | Tipo | Descrição | Regra de negócio associada |
|----------|------|-----------|------------------------------|
| id_funcionario | PK | Identificador único | Obrigatório |
| nome | Atributo | Nome do profissional | Obrigatório |
| funcao | Atributo | Função/especialidade (ex.: pedreiro, eletricista) | Obrigatório |
| tipo_vinculo | Atributo | Efetivo ou terceirizado/subcontratado | Obrigatório |
| telefone | Atributo | Telefone de contato | Opcional |
| data_inicio_vinculo | Atributo | Data de início do vínculo com a empresa | Opcional |
| status_cadastro | Atributo | Ativo ou inativo | Só pode ser alocado a obras se ativo |

**Entidade: Orçamento**

| Atributo | Tipo | Descrição | Regra de negócio associada |
|----------|------|-----------|------------------------------|
| id_orcamento | PK | Identificador único | Obrigatório |
| id_cliente | FK | Cliente solicitante | Obrigatório |
| data_emissao | Atributo | Data de emissão do orçamento | Obrigatório |
| data_validade | Atributo | Prazo de validade da proposta | Opcional |
| valor_total | Atributo | Valor total orçado | Obrigatório, calculado a partir dos itens do orçamento |
| status_orcamento | Atributo | Pendente, aprovado ou recusado | Obra só pode ser aberta se aprovado |
| observacoes | Atributo | Condições ou observações da proposta | Opcional |

**Entidade associativa: Item_Orçamento**

*Resolve o relacionamento N:N entre Orçamento e Serviço, permitindo detalhar quantidade e valor por serviço orçado.*

| Atributo | Tipo | Descrição | Regra de negócio associada |
|----------|------|-----------|------------------------------|
| id_item_orcamento | PK | Identificador único do item | Obrigatório |
| id_orcamento | FK | Orçamento ao qual o item pertence | Obrigatório |
| id_servico | FK | Serviço orçado | Obrigatório |
| quantidade | Atributo | Quantidade do serviço orçada | Obrigatório, maior que zero |
| valor_unitario | Atributo | Valor unitário aplicado no orçamento | Obrigatório |
| valor_item | Atributo | Valor total do item (quantidade × valor_unitario) | Calculado; compõe o valor_total do orçamento |

**Entidade associativa: Obra_Serviço**

*Resolve o relacionamento N:N entre Obra e Serviço, registrando os serviços efetivamente contratados/executados em cada obra.*

| Atributo | Tipo | Descrição | Regra de negócio associada |
|----------|------|-----------|------------------------------|
| id_obra_servico | PK | Identificador único do vínculo | Obrigatório |
| id_obra | FK | Obra relacionada | Obrigatório |
| id_servico | FK | Serviço relacionado | Obrigatório |
| quantidade_executada | Atributo | Quantidade efetivamente executada | Opcional até execução |
| valor_acordado | Atributo | Valor acordado para o serviço nessa obra | Obrigatório |
| status_execucao | Atributo | Situação do serviço na obra | Pendente, em execução ou concluído |

**Entidade: Pagamento**

| Atributo | Tipo | Descrição | Regra de negócio associada |
|----------|------|-----------|------------------------------|
| id_pagamento | PK | Identificador único | Obrigatório |
| id_obra | FK | Obra relacionada | Obrigatório |
| numero_etapa | Atributo | Etapa/parcela a que o pagamento se refere | Opcional |
| valor | Atributo | Valor pago | Obrigatório |
| data_pagamento | Atributo | Data do pagamento | Obrigatório |
| forma_pagamento | Atributo | Ex.: PIX, boleto, transferência | Opcional |
| status_pagamento | Atributo | Pago, pendente ou atrasado | Obrigatório |

**Entidade associativa: Alocação**

*Resolve o relacionamento N:N entre Obra e Funcionário/Prestador, registrando quem trabalhou em qual obra e por quanto tempo.*

| Atributo | Tipo | Descrição | Regra de negócio associada |
|----------|------|-----------|------------------------------|
| id_alocacao | PK | Identificador único da alocação | Obrigatório |
| id_obra | FK | Obra em que o profissional atua | Obrigatório |
| id_funcionario | FK | Profissional alocado | Obrigatório; só pode ser alocado se status_cadastro = ativo |
| funcao_na_obra | Atributo | Função exercida especificamente nessa obra | Opcional |
| data_inicio_alocacao | Atributo | Data de início da alocação na obra | Obrigatório |
| data_fim_alocacao | Atributo | Data de término da alocação na obra | Opcional até desligamento da obra |

**Entidade: Fornecedor**

| Atributo | Tipo | Descrição | Regra de negócio associada |
|----------|------|-----------|------------------------------|
| id_fornecedor | PK | Identificador único do fornecedor | Obrigatório |
| nome_fornecedor | Atributo | Nome/razão social do fornecedor | Obrigatório |
| cnpj | Atributo | Documento de identificação (fictício nos exemplos) | Opcional |
| telefone | Atributo | Telefone de contato | Opcional |
| email | Atributo | E-mail de contato | Opcional |
| endereço | Atributo | Endereço do fornecedor | Opcional |

**Entidade: Material**

| Atributo | Tipo | Descrição | Regra de negócio associada |
|----------|------|-----------|------------------------------|
| id_material | PK | Identificador único do material | Obrigatório |
| nome_material | Atributo | Nome do material (ex.: cimento, tinta, fio elétrico) | Obrigatório |
| unidade_medida | Atributo | Unidade de controle (ex.: kg, litro, unidade, saco) | Obrigatório |
| quantidade_estoque | Atributo | Quantidade atualmente em estoque | Obrigatório; não deve ficar negativa |
| valor_unitario_referencia | Atributo | Valor de referência por unidade | Opcional |

**Entidade associativa: Compra**

| Atributo | Tipo | Descrição | Regra de negócio associada |
|----------|------|-----------|------------------------------|
| id_compra | PK | Identificador único da compra | Obrigatório |
| id_fornecedor | FK | Fornecedor que vendeu o material | Obrigatório |
| id_material | FK | Material adquirido | Obrigatório |
| id_obra | FK | Obra para a qual o material foi destinado | Opcional — pode haver compra para estoque geral |
| quantidade | Atributo | Quantidade comprada | Obrigatório, maior que zero |
| valor_total | Atributo | Valor total pago na compra | Obrigatório |
| data_compra | Atributo | Data em que a compra foi realizada | Obrigatório |

*Exemplos usados acima são genéricos/ilustrativos — não há dado real de cliente, funcionário ou fornecedor.*

> **Atenção do grupo:** este dicionário trata `Compra` como a própria entidade associativa entre Fornecedor, Material e Obra (uma linha = um material comprado). O DER em imagem anexado ao repositório tem `Compra` e `Item_Compra` separados (uma compra com vários itens). Antes de entregar, alinhem os dois — ou simplificam o DER pra bater com esta tabela, ou dividem esta tabela em `Compra` + `Item_Compra` pra bater com o DER. Do jeito que está, DER e dicionário descrevem estruturas ligeiramente diferentes.

---

### Modelagem Conceitual (Entidades, Atributos, Relacionamentos)
*(vale 7,5% na dimensão conceitual)*

**Entidades reconhecidas:** Cliente, Orçamento, Item de Orçamento, Serviço, Obra, Obra_Serviço, Funcionário, Alocação, Fornecedor, Compra, Item de Compra, Material, Pagamento.

- **Cliente** é quem solicita orçamento e, eventualmente, tem uma obra executada — existe isolado porque pode ter mais de um orçamento/obra ao longo do tempo (histórico).
- **Orçamento** e **Item de Orçamento** são separados porque um orçamento tem vários serviços orçados, cada um com sua própria quantidade e valor negociado — não caberia num único registro.
- **Serviço** é um catálogo reutilizável: o mesmo serviço (ex.: "pintura interna") aparece em vários orçamentos diferentes, com valor de referência único, mas negociado item a item.
- **Obra** nasce de um orçamento aprovado e é o eixo em torno do qual giram equipe, compras e pagamentos daquele projeto específico.
- **Obra_Serviço** existe porque o que foi orçado (Item de Orçamento) nem sempre é executado exatamente igual — a obra pode ajustar quantidade e status de execução por serviço.
- **Funcionário** e **Alocação** são separados pelo mesmo motivo de Cliente/Obra: um funcionário atua em várias obras ao longo do tempo, cada alocação com sua função e período específicos naquela obra.
- **Fornecedor**, **Compra**, **Item de Compra** e **Material** seguem a mesma lógica do bloco de orçamento: Material é catálogo reutilizável, Compra é o pedido feito a um Fornecedor para uma Obra, Item de Compra detalha quantidade/valor de cada material naquela compra.
- **Pagamento** é separado da Obra porque uma obra é paga em várias etapas, cada uma com sua própria data, valor e status.

**Relacionamentos pertinentes:**

- Um Cliente possui vários Orçamentos e várias Obras; um Orçamento/Obra pertence a um único Cliente.
- Um Orçamento possui vários Itens de Orçamento; cada Item de Orçamento refere-se a um único Serviço do catálogo.
- Um Orçamento aprovado origina uma Obra.
- Uma Obra executa vários Serviços (via Obra_Serviço); um Serviço pode estar em várias obras.
- Uma Obra recebe várias Alocações; cada Alocação vincula um único Funcionário a uma única Obra.
- Uma Obra gera várias Compras; uma Compra é feita a um único Fornecedor.
- Uma Compra possui vários Itens de Compra; cada Item de Compra refere-se a um único Material do catálogo.
- Uma Obra recebe vários Pagamentos (um por etapa).

**Restrições e políticas organizacionais aplicadas ao modelo:**
- Uma Obra só existe vinculada a um Orçamento aprovado — não há Obra sem Orçamento de origem.
- O valor total de um Orçamento e de uma Compra são sempre derivados da soma dos seus itens, nunca digitados diretamente — o que reforça Item_Orçamento e Item_Compra como o nível de detalhe real do dado.

---

### Diagrama Entidade-Relacionamento (DER)
*(vale 20% — é o item de maior peso da entrega)*

Ver arquivo `der.jpeg` anexado neste repositório, com as 13 entidades descritas acima, seus atributos e as cardinalidades de cada relacionamento (Cliente 1:N Orçamento/Obra; Orçamento 1:N Item_Orçamento; Serviço 1:N Item_Orçamento e 1:N Obra_Serviço; Obra 1:N Obra_Serviço, 1:N Alocação, 1:N Compra, 1:N Pagamento; Funcionário 1:N Alocação; Fornecedor 1:N Compra; Compra 1:N Item_Compra; Material 1:N Item_Compra).

---

### Justificativa Técnica
*(vale 7,5% — sozinho, é o subcritério de maior peso dentro da Dimensão Conceitual)*

A decisão central do modelo foi **separar o que foi orçado (Item_Orçamento) do que foi de fato executado (Obra_Serviço)**, em vez de assumir que a obra sempre executa exatamente o que constava no orçamento. Na prática de uma obra, quantidade e escopo de um serviço podem mudar no meio do caminho (mais metros quadrados do que o previsto, um serviço cancelado). Um único registro que misturasse "orçado" e "executado" perderia essa diferença — e é justamente essa diferença que a empresa precisa para saber se está ganhando ou perdendo dinheiro numa obra em relação ao que foi vendido ao cliente.

A segunda decisão foi **tratar Serviço e Material como catálogos**, separados de Item_Orçamento/Item_Compra. Isso evita redigitar "Pintura interna — R$ 35/m²" a cada novo orçamento, mas também permite que o valor efetivamente cobrado (no Item_Orçamento) seja diferente do valor de referência do catálogo — refletindo a regra de negócio real de que todo orçamento é, até certo ponto, negociado com o cliente.

Por fim, **Pagamento foi modelado por etapa, vinculado à Obra**, e não como um valor único fechado no momento da venda — porque obra de reforma tipicamente não é paga de uma vez só; separar por etapa é o que permite ao sistema responder "quanto já foi pago dessa obra" e "quanto ainda falta receber" a qualquer momento, sem depender de conferência manual.

---

### Uso de Inteligência Artificial
*(documentação obrigatória — não é opcional se o grupo usou IA em qualquer etapa: pesquisa, escrita, organização de ideias ou revisão de texto)*

| Item | O que registrar |
|------|------------------|
| **Ferramenta e etapa** | Claude (Anthropic), usado na redação deste README — estruturação dos processos de negócio, dicionário de dados e justificativa técnica a partir do diagrama ER (DER) já desenhado pelo grupo. |
| **Motivação** | O grupo já havia levantado os requisitos com a organização e desenhado o DER; a IA foi usada para organizar esse conhecimento no formato de texto exigido pelo esqueleto da atividade (processos, requisitos, regras, dicionário de dados, justificativa). |
| **Prompt(s) utilizados** | *(preencher com o prompt real: ex. "aqui está o DER que fizemos [imagem anexada], escreva o README da atividade com base nele")* |
| **Resposta recebida** | Rascunho completo do README, com entidades, relacionamentos e dicionário de dados descritos a partir da leitura do diagrama fornecido pelo grupo. |
| **Fontes consultadas e verificadas** | O conteúdo parte do DER e do conhecimento da organização que o próprio grupo já tinha — precisa ser revisado por quem fez a visita de campo, conferindo se os processos descritos batem com o que foi observado na prática. |
| **Trechos rejeitados ou corrigidos** | *(preencher pelo grupo após a revisão — ex.: algum processo, regra ou nome de campo que não corresponde exatamente à realidade da empresa)* |
| **Justificativa da escolha final** | *(preencher pelo grupo: por que mantiveram, adaptaram ou rejeitaram cada parte)* |
| **Reflexão crítica** | A IA não participou do levantamento de requisitos nem do desenho do DER (isso já veio pronto do grupo) — o risco aqui é textual: a IA pode ter dado nomes de processo ou regra de negócio plausíveis, mas genéricos, que precisam ser confirmados como verdadeiros para a organização real, e não apenas "razoáveis para uma empresa desse ramo em geral". |

*Se o grupo não usou nenhuma ferramenta de IA, declare isso explicitamente nesta seção. (Não é o caso aqui — o uso está documentado acima, conforme exigido.)*

## Conclusão

*(preencher pelo grupo após revisão: síntese do que foi modelado, principais aprendizados do levantamento de requisitos numa organização real, e o que se espera aprofundar nas próximas etapas.)*

## Referências Bibliográficas

*(citar o material da disciplina usado como base teórica para modelagem conceitual/DER, conforme orientação do professor.)*

---

## Critérios Atitudinais (20%)
*(avaliados por Avaliação 360º entre os integrantes do grupo — não é conteúdo deste README)*

---

## Resumo dos Pesos

| Dimensão | Peso total |
|----------|-----------|
| Conceitual (contexto, requisitos/regras, modelagem, justificativa técnica) | 30% |
| Procedimental (requisitos, fluxogramas, dicionário de dados, DER) | 50% |
| Atitudinal (participação, comprometimento, colaboração, autonomia) | 20% |

**Entrega final:** README.md completo + DER anexado no repositório GitHub do grupo.

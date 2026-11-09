# Dicionário de Dados Conceitual

Extraído do README para manter o documento legível. Este dicionário segue o
modelo conceitual descrito no texto, em notação de Chen, e inclui as entidades
Fornecedor e Compra, que não constam do `dicionario.html`.

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

**Relacionamento N:N com atributos: Orçamento _compõe_ Serviço**

*Não existe como tabela/entidade própria — quantidade e valor por serviço orçado são atributos do PRÓPRIO relacionamento entre Orçamento e Serviço (notação de Chen), não uma entidade associativa separada. Na implementação física isso ainda vira uma tabela de junção (orcamento_servico), mas conceitualmente no DER é um relacionamento, não uma entidade — diferença que a primeira versão deste diagrama errava.*

| Atributo do relacionamento | Tipo | Descrição | Regra de negócio associada |
|----------|------|-----------|------------------------------|
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

**Entidade: Compra**

| Atributo | Tipo | Descrição | Regra de negócio associada |
|----------|------|-----------|------------------------------|
| id_compra | PK | Identificador único da compra | Obrigatório |
| id_fornecedor | FK | Fornecedor que vendeu os materiais | Obrigatório |
| id_obra | FK | Obra para a qual a compra foi destinada | Opcional — pode haver compra para estoque geral |
| data_compra | Atributo | Data em que a compra foi realizada | Obrigatório |
| valor_total | Atributo | Valor total da compra | Calculado a partir dos itens da compra |

**Relacionamento N:N com atributos: Compra _compõe_ Material**

*Mesmo caso de Orçamento-Serviço acima: quantidade e valor pago por material comprado são atributos do relacionamento entre Compra e Material, não uma entidade associativa própria.*

| Atributo do relacionamento | Tipo | Descrição | Regra de negócio associada |
|----------|------|-----------|------------------------------|
| quantidade | Atributo | Quantidade comprada daquele material | Obrigatório, maior que zero |
| valor_unitario | Atributo | Valor unitário pago naquela compra | Obrigatório |
| valor_item | Atributo | Valor total do item (quantidade × valor_unitario) | Calculado; compõe o valor_total da compra |

*Exemplos usados acima são genéricos/ilustrativos — não há dado real de cliente, funcionário ou fornecedor.*

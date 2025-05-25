# Infraestrutura de Banco de dados

Este repositório contém scripts Terraform responsáveis por criar e gerenciar uma infraestrutura AWS necessária para criação de um banco de dados Postgre no serviço Amazon  RDS com suas devidas dependências.

O estado do Terraform é armazenado em um bucket S3, configurado através do script `setup.sh`. 

A infraestrutura é disponibilizada através de workflows do GitHub Actions.

## Estrutura do Repositório

```
├── .github/
│   └── workflows/           # Workflows do GitHub Actions
├── terraform/               # Scripts Terraform
│   ├── backend.tf           # Configurações para sincronização do estado do terraform
│   ├── bd.tf                # Configurações para criação da instância do banco de dados no AWS Aurora RDS
│   ├── security-groups.tf   # Configurações segurança através dos security groups
│   ├── variables.tf         # Definição de variáveis
│   ├── outputs.tf           # Outputs definidos
│   └── provider.tf          # Configuração do provedor AWS
├── setup.sh                 # Script para configuração do bucket S3 utilizado pelo terraform
```

## Plugins do VSCode para Desenvolvimento

Para uma experiência de desenvolvimento mais produtiva com Terraform e AWS, recomendamos os seguintes plugins do VSCode:

- [HashiCorp Terraform](https://marketplace.visualstudio.com/items?itemName=HashiCorp.terraform)

- [Terraform doc snippets](https://marketplace.visualstudio.com/items?itemName=run-at-scale.terraform-doc-snippets): Snippets para documentação de módulos Terraform.

- [AWS Toolkit](https://marketplace.visualstudio.com/items?itemName=AmazonWebServices.aws-toolkit-vscode): Fornece integração com serviços AWS diretamente no VSCode.
- [GitLens](https://marketplace.visualstudio.com/items?itemName=eamodio.gitlens): Integração Git aprimorada com histórico de linha e navegação avançada.
- [YAML](https://marketplace.visualstudio.com/items?itemName=redhat.vscode-yaml): Suporte para arquivos YAML (útil para configurações do GitHub Actions).
- [GitHub Actions](https://marketplace.visualstudio.com/items?itemName=GitHub.vscode-github-actions): Suporte para sintaxe dos workflows do GitHub Actions.

## Pré-requisitos

Antes de executar os scripts Terraform localmente, certifique-se de ter instalado:

1. [Terraform](https://www.terraform.io/downloads.html) (versão 1.0.0 ou superior)
2. [AWS CLI](https://aws.amazon.com/cli/) configurado com as credenciais adequadas
3. [Git](https://git-scm.com/downloads)

## Configuração AWS

No arquivo `~./aws/credentials` defina as credenciais em profile customizado:
```
[default]
aws_access_key_id=
aws_secret_access_key=
aws_session_token=
```
Adicionei uma entrada no arquivo `~/.aws/config` para especificar a região padrão.
```
[profile default]
region = us-east-1
```


## Configuração do Backend S3

O estado do Terraform é armazenado em um bucket S3 para garantir consistência e colaboração entre a equipe. Para configurar o backend:

1. Conceda permissão ao arquivo setup.sh
`chmod +x setup.sh`

2. Execute o script `setup.sh` para criar o bucket S3:

```bash
./setup.sh
```

Este script irá:
- Criar o bucket S3 para armazenar o estado do Terraform (caso não exista)
- Habilitar versionamento no bucket

## Execução Local dos Scripts Terraform

Para executar os scripts Terraform localmente, siga os passos abaixo:

### Pré-requisitos

Os scripts dependem da VPC que é criada à partir do [repositório de infra](https://github.com/ronanluiz/fiap-tech-challenge-infra). Portanto, será necessário executar os scripts deste para ter a infra básica para execução.

### Inicialize o Terraform

```bash
terraform -chdir=terraform init
```

Este comando inicializa o diretório de trabalho do Terraform, baixa os provedores necessários e configura o backend S3.

### Valide a configuração

```bash
terraform -chdir=terraform validate
```

Este comando verifica se a configuração está sintaticamente correta e internamente consistente.

### Formate os scripts

```bash
terraform -chdir=terraform fmt
```

Este comando organiza a formatação dos scripts nos arquivos padronizando principalmente a identação de código para deixá-lo mais legível.

### Crie um plano de execução

```bash
terraform -chdir=terraform plan -out=tfplan
```

⚠ **Obs.:** Serão exigidas algumas informações como variáveis para execução dos scripts.

Este comando cria um plano de execução e salva no arquivo `tfplan`. Revise cuidadosamente as alterações propostas.

### Aplique as alterações

```bash
terraform -chdir=terraform apply tfplan
# Para execução automática se ter necessidade de aprovação
terraform -chdir=terraform apply tfplan -auto-approve
```

Este comando aplica as alterações planejadas na infraestrutura AWS.

### Destrua a infraestrutura (quando necessário)

```bash
terraform -chdir=terraform destroy  
# Para execução automática se ter necessidade de aprovação
terraform -chdir=terraform destroy -auto-approve
```

Este comando remove todos os recursos criados pelo Terraform. Use com cautela, apenas quando realmente necessário.

## Componentes da Infraestrutura

### AWS RDS

O AWS Relational Database Service (RDS) é um serviço que fornece bancos de dados relacionais hospedados, que são mais fáceis de operar e manter do que implementações autogerenciadas.

### Security Groups

Os Security Groups controlam o tráfego de rede e permissões para os recursos AWS. 

## GitHub Actions

Este repositório utiliza GitHub Actions para automatizar o processo de implantação da infraestrutura. Os workflows estão definidos em `.github/workflows/` e incluem:
- **main.yaml**: Responsável por criar ou atualizar os recursos AWS através dos commandos terraform.
- **destroy-infra.yaml**: Permite os desprovisionamento de toda a infraestrutura criada a partir do terraform.

Abaixo a lista de variáveis/secrets que precisam ser configurados no github (Settings -> Secrets and variables -> Actions) para que a execução ocorra com sucesso:

**Secrets:**
- AWS_ACCESS_KEY_ID
- AWS_SECRET_ACCESS_KEY
- AWS_SESSION_TOKEN
- DB_NAME
- DB_USERNAME
- DB_PASSWORD

**Variables:** 
- AWS_REGION

## Boas Práticas de Desenvolvimento

1. Sempre execute `terraform plan` antes de aplicar qualquer alteração
2. Mantenha o código modularizado para facilidade de manutenção
3. Use variáveis para valores que podem mudar entre ambientes
4. Adicione comentários para explicar configurações complexas
5. Faça commit de alterações pequenas e frequentes
6. Evite armazenar segredos no código (use variáveis de ambiente ou AWS Secrets Manager)

## Resolução de Problemas

| Problema | Possível Solução |
|----------|------------------|
| Erro de acesso ao bucket S3 | Verifique suas credenciais AWS e permissões |
| Conflito de estado | Verifique se outra pessoa está executando o Terraform simultaneamente ou se há necessidade de reconfigurar o estado (normalmente é resolvido utilizando o comando `terraform -chdir=terraform init -reconfigur`) |
| Falha no GitHub Actions | Verifique os secrets configurados no repositório |
| Falha ao realizar o `terraform destroy` | Verificar se não existe outro recurso criado que está referenciando um recurso criado através de scripts desse repositório. |

Para problemas mais complexos, consulte a documentação oficial do [Terraform](https://www.terraform.io/docs/index.html) e da [AWS](https://docs.aws.amazon.com/).



## Justificativa da Escolha do Banco de Dados (PostgreSQL)

A escolha do PostgreSQL como banco de dados principal foi baseada nos seguintes critérios, definidos após uma fase inicial de Event Storming:

* Modelagem Relacional: A forte relação entre as entidades e as características dos agregados sugeriram o uso de um banco de dados relacional (SQL).
* Open Source: Preferência por uma solução de código aberto.
* Robustez: Necessidade de um banco de dados confiável e estável.
* Excelente Performance: Requisito de bom desempenho para lidar com um volume considerável de dados e transações.
* Suporte a ACID: Importância de garantir a atomicidade, consistência, isolamento e durabilidade das transações.
* Suporte a JSON: Capacidade de lidar com dados semiestruturados, caso seja necessário no futuro.
* Familiaridade da Equipe: Todos os integrantes da equipe já possuíam experiência com bancos de dados relacionais (SQL).
* Integração com Serviços Cloud e Serverless: Compatibilidade com plataformas de nuvem e arquiteturas serverless.

## Estrutura do Banco de Dados

O banco de dados evoluiu ao longo do desenvolvimento da aplicação. Inicialmente, possuía as seguintes tabelas:

* customer: Armazena os dados dos clientes.
* order: Armazena os pedidos realizados pelos clientes.
* order_item: Armazena os itens de cada pedido.
* payment: Armazena as informações de pagamento de cada pedido.
* product: Armazena os dados dos produtos disponíveis.

### Banco de Dados Inicial (Diagrama)

![image](https://github.com/user-attachments/assets/eeb56b6e-a6d7-4b11-ab1d-4658aae18d96)

As principais relações entre as tabelas eram:

* Um `Customer` pode ter muitos `Orders` (relação 1:N).
* Cada `Order` pertence a um `Customer`.
* Cada `Order` pode ter vários `Order_Items` (relação 1:N).
* Cada `Order_Item` refere-se a um `Product` (relação N:1).
* Cada `Order` tem um `Payment` (relação 1:1 ou 1:N, dependendo da regra de negócio).

### Banco de Dados Atual (Diagrama)

Após testes e refinamentos, a estrutura do banco de dados foi aprimorada com a inclusão de duas novas tabelas:

* cart: Armazena os carrinhos de compra dos clientes.
* cart_item: Armazena os itens de cada carrinho de compra.

![image](https://github.com/user-attachments/assets/c63ccc54-941c-4b79-b3a9-b09579dbeb28)

As relações foram atualizadas para:

* Um `Customer` pode ter vários `Carts` (relação 1:N).
* Cada `Cart` pertence a um `Customer`.
* Cada `Cart` pode ter vários `Cart_Items` (relação 1:N).
* Cada `Cart_Item` refere-se a um `Product` (relação N:1).

As tabelas e seus atributos são detalhados abaixo:

customer

| Coluna        | Tipo           | Atributos                                 |
|---------------|----------------|-------------------------------------------|
| customer_Id   | UUID           | PK                                        |
| created_at    | TIMESTAMPTZ    | NOT NULL DEFAULT CURRENT_TIMESTAMP        |
| name          | VARCHAR(255)   | NOT NULL                                  |
| email         | VARCHAR(255)   | NULL                                      |
| cpf           | VARCHAR(11)    | NULL                                      |
| status        | VARCHAR(50)    | DEFAULT 'active'                          |

order

| Coluna      | Tipo       | Atributos  |
|-------------|------------|------------|
| order Id    | UUID       | PK         |
| customer_id | UUID       | FK         |
| status      | VARCHAR(50) | DEFAULT 'active' |

order_item

| Coluna        | Tipo           | Atributos  |
|---------------|----------------|------------|
| order_item_id | UUID           | PK         |
| order_id      | UUID           | NOT NULL FK |
| product_id    | UUID           | NOT NULL FK |
| quantity      | INTEGER        | NOT NULL     |
| price         | DECIMAL(10, 2) | NOT NULL     |
| note          | VARCHAR(255)   | NULL         |

product

| Coluna          | Tipo           | Atributos      |
|-----------------|----------------|----------------|
| product_id      | UUID           | PK             |
| name            | VARCHAR(50)    | NOT NULL       |
| description     | VARCHAR(200)   | NOT NULL       |
| category        | INT            | NOT NULL       |
| price           | NUMERIC(10, 2) | NOT NULL       |
| status          | INT            | NOT NULL       |
| time_to_prepare | NUMERIC(5, 2) | NOT NULL       |
| is_available    | BOOLEAN        | NOT NULL       |
| created_at      | TIMESTAMP      | NOT NULL       |
| amount          | DECIMAL(10, 2) | NOT NULL       |
| order_number    | SERIAL         |                |

cart

| Coluna      | Tipo   | Atributos  |
|-------------|--------|------------|
| cart Id     | UUID   | PK         |
| customer_id | UUID   | FK         |
| status      | VARCHAR |            |
| created_at  | TIMES  |            |

cart_item

| Coluna        | Tipo       | Atributos  |
|---------------|------------|------------|
| cart_Item_Id  | UUID       | PK         |
| cart_id       | UUID       | FK         |
| product_id    | UUID       | FK         |
| quantity      | INTEGER    |            |
| notes         | VARCHAR    |            |

payment

| Coluna                | Tipo           | Atributos       |
|-----------------------|----------------|-----------------|
| payment_id            | UUID           | PK              |
| order_id              | UUID           | FK              |
| total_amount          | DECIMAL(10, 2) | NOT NULL        |
| qr_data               | TEXT           | NULL            |
| external_payment_id   | VARCHAR(255)   | NULL            |
| created_at            | TIMESTAMP      | NOT NULL DEFAULT |
| paid_at               | TIMESTAMP      | NULL            |
| status                | VARCHAR(255)   | NOT NULL DEFAULT 'Pending' |
| status_detail         | VARCHAR(255)   | NOT NULL DEFAULT 'Pending' |

Os Enums foram utilizados para:

* Status do Pedido (Pendente, Processado, Enviado, Entregue)
* Categoria do Produto (Eletrônicos, Roupas, Alimentos)

##  Relacionamentos entre as Tabelas

### Customer - Order

* **Relação:** Um `Customer` pode ter muitos `Orders` (1:N).
* **Implementação:** Na tabela `order`, a coluna `customer_id` é uma chave estrangeira referenciando `customer(customer_id)`.

### Order - Order\_Item - Product

* **Relação Order e Order\_Item:** Cada `Order` pode ter vários itens, ou seja, muitas entradas em `order_item` (1:N).
* **Relação Order\_Item e Product:** Cada registro em `order_item` referencia exatamente um `Product` (N:1).
* **Implementação:**
    * Na tabela `order_item`, a coluna `order_id` referencia `order(order_id)`.
    * A coluna `product_id` referencia `product(product_id)`.

### Order - Payment

* **Relação:** Um `Order` pode ter um (ou possivelmente mais, dependendo do modelo de negócio) `Payment`. Geralmente, o pagamento é considerado como uma entidade associada a um pedido (1:1 ou 1:N, conforme sua regra de negócio).
* **Implementação:** Na tabela `payment`, a coluna `order_id` é uma chave estrangeira que referencia `order(order_id)`.

###  Customer - Cart - Cart\_Item - Product

* **Relação Customer e Cart:** Um `Customer` pode ter um carrinho (ou múltiplos, historicamente ou se o carrinho for persistido) – a tabela `cart` referencia o cliente via `customer_id` (1:N ou 0:N se o carrinho puder existir sem vínculo imediato).
* **Relação Cart e Cart\_Item:** Cada `Cart` pode ter vários `Cart_Items` (1:N).
* **Relação Cart\_Item e Product:** Cada item no carrinho referencia um `Product` (N:1).
* **Implementação:**
    * Em `cart`, a coluna `customer_id` referencia `customer(customer_id)`.
    * Em `cart_item`, a coluna `cart_id` referencia `cart(cart_id)` e
    * A coluna `product_id` referencia `product(product_id)`.


##  Considerações Finais

O processo de construção deste software é contínuo e sujeito a mudanças. Estamos abertos a novas possibilidades de melhorias e correções, buscando sempre uma solução capaz de ser ajustada sem comprometer a aplicação.

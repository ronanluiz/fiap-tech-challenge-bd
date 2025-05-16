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
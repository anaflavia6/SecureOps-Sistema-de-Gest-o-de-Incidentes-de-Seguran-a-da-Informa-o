# SecureOps – Sistema de Gestão de Incidentes de Segurança da Informação

Desenvolvimento de um **Sistema de Gestão de Incidentes de Segurança da Informação (SecureOps)**, com foco em **organização**, **rastreabilidade** e **apoio à tomada de decisão**.

O projeto envolve **modelagem de banco de dados relacional**, definição de entidades, regras de negócio e controle do ciclo de vida de incidentes de segurança.

> Este projeto foi estruturado para atender aos critérios técnicos exigidos em cursos técnicos e, ao mesmo tempo, servir como **portfólio profissional** na área de **Dados** e **Segurança da Informação**.

![Diagrama SecureOps](https://github.com/user-attachments/assets/efdb3616-7ff6-4c03-8bd8-6a8366ac9512)

---

##  Visão Geral do Projeto

O **SecureOps** é um sistema de gestão de incidentes de segurança da informação que centraliza o controle de:

- Ativos digitais  
- Incidentes de segurança  
- Analistas responsáveis  
- Ações corretivas  
- Impactos financeiros  

O sistema cobre **todo o ciclo de vida do incidente**, desde a detecção até o encerramento, garantindo **consistência**, **integridade** e **padronização dos dados**.

---

## Objetivo

Desenvolver o **esquema de um banco de dados relacional** capaz de:

- Registrar incidentes de segurança de forma estruturada  
- Garantir rastreabilidade técnica e gerencial  
- Apoiar análises estratégicas por meio de dados confiáveis  
- Servir como base para modelagem **conceitual**, **lógica** e **física**  

![Objetivo do Sistema](https://github.com/user-attachments/assets/13761d09-abda-4368-8005-31d174a83b61)

---

## Contexto

Com o aumento da digitalização dos processos organizacionais, crescem os riscos relacionados à segurança da informação, como:

- Acessos não autorizados  
- Vazamento de dados  
- Falhas de sistemas  
- Ataques cibernéticos  

Em muitas organizações, esses registros ainda são realizados de forma **manual ou descentralizada**, dificultando análises rápidas e a tomada de decisão.

> O SecureOps propõe um **modelo base** de como empresas em fase de desenvolvimento podem implementar **controles simples, organizados e eficientes** de segurança da informação.

---

## Regras de Negócio

### Gestão de Ativos Digitais
- Todo incidente deve estar vinculado a **um ativo digital**
- Um ativo pode estar associado a **vários incidentes**

### Responsabilidade Técnica
- Cada incidente possui **um único analista responsável**
- Um analista pode acompanhar **múltiplos incidentes**

### Classificação e Severidade
- Incidentes são classificados por **tipo**
- Cada tipo possui um **nível de severidade**

### Registro Técnico Detalhado
- Registro de análises técnicas
- Ações corretivas e medidas de contenção

### Impacto Financeiro
- Registro opcional do **impacto financeiro estimado**
- Apoio a análises gerenciais

### Fluxo de Tratamento do Incidente
Estados possíveis do incidente:

- `Detectado`
- `Em_Analise`
- `Contido`
- `Resolvido`
- `Encerrado`

![Fluxo de Incidentes](https://github.com/user-attachments/assets/8050f33f-4de7-4c02-94b8-d833b501c9b4)

---

## Requisitos Técnicos

| Critério | Implementação |
|-------|--------------|
| Banco de Dados | MySQL |
| Engine | InnoDB |
| Charset | `utf8` |
| Collation | `utf8_general_ci` |
| Ambiente | MySQL Workbench 8.0 / Windows 11 |
| Integridade | PK e FK |
| Datas | `TIMESTAMP` |
| Textos longos | `TEXT` |
| Status e Severidade | `ENUM` |
| Valores monetários | `DECIMAL(10,2)` |

> As decisões técnicas seguem **boas práticas profissionais** e garantem **integridade referencial**.

---

## Modelagem do Sistema

### Principais Entidades

- **ativo_digital**
- **incidente**
- **analista**
- **tipo_incidente**
- **acao_corretiva**

> O modelo foi projetado para conversão direta em **DER no MySQL Workbench**.

---

## Estrutura do Banco de Dados

### Criação do Banco

```sql
CREATE DATABASE secureops
CHARACTER SET utf8
COLLATE utf8_general_ci;

USE secureops;

CREATE TABLE ativo_digital (
    id_ativo INT AUTO_INCREMENT PRIMARY KEY,
    nome_ativo VARCHAR(100) NOT NULL,
    tipo_ativo VARCHAR(50),
    criticidade ENUM('Baixa','Media','Alta') NOT NULL
) ENGINE=InnoDB;

CREATE TABLE tipo_incidente (
    id_tipo INT AUTO_INCREMENT PRIMARY KEY,
    descricao VARCHAR(100) NOT NULL,
    severidade ENUM('Baixa','Media','Alta','Critica') NOT NULL
) ENGINE=InnoDB;

CREATE TABLE analista (
    id_analista INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL
) ENGINE=InnoDB;

CREATE TABLE incidente (
    id_incidente INT AUTO_INCREMENT PRIMARY KEY,
    data_abertura TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    status ENUM('Detectado','Em_Analise','Contido','Resolvido','Encerrado') NOT NULL,
    impacto_financeiro DECIMAL(10,2),
    id_ativo INT NOT NULL,
    id_tipo INT NOT NULL,
    id_analista INT NOT NULL,
    FOREIGN KEY (id_ativo) REFERENCES ativo_digital(id_ativo),
    FOREIGN KEY (id_tipo) REFERENCES tipo_incidente(id_tipo),
    FOREIGN KEY (id_analista) REFERENCES analista(id_analista)
) ENGINE=InnoDB;

CREATE TABLE acao_corretiva (
    id_acao INT AUTO_INCREMENT PRIMARY KEY,
    descricao TEXT NOT NULL,
    id_tipo INT NOT NULL,
    FOREIGN KEY (id_tipo) REFERENCES tipo_incidente(id_tipo)
) ENGINE=InnoDB;

Carga de Dados para Testes

O projeto inclui dados simulados para validação do modelo:

Ativos digitais

Tipos de incidentes

Analistas

Incidentes em diferentes severidades e status

Ações corretivas associadas

Essa carga permite testar relacionamentos, integridade e consultas SQL.

 Aviso Importante sobre os Dados

Todos os dados apresentados neste repositório são fictícios e utilizados exclusivamente para fins acadêmicos e de teste.

Nenhuma informação pessoal real foi utilizada

Nomes, e-mails, ativos e incidentes são simulados

O objetivo é demonstrar a modelagem e funcionamento do banco de dados

Este projeto não representa dados reais de pessoas, empresas ou sistemas e não deve ser utilizado em produção sem adaptações e validações de segurança.


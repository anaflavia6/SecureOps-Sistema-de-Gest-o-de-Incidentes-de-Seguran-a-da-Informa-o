# SecureOps-Sistema-de-Gest-o-de-Incidentes-de-Seguran-a-da-Informa-o
Desenvolvimento de um Sistema de Gestão de Incidentes de Segurança da Informação (SecureOps), com foco em organização, rastreabilidade e apoio à tomada de decisão.  O projeto envolve modelagem de banco de dados relacional, definição de entidades, regras de negócio e controle do ciclo de vida de incidentes de segurança

> Este projeto foi estruturado para atender aos critérios técnicos exigidos em cursos técnicos e, ao mesmo tempo, servir como **portfólio profissional** na área de Dados e Segurança da Informação.
![8e8f48bf-3cea-478c-8f2f-6bd52c6fb858](https://github.com/user-attachments/assets/efdb3616-7ff6-4c03-8bd8-6a8366ac9512)

---

## Visão Geral do Projeto

O **SecureOps** é um sistema de gestão de incidentes de segurança da informação que centraliza o controle de ativos digitais, incidentes, analistas responsáveis, ações corretivas e impactos financeiros.

Ele cobre **todo o ciclo de vida do incidente**, desde a detecção até o encerramento, garantindo consistência, integridade e padronização dos dados.

---

## Objetivo

Desenvolver o **esquema de um banco de dados relacional** capaz de:

- Registrar incidentes de segurança de forma estruturada  
- Garantir rastreabilidade técnica e gerencial  
- Apoiar análises estratégicas por meio de dados confiáveis  
- Servir como base para modelagem conceitual, lógica e física  

![a85308ce-7bcb-483e-8f1a-0019814fb096](https://github.com/user-attachments/assets/13761d09-abda-4368-8005-31d174a83b61)


---

Com o aumento da digitalização dos processos organizacionais, crescem também os riscos relacionados à segurança da informação, como:

- Acessos não autorizados  
- Vazamento de dados  
- Falhas de sistemas  
- Ataques cibernéticos  

Em muitos lugares, esses registros ainda são feitos de forma **manual ou descentralizada**, tornando as análises lentas e complexas.

A criação do secureops é com foco em um modelo base de como uma empresa em fase de desenvolvimento poderia implementar modelos de segurança simples e fáceis de utilizar.

---

##  Regras de Negócio

###  Gestão de Ativos Digitais
- Todo incidente deve estar vinculado a **um ativo digital**
- Um ativo pode estar associado a **vários incidentes**

###  Responsabilidade Técnica
- Cada incidente possui **um único analista responsável**
- Um analista pode acompanhar **múltiplos incidentes**

###  Classificação e Severidade
- Incidentes são classificados por **tipo**
- Cada tipo possui um **nível de severidade**

###  Registro Técnico Detalhado
- O sistema permite descrições técnicas completas
- Inclui análise, contenção e ações corretivas

###  Impacto Financeiro
- Registro opcional do **impacto financeiro estimado**
- Base para análises gerenciais e estratégicas

###  Fluxo de Tratamento
Os incidentes seguem estados padronizados:

- `Detectado`
- `Em_Analise`
- `Contido`
- `Resolvido`
- `Encerrado`

- 
![c12daf03-93ed-4c61-9b06-5c811e681975](https://github.com/user-attachments/assets/8050f33f-4de7-4c02-94b8-d833b501c9b4)

---

## ⚙️ Requisitos Técnicos

| Critério | Implementação |
|-------|--------------|
| Banco de Dados | MySQL |
| Engine | InnoDB |
| Charset | `utf8` |
| Collation | `utf8_general_ci` |
| Ambiente | MySQL Workbench 8.0 / Windows 11 |
| Integridade | PK e FK com restrições |
| Datas | `TIMESTAMP` |
| Textos longos | `TEXT` |
| Status e Severidade | `ENUM` |
| Valores monetários | `DECIMAL(10,2)` |

> Essas decisões garantem **compatibilidade, integridade referencial e boas práticas profissionais**.

---

## Modelagem do Sistema

### Principais Entidades

- **ativo_digital**
- **incidente**
- **analista**
- **tipo_incidente**
- **acao_corretiva**

> O modelo foi pensado para ser facilmente convertido em **DER no MySQL Workbench**.

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

Incidentes em diferentes estados e severidades

Ações corretivas associadas

Essa carga permite testar relacionamentos, integridade e consultas SQL

---

## ⚠️ Aviso Importante sobre os Dados

> Todos os dados apresentados neste repositório são **fictícios** e foram utilizados **exclusivamente para fins acadêmicos e de teste**.

- Nenhuma informação pessoal real foi utilizada  
- Nomes, e-mails, ativos e incidentes são **simulados**  
- O objetivo é apenas demonstrar a **modelagem, estrutura e funcionamento do banco de dados**

Este projeto **não representa dados reais de pessoas, empresas ou sistemas** e não deve ser utilizado em ambiente de produção sem as devidas adaptações e validações de segurança.

---
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


INSERT INTO ativo_digital (nome_ativo, tipo_ativo, criticidade) VALUES
('Servidor Web Principal', 'Servidor', 'Alta'),
('Servidor de Banco de Dados', 'Servidor', 'Alta'),
('Sistema Financeiro', 'Sistema', 'Alta'),
('Sistema de RH', 'Sistema', 'Media'),
('Firewall Corporativo', 'Seguranca', 'Alta'),
('Servidor de Backup', 'Servidor', 'Media'),
('Portal do Cliente', 'Aplicacao Web', 'Media'),
('Servidor de Email', 'Servidor', 'Alta'),
('Sistema de Vendas', 'Sistema', 'Alta'),
('Servidor de Arquivos', 'Servidor', 'Media');

INSERT INTO tipo_incidente (descricao, severidade) VALUES
('Acesso nao autorizado', 'Critica'),
('Malware detectado', 'Alta'),
('Indisponibilidade de servico', 'Alta'),
('Tentativa de phishing', 'Media'),
('Vazamento de dados', 'Critica'),
('Falha de autenticacao', 'Media'),
('Ataque de forca bruta', 'Alta');


INSERT INTO analista (nome, email) VALUES
('Ana Flavia Santana', 'ana.santana@secureops.com'),
('Carlos Henrique Lima', 'carlos.lima@secureops.com'),
('Mariana Souza', 'mariana.souza@secureops.com'),
('Joao Pedro Alves', 'joao.alves@secureops.com'),
('Lucas Ferreira', 'lucas.ferreira@secureops.com');

INSERT INTO incidente (status, impacto_financeiro, id_ativo, id_tipo, id_analista) VALUES
('Detectado', 1200.00, 1, 1, 1),
('Em_Analise', 0.00, 2, 3, 2),
('Resolvido', 3500.50, 3, 5, 3),
('Contido', NULL, 4, 4, 4),
('Encerrado', 8000.00, 5, 7, 5),
('Detectado', 500.00, 6, 2, 1),
('Em_Analise', NULL, 7, 6, 2),
('Resolvido', 1500.00, 8, 3, 3),
('Encerrado', 2000.00, 9, 1, 4),
('Detectado', 0.00, 10, 2, 5);


INSERT INTO acao_corretiva (descricao, id_tipo) VALUES
('Bloqueio imediato do acesso suspeito', 1),
('Analise de logs e redefinicao de credenciais', 1),
('Isolamento da maquina infectada', 2),
('Execucao de antivirus corporativo', 2),
('Reinicializacao controlada do servico', 3),
('Aplicacao de patches de seguranca', 3),
('Bloqueio de dominio malicioso', 4),
('Treinamento de conscientizacao para usuarios', 4),
('Notificacao a diretoria e orgaos competentes', 5),
('Revisao de politicas de seguranca', 5),
('Bloqueio temporario de contas', 6),
('Reforco na politica de senhas', 6),
('Bloqueio de IP suspeito', 7),
('Configuracao de rate limit no sistema', 7);








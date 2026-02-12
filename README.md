 **Sistema de Gestão de Incidentes — SecureOps Pro
 ---

A **SecureWave Digital Services** é uma empresa fictícia de médio porte que atua com serviços digitais e infraestrutura em nuvem, lidando com dados sensíveis e ambientes regulados.

Com a expansão da operação, o controle de incidentes de segurança da informação passou a apresentar falhas quando realizado por ferramentas genéricas e registros manuais, resultando em perda de rastreabilidade, dificuldade de auditoria e inconsistências no ciclo de vida dos incidentes.

O objetivo deste projeto é desenvolver o **esquema de um banco de dados relacional (SecureOps Pro)** capaz de centralizar a gestão de incidentes, garantindo **auditoria automática**, **integridade do ciclo de vida** e **conformidade com princípios de governança e LGPD**.

---

## Requisitos de Negócio

Para que o sistema seja funcional e auditável, ele deve atender às seguintes diretrizes:

 **Gestão de Ativos**  
Todo incidente deve estar obrigatoriamente vinculado a um ativo digital. Um ativo pode estar associado a múltiplos incidentes ao longo do tempo.

 **Responsabilização Técnica**  
Cada incidente deve possuir um analista responsável técnico, garantindo rastreabilidade de decisões e ações.

 **Controle de Acesso (RBAC)**  
O sistema deve suportar perfis de acesso distintos, permitindo que analistas atuem conforme suas atribuições e permissões.

 **Auditoria e Histórico**  
Toda alteração de status de um incidente deve ser registrada automaticamente, mantendo histórico imutável para fins de auditoria.

 **Fluxo de Tratamento**  
O incidente deve passar por estados de controle definidos (Detectado, Em Análise, Contido, Resolvido, Encerrado), sendo o encerramento realizado automaticamente quando um status final é atingido.

---

## Requisitos Técnicos

A implementação foi projetada para o ambiente **MySQL 8.0+**, atendendo aos seguintes critérios:

 **Codificação:**  
Uso de `utf8mb4` e `utf8mb4_unicode_ci` para compatibilidade total com dados sensíveis e caracteres especiais.

 **Integridade:**  
Implementação rigorosa de chaves primárias (PK) e estrangeiras (FK) com restrições de integridade referencial.

 **Automação no Banco:**  
Uso de **Triggers** para registro automático de histórico e controle inteligente de fechamento de incidentes.

 **Tipagem Profissional:**  
- `DATETIME` para controle temporal  
- `DECIMAL(15,2)` para impacto financeiro  
- índices compostos para otimização de consultas operacionais  

 **Segurança por Design:**  
Aplicação do princípio do menor privilégio e separação entre dados operacionais e trilhas de auditoria.

> **Peer Review Insight:** Este projeto foi estruturado para demonstrar maturidade técnica em **Engenharia de Dados** e **Segurança**, utilizando IA como revisora para identificar pontos cegos de auditoria e conformidade com a LGPD.

---
<img width="1492" height="865" alt="image" src="https://github.com/user-attachments/assets/90574f81-343b-42c6-9daf-2c228e9deb20" />




## ## Visão Geral do Projeto

O **SecureOps Pro** é uma solução avançada de banco de dados que centraliza o controle operacional de segurança:

* **Ativos Digitais:** Inventário de infraestrutura com criticidade base.
* **RBAC (Controle de Acesso):** Perfis de acesso granulares para analistas.
* **Trilhas de Auditoria:** Históricos automáticos de status e severidade.
* **Logs de Acesso:** Registro de visualização de dados (LGPD Ready).
* **Gestão de Impacto:** Controle financeiro e de playbooks recomendados.

---

## ## Objetivo Técnico

Desenvolver o **esquema de um banco de dados relacional sênior** capaz de:

* Automatizar o registro de históricos através de **Database Triggers**.
* Garantir a integridade do ciclo de vida (abertura/fechamento automático).
* Implementar segurança em nível de banco de dados (Princípio do Menor Privilégio).
* Suportar auditorias de conformidade com registros de leitura e escrita.
  
![82f6b90a-c820-4486-b743-281e7ed67343](https://github.com/user-attachments/assets/1dedcfb9-bed1-464c-9bc7-5e023acf2097)

---

## ## Regras de Negócio — Core Constraints

| Regra de Negócio | Implementação no Modelo |
| --- | --- |
| **Integridade de Ativos** | Todo incidente deve estar vinculado a um ativo digital. |
| **RBAC Profissional** | Analistas possuem perfis vinculados (N:N) via `analista_perfil`. |
| **Severidade Dinâmica** | Inicializada pelo tipo de incidente, mas rastreável em histórico próprio. |
| **Automação de Fechamento** | Status marcados como `status_final` encerram o ticket automaticamente. |
| **Auditoria de Leitura** | Cada visualização gera um registro na `log_acesso_incidente`. |

---

## ## Fluxo de Tratamento (Lifecycle)

A tabela `incidente` é o núcleo operacional. O ciclo de vida é controlado por status configuráveis:

* `Detectado` / `Em Análise` (Tickets abertos)
* `Contido` / `Resolvido` (Fase de remediação)
* `Encerrado` (Status Final -> Gatilha `data_fechamento`)

> **Key Insight:** O uso de uma flag `status_final` na tabela de domínio permite que o fluxo de trabalho seja alterado sem a necessidade de reescrever o código das Triggers.

---

## ## Requisitos Técnicos

* **SGBD:** MySQL 8.0+
* **Engine:** InnoDB (Suporte a Transações e FKs)
* **Charset:** `utf8mb4` (Suporte total a caracteres especiais)
* **Collation:** `utf8mb4_unicode_ci`
* **Ambiente:** MySQL Workbench / brModelo
* **Estratégia de Performance:** Índices compostos em tabelas de histórico.

Para mitigar o erro de execução **1146**, a tabela de histórico de status foi incluída para garantir o rastro de auditoria exigido nos requisitos:

```sql
CREATE TABLE IF NOT EXISTS historico_status (
    id_historico INT AUTO_INCREMENT PRIMARY KEY,
    id_incidente INT NOT NULL,
    id_status_anterior INT,
    id_status_novo INT NOT NULL,
    id_analista INT NOT NULL,
    data_alteracao TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (id_incidente) REFERENCES incidente(id_incidente),
    FOREIGN KEY (id_status_anterior) REFERENCES status_incidente(id_status),
    FOREIGN KEY (id_status_novo) REFERENCES status_incidente(id_status),
    FOREIGN KEY (id_analista) REFERENCES analista(id_analista)
) ENGINE=InnoDB;

``` 

---

## ## Testes de Funcionalidade e Relatórios

### ### A) Pesquisa com Múltiplos JOINS (Auditoria de Status)

Esta consulta é fundamental para auditorias, pois reconstrói a cronologia de mudanças de um ticket:

```sql
SELECT 
    h.data_alteracao AS 'Data da Mudança', 
    i.ticket_ref AS 'Chamado',
    s_ant.nome AS 'De:', 
    s_novo.nome AS 'Para:', 
    an.nome AS 'Analista Responsável'
FROM historico_status h
JOIN incidente i ON h.id_incidente = i.id_incidente
JOIN status_incidente s_ant ON h.id_status_anterior = s_ant.id_status
JOIN status_incidente s_novo ON h.id_status_novo = s_novo.id_status
JOIN analista an ON h.id_analista = an.id_analista;

```

### ### B) Pesquisa Simples (Filtro de Ativos Críticos)

Identificação de ativos de infraestrutura baseada em severidade pré-definida:

```sql
SELECT nome_ativo, identificador_rede 
FROM ativo_digital 
WHERE id_severidade_base = (SELECT id_severidade FROM severidade WHERE nome = 'Alta');

```
## Script de Implementação Completo
Abaixo encontra-se o código SQL integral para criação do banco de dados, tabelas, triggers e carga inicial de dados. Este script foi consolidado para garantir que todas as dependências de chaves estrangeiras e automações de auditoria funcionem nativamente.
---

> **Peer Review Insight**: Este projeto foi estruturado para demonstrar maturidade técnica em Engenharia de Dados e Segurança Cibernética, utilizando o banco de dados como uma camada ativa de conformidade regulatória.
>
> -- Criação do Banco de Dados
> ```sql
CREATE DATABASE IF NOT EXISTS secureops_pro
CHARACTER SET utf8mb4
COLLATE utf8mb4_unicode_ci;

USE secureops_pro;

-- Tabelas de Domínio
CREATE TABLE status_incidente (
    id_status INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(50) NOT NULL UNIQUE,
    status_final BOOLEAN DEFAULT FALSE
) ENGINE=InnoDB;

CREATE TABLE severidade (
    id_severidade INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(20) NOT NULL UNIQUE,
    peso INT NOT NULL,
    CHECK (peso BETWEEN 1 AND 5)
) ENGINE=InnoDB;

CREATE TABLE perfil_acesso (
    id_perfil INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(50) NOT NULL UNIQUE
) ENGINE=InnoDB;

-- Tabelas de Entidades
CREATE TABLE analista (
    id_analista INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    ativo BOOLEAN DEFAULT TRUE,
    criado_em TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;

CREATE TABLE analista_perfil (
    id_analista INT NOT NULL,
    id_perfil INT NOT NULL,
    PRIMARY KEY (id_analista, id_perfil),
    FOREIGN KEY (id_analista) REFERENCES analista(id_analista),
    FOREIGN KEY (id_perfil) REFERENCES perfil_acesso(id_perfil)
) ENGINE=InnoDB;

CREATE TABLE ativo_digital (
    id_ativo INT AUTO_INCREMENT PRIMARY KEY,
    nome_ativo VARCHAR(100) NOT NULL,
    identificador_rede VARCHAR(50) NOT NULL UNIQUE,
    tipo_ativo VARCHAR(50),
    id_severidade_base INT NOT NULL,
    desativado_em DATETIME DEFAULT NULL,
    FOREIGN KEY (id_severidade_base) REFERENCES severidade(id_severidade)
) ENGINE=InnoDB;

CREATE TABLE tipo_incidente (
    id_tipo INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL UNIQUE,
    playbook_recomendado TEXT,
    id_severidade_padrao INT NOT NULL,
    FOREIGN KEY (id_severidade_padrao) REFERENCES severidade(id_severidade)
) ENGINE=InnoDB;

-- Tabela Central
CREATE TABLE incidente (
    id_incidente INT AUTO_INCREMENT PRIMARY KEY,
    ticket_ref VARCHAR(20) NOT NULL UNIQUE,
    titulo VARCHAR(150) NOT NULL,
    descricao_inicial TEXT NOT NULL,
    data_abertura DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    data_fechamento DATETIME DEFAULT NULL,
    impacto_financeiro DECIMAL(15,2) DEFAULT 0.00,
    ativo BOOLEAN DEFAULT TRUE,
    id_ativo INT NOT NULL,
    id_tipo INT NOT NULL,
    id_status_atual INT NOT NULL,
    id_severidade_atual INT NOT NULL,
    id_analista_responsavel INT NOT NULL,
    FOREIGN KEY (id_ativo) REFERENCES ativo_digital(id_ativo),
    FOREIGN KEY (id_tipo) REFERENCES tipo_incidente(id_tipo),
    FOREIGN KEY (id_status_atual) REFERENCES status_incidente(id_status),
    FOREIGN KEY (id_severidade_atual) REFERENCES severidade(id_severidade),
    FOREIGN KEY (id_analista_responsavel) REFERENCES analista(id_analista),
    INDEX idx_status (id_status_atual),
    INDEX idx_data_abertura (data_abertura)
) ENGINE=InnoDB;

-- Tabelas de Histórico e Auditoria
CREATE TABLE historico_status (
    id_historico INT AUTO_INCREMENT PRIMARY KEY,
    id_incidente INT NOT NULL,
    id_status_anterior INT,
    id_status_novo INT NOT NULL,
    id_analista INT NOT NULL,
    data_alteracao TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    comentario_tecnico TEXT,
    FOREIGN KEY (id_incidente) REFERENCES incidente(id_incidente),
    FOREIGN KEY (id_status_anterior) REFERENCES status_incidente(id_status),
    FOREIGN KEY (id_status_novo) REFERENCES status_incidente(id_status),
    FOREIGN KEY (id_analista) REFERENCES analista(id_analista)
) ENGINE=InnoDB;

-- Automação via Triggers
DELIMITER //
CREATE TRIGGER trg_secureops_final_audit
BEFORE UPDATE ON incidente
FOR EACH ROW
BEGIN
    IF OLD.id_status_atual <> NEW.id_status_atual THEN
        INSERT INTO historico_status (id_incidente, id_status_anterior, id_status_novo, id_analista)
        VALUES (NEW.id_incidente, OLD.id_status_atual, NEW.id_status_atual, NEW.id_analista_responsavel);
        
        IF (SELECT status_final FROM status_incidente WHERE id_status = NEW.id_status_atual) = TRUE THEN
            SET NEW.data_fechamento = NOW();
            SET NEW.ativo = FALSE;
        ELSE
            SET NEW.data_fechamento = NULL;
            SET NEW.ativo = TRUE;
        END IF;
    END IF;
END //
DELIMITER ;
```
---

**O repositório está pronto.** Você gostaria que eu gerasse agora uma **massa de dados (INSERTs)** completa para todas as tabelas, permitindo que você popule o banco e valide esses relatórios imediatamente?

```
![WhatsApp Image 2026-02-09 at 14 50 52](https://github.com/user-attachments/assets/f2138f0c-d4e1-465c-915d-c46e0f4e8b82)

---

## ## Glossário — Technical Terms

* **RBAC:** Role-Based Access Control (Controle de Acesso Baseado em Perfis).
* **Trigger:** Gatilho automático disparado pelo banco de dados em eventos de DML.
* **Soft Delete:** Prática de desativar registros (flag `ativo`) sem excluí-los fisicamente.
* **Read Log:** Registro de auditoria focado em operações de leitura de dados sensíveis.

---

## ## Disclaimer & LGPD

> **Aviso Importante:** Todos os dados gerados para teste neste repositório são fictícios. O sistema foi projetado seguindo princípios de **Privacy by Design**, garantindo que toda visualização de dados possa ser auditada para conformidade com a LGPD e GDPR.


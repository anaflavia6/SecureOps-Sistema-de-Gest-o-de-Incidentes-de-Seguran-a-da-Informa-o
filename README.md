
# # SQL — CyberSecurity Database Design: SecureOps Pro

Desenvolvimento de um **Sistema de Gestão de Incidentes de Segurança da Informação (SecureOps Pro)**, com foco em **automação de auditoria**, **rastreabilidade total** e **conformidade (Compliance)**.

Este projeto apresenta uma modelagem de banco de dados relacional de nível sênior, incluindo **Triggers** para controle de ciclo de vida e **RBAC** para controle de acesso.

> **Peer Review Insight:** Este projeto foi estruturado para demonstrar maturidade técnica em **Engenharia de Dados** e **Segurança**, utilizando IA como revisora para identificar pontos cegos de auditoria e conformidade com a LGPD.

---
![0169116a-02f5-4f40-83f1-80d9cbedc2bd](https://github.com/user-attachments/assets/9cdffef6-c44d-4883-8c8c-01d661246e28)


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
  
![b7ecee3a-b84c-4d80-b496-dc308434434c](https://github.com/user-attachments/assets/2b6e1e95-e639-48ac-8c13-aeadab24d7da)

---

## ## Physical Model — Database Implementation

```sql
-- Criação do Banco de Dados Sênior
CREATE DATABASE IF NOT EXISTS secureops_pro
CHARACTER SET utf8mb4
COLLATE utf8mb4_unicode_ci;

USE secureops_pro;

-- Tabela Central de Incidentes com Severidade Dinâmica
CREATE TABLE incidente (
    id_incidente INT AUTO_INCREMENT PRIMARY KEY,
    ticket_ref VARCHAR(20) NOT NULL UNIQUE,
    titulo VARCHAR(150) NOT NULL,
    data_abertura DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    data_fechamento DATETIME DEFAULT NULL,
    impacto_financeiro DECIMAL(15,2) DEFAULT 0.00,
    id_ativo INT NOT NULL,
    id_status_atual INT NOT NULL,
    id_analista_responsavel INT NOT NULL,
    FOREIGN KEY (id_ativo) REFERENCES ativo_digital(id_ativo),
    FOREIGN KEY (id_status_atual) REFERENCES status_incidente(id_status),
    FOREIGN KEY (id_analista_responsavel) REFERENCES analista(id_analista),
    INDEX idx_performance (id_status_atual, data_abertura)
) ENGINE=InnoDB;

-- Automação de Auditoria via Trigger
DELIMITER //
CREATE TRIGGER trg_incidente_before_update
BEFORE UPDATE ON incidente
FOR EACH ROW
BEGIN
    -- Registro Automático de Mudança de Status
    IF OLD.id_status_atual <> NEW.id_status_atual THEN
        INSERT INTO historico_status (id_incidente, id_status_anterior, id_status_novo, id_analista)
        VALUES (NEW.id_incidente, OLD.id_status_atual, NEW.id_status_atual, NEW.id_analista_responsavel);
        
        -- Lógica de Fechamento Inteligente
        IF (SELECT status_final FROM status_incidente WHERE id_status = NEW.id_status_atual) = TRUE THEN
            SET NEW.data_fechamento = NOW();
        ELSE
            SET NEW.data_fechamento = NULL;
        END IF;
    END IF;
END; //
DELIMITER ;

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


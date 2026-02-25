-- ==========================================================
-- SECUREOPS PRO - CAMADA ANALÍTICA AVANÇADA
-- ==========================================================

-- 1. TENDÊNCIA MONTH-OVER-MONTH (MoM)
-- Analisa o crescimento percentual de incidentes entre meses.
WITH Mensal_Stats AS (
    SELECT 
        DATE_FORMAT(data_abertura, '%Y-%m') AS periodo,
        COUNT(*) AS volume_total
    FROM incidente
    WHERE status <> 'Falso Positivo'
    GROUP BY periodo
)
SELECT 
    periodo,
    volume_total,
    LAG(volume_total) OVER (ORDER BY periodo) AS volume_mes_anterior,
    ROUND(((volume_total - LAG(volume_total) OVER (ORDER BY periodo)) / NULLIF(LAG(volume_total) OVER (ORDER BY periodo), 0)) * 100, 2) AS variacao_percentual_mom
FROM Mensal_Stats;

-- 2. VOLATILIDADE E MÉDIA MÓVEL (ANOMALIAS)
-- Identifica picos fora do desvio padrão histórico.
SELECT 
    DATE(data_abertura) AS data_referencia,
    COUNT(*) AS volume_diario,
    AVG(COUNT(*)) OVER (ORDER BY DATE(data_abertura) ROWS BETWEEN 7 PRECEDING AND CURRENT ROW) AS media_movel_7d,
    STDDEV(COUNT(*)) OVER () AS desvio_padrao_historico
FROM incidente
GROUP BY data_referencia;

-- 3. VIEW DE PRIORIZAÇÃO POR RISCO PONDERADO (R = S x C)
-- Cruza severidade técnica com criticidade do ativo para triagem automática.
CREATE OR REPLACE VIEW vw_priorizacao_operacional_soc AS
WITH RiscoCalculado AS (
    SELECT 
        i.id_incidente,
        s.nome AS severidade_tecnica,
        a.nome AS ativo_afetado,
        (s.peso_severidade * a.criticidade_negocio) AS score_risco_ponderado,
        i.status
    FROM incidente i
    JOIN severidade s ON i.id_severidade_atual = s.id_severidade
    JOIN ativo a ON i.id_ativo = a.id_ativo
    WHERE i.status NOT IN ('Fechado', 'Falso Positivo')
)
SELECT *,
    CASE 
        WHEN score_risco_ponderado >= 20 THEN 'CRÍTICO'
        WHEN score_risco_ponderado >= 12 THEN 'ALTO'
        ELSE 'NORMAL'
    END AS categoria_urgencia
FROM RiscoCalculado
ORDER BY score_risco_ponderado DESC;

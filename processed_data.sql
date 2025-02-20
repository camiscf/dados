WITH base AS (
    SELECT
        -- Padronizando colunas booleanas para 0 e 1
        CASE WHEN obito IN ('True', '1') THEN 1 ELSE 0 END AS obito,
        CASE WHEN luz_eletrica IN ('True', '1') THEN 1 ELSE 0 END AS luz_eletrica,
        CASE WHEN em_situacao_de_rua IN ('True', '1') THEN 1 ELSE 0 END AS em_situacao_de_rua,
        CASE WHEN vulnerabilidade_social IN ('True', '1') THEN 1 ELSE 0 END AS vulnerabilidade_social,
        CASE WHEN familia_beneficiaria_auxilio_brasil IN ('True', '1') THEN 1 ELSE 0 END AS familia_beneficiaria_auxilio_brasil,
        CASE WHEN crianca_matriculada_creche_pre_escola IN ('True', '1') THEN 1 ELSE 0 END AS crianca_matriculada_creche_pre_escola,
        
        -- Padronização de datas
        TRY_CAST(data_cadastro AS DATE) AS data_cadastro,
        TRY_CAST(data_nascimento AS DATE) AS data_nascimento,
        TRY_CAST(updated_at AS DATE) AS updated_at,

        -- Padronizando bairros (removendo espaços extras e ajustando capitalização)
        INITCAP(TRIM(bairro)) AS bairro,
        
        -- Padronização de raça/cor removendo valores inválidos
        CASE 
            WHEN raca_cor IN ('Parda', 'Branca', 'Preta', 'Amarela', 'Indígena') THEN raca_cor
            ELSE 'Não Informado' 
        END AS raca_cor,
        
        -- Padronização de religião removendo valores inconsistentes
        CASE 
            WHEN religiao IN ('Sem religião', 'Católica', 'Evangélica', 'Espírita', 'Religião de matriz africana', 'Budismo', 'Judaísmo', 'Islamismo', 'Candomblé') THEN religiao
            ELSE 'Outra' 
        END AS religiao,
        
        -- Tratamento de renda familiar removendo valores inválidos
        CASE 
            WHEN renda_familiar LIKE '%Salário Mínimo%' THEN renda_familiar
            ELSE 'Não Informado' 
        END AS renda_familiar,
        
        -- Padronização de meios de transporte removendo listas vazias e decodificando caracteres
        REPLACE(REPLACE(meios_transporte, '["', ''), '"]', '') AS meios_transporte,
        
        -- Padronização de doenças e condições de saúde
        REPLACE(REPLACE(doencas_condicoes, '["', ''), '"]', '') AS doencas_condicoes,
        
        -- Padronização de meios de comunicação
        REPLACE(REPLACE(meios_comunicacao, '["', ''), '"]', '') AS meios_comunicacao,
        
        -- Padronização da situação profissional
        CASE 
            WHEN situacao_profissional IN ('Emprego Formal', 'Desempregado', 'Emprego Informal', 'Pensionista / Aposentado', 'Autônomo', 'Outro', 'Não trabalha', 'Empregador') THEN situacao_profissional
            ELSE 'Não Informado' 
        END AS situacao_profissional
    FROM fonte_dados
)
SELECT * FROM base;


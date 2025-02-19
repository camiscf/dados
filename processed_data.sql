WITH raw_data AS (
    SELECT * FROM {{ source('staging', 'dados_ficha_a_desafio') }}
),

cleaned_data AS (
    SELECT
        id_paciente,
        LOWER(TRIM(sexo)) AS sexo_padronizado,
        CASE 
            WHEN LOWER(TRIM(obito)) IN ('true', '1', 'sim') THEN TRUE
            WHEN LOWER(TRIM(obito)) IN ('false', '0', 'nao', 'não') THEN FALSE
            ELSE NULL
        END AS obito,
        INITCAP(TRIM(bairro)) AS bairro,
        INITCAP(TRIM(raca_cor)) AS raca_cor,
        INITCAP(TRIM(ocupacao)) AS ocupacao,
        INITCAP(TRIM(religiao)) AS religiao,
        CASE 
            WHEN luz_eletrica IN ('1', 'true', 'sim') THEN TRUE
            WHEN luz_eletrica IN ('0', 'false', 'nao', 'não') THEN FALSE
            ELSE NULL
        END AS luz_eletrica,
        SAFE.PARSE_DATE('%Y-%m-%d', data_cadastro) AS data_cadastro,
        SAFE.PARSE_DATE('%Y-%m-%d', data_nascimento) AS data_nascimento,
        COALESCE(altura, NULL) AS altura,
        COALESCE(peso, NULL) AS peso,
        GREATEST(0, pressao_sistolica) AS pressao_sistolica,
        GREATEST(0, pressao_diastolica) AS pressao_diastolica,
        SAFE.PARSE_DATE('%Y-%m-%d', updated_at) AS updated_at,
        tipo
    FROM raw_data
)

SELECT * FROM cleaned_data

SELECT DISTINCT
        atendime.cd_atendimento,
        paciente.nm_paciente,
        leito.ds_leito, 
        unid_int.ds_unid_int,
        pagu_avaliacao.cd_formula,
        To_Char(atendime.hr_atendimento,'DD/MM/YYYY:HH24:MI:SS'),
        To_Char(pagu_avaliacao.dh_avaliacao,'DD/MM/YYYY:HH24:MI:SS'),
        pagu_avaliacao.vl_resultado ,    
        CASE                                                                 
        WHEN  pagu_avaliacao.vl_resultado BETWEEN 0 AND 5 THEN 'BAIXO RISCO' 
        WHEN  pagu_avaliacao.vl_resultado BETWEEN 6 AND 13 THEN 'RISCO MODERADO' 
        WHEN  pagu_avaliacao.vl_resultado BETWEEN 13 AND 28 THEN 'ALTO RISCO'
        WHEN  pagu_avaliacao.vl_resultado IS NULL THEN 'DOCUMENTO NÃO FECHADO'
        END avaliacao                                                                 
      FROM
          atendime,
          paciente,
          leito,
          unid_int,                                                                                                  
          pagu_avaliacao 

      WHERE 
1=1
      AND atendime.cd_atendimento = pagu_avaliacao.cd_atendimento                                                                                                
      AND atendime.dt_alta IS NULL                                          
      AND atendime.cd_paciente = paciente.cd_paciente           
      AND atendime.cd_leito = leito.cd_leito (+)                 
      AND leito.cd_unid_int = unid_int.cd_unid_int (+)                                                                                
      AND ATENDIME.TP_ATENDIMENTO IN ('I') 
      AND pagu_avaliacao.dh_avaliacao IN (SELECT MAX(dh_avaliacao)cd_avaliacao  FROM 
PAGU_AVALIACAO WHERE cd_formula = 98 GROUP BY cd_atendimento ) 
      AND atendime.cd_atendimento NOT IN (6)     
      AND PAGU_AVALIACAO.CD_FORMULA = 98                                                                                                                                                                                        
AND pagu_avaliacao.dh_avaliacao BETWEEN @DATA_INI AND @DATA_FIM
ORDER BY 4,3,9

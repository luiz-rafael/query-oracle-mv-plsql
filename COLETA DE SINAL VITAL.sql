SELECT  documento
       ,nm_prestador
       ,nm_tip_presta
--       ,DBAMV.FNC_BUSCA_EMPRESA_REPO({V_EMPRESA}) EMPRESA
--       ,DBAMV.fnc_busca_esp_prest(cd_prestador) ESPEC
       ,Count(*)total_DOC

    FROM(

        SELECT  *
          FROM pw_documento_clinico
              ,pw_tipo_documento
              ,PAGU_OBJETO
              ,PRESTADOR
              ,ATENDIME
              ,tip_presta
          WHERE pw_documento_clinico.cd_tipo_documento = pw_tipo_documento.cd_tipo_documento
          AND   pw_documento_clinico.cd_objeto         = PAGU_OBJETO.cd_objeto
          AND   PRESTADOR.cd_prestador                 = pw_documento_clinico.cd_prestador
          AND   ATENDIME.cd_atendimento                = pw_documento_clinico.cd_atendimento
--          AND   ATENDIME.cd_multi_empresa              = ({V_EMPRESA})
          AND   ATENDIME.cd_multi_empresa              IN(1)
          AND   tip_presta.cd_tip_presta               = PRESTADOR.cd_tip_presta
          AND   pw_documento_clinico.tp_status         = 'FECHADO'
          AND  (nm_documento in ('[MV2000] Afericao') or nm_objeto = 'SINAIS VITAIS')
--          AND   nm_documento = '[MV2000] Afericao'
--          AND   Trunc(ATENDIME.dt_atendimento) between to_date ( '01/10/2020' , 'dd/mm/yyyy' ) and to_date ('27/11/2020' , 'dd/mm/yyyy' )
--          AND to_date(ATENDIME.dt_atendimento,'dd/mm/yyyy')between to_date(@P_DT_INICIO ,'dd/mm/yyyy')AND  to_date(@P_DT_FIM,'dd/mm/yyyy')
    --      AND pw_documento_clinico.cd_prestador        = 1
                                                                        )
  GROUP BY documento
          ,nm_prestador
          ,nm_tip_presta
          ,cd_prestador

  ORDER BY 2


ITCOLETA_SINAL_VITAL
COLETA_SINAL_VITAL

SELECT *
  FROM COLETA_SINAL_VITAL
      ,ITCOLETA_SINAL_VITAL
  WHERE COLETA_SINAL_VITAL.cd_coleta_sinal_vital = ITCOLETA_SINAL_VITAL.cd_coleta_sinal_vital
  AND cd_atendimento = 2000
  AND cd_sinal_vital = 1


--SELECT DISTINCT Decode(nm_documento,NULL,nm_objeto,nm_documento) documento
--    FROM  pw_documento_clinico
--         ,PAGU_OBJETO
--    WHERE pw_documento_clinico.cd_objeto         = PAGU_OBJETO.cd_objeto
--    AND (nm_documento in ('[MV2000] Afericao') or nm_objeto = 'SINAIS VITAIS')
--    ORDER BY 1


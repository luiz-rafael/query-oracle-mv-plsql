select avi_cir.cd_aviso_cirurgia          cd_aviso_cirurgia
      ,avi_cir.cd_atendimento             cd_atendimento
      ,avi_cir.cd_paciente                cd_paciente
      ,avi_cir.nm_paciente                nm_paciente
      ,trunc(avi_cir.dt_realizacao)       dt_realizacao
      ,DECODE(nvl(CIR_AVI.DS_NPADRONIZADO,'XXX'), 'XXX'
        , CIRURGIA.DS_CIRURGIA
        , 'N.P.' || CIR_AVI.DS_NPADRONIZADO )   ds_cirurgia
      ,(SELECT nm_prestador FROM PRESTADOR WHERE cd_prestador = dbamv.f_verif_prestador(avi_cir.cd_aviso_cirurgia, cirurgia.cd_cirurgia)) cirurgiao
      , trunc(NVL(ATENDIME.DT_ALTA, TRUNC(SYSDATE)) - TRUNC(ATENDIME.DT_ATENDIMENTO)) QTD_DIAS_INT
      from
             dbamv.aviso_cirurgia      avi_cir
            ,dbamv.cirurgia            cirurgia
            ,dbamv.cirurgia_aviso      cir_avi
            ,dbamv.atendime            atendime
            ,(select avi_cir.cd_atendimento  cd_atendimento
                    ,Count(*)                total
                    FROM
                          dbamv.aviso_cirurgia      avi_cir
                          ,dbamv.atendime            atendime
                    Where 1=1
                    and   avi_cir.tp_situacao          = 'R'
                    and   avi_cir.cd_atendimento       = atendime.cd_atendimento
--                    AND TRUNC(avi_cir.DT_REALIZACAO) BETWEEN '01/03/2022' AND '18/03/2022'
                    AND trunc(avi_cir.DT_REALIZACAO) BETWEEN trunc(@P_DT_INICIO) AND trunc(@P_DT_FIM)
                    having  Count(*) > 1
                    GROUP BY avi_cir.cd_atendimento)TOTAL_CIR

      Where 1=1
      And   avi_cir.cd_aviso_cirurgia    = cir_avi.cd_aviso_cirurgia
      and   cir_avi.cd_cirurgia          = cirurgia.cd_cirurgia
      and   avi_cir.tp_situacao          = 'R'
      and   avi_cir.cd_atendimento       = atendime.cd_atendimento
      AND   atendime.cd_atendimento = TOTAL_CIR.cd_atendimento
      AND trunc(avi_cir.DT_REALIZACAO) BETWEEN trunc(@P_DT_INICIO) AND trunc(@P_DT_FIM)
--      AND TRUNC(avi_cir.DT_REALIZACAO) BETWEEN '01/03/2022' AND '18/03/2022'


--ORDER BY 2








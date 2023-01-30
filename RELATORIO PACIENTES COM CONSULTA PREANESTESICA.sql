select avi_cir.cd_aviso_cirurgia          cd_aviso_cirurgia
      ,avi_cir.cd_atendimento             cd_atendimento
      ,avi_cir.cd_paciente                cd_paciente
      ,avi_cir.nm_paciente                nm_paciente
      ,convenio.nm_convenio             nm_convenio
      ,trunc(avi_cir.dt_realizacao)       dt_realizacao
      ,TIP_ANEST.DS_TIP_ANEST             DS_TIP_ANEST
      ,leito.ds_resumo                    ds_resumo
      ,DECODE(nvl(CIR_AVI.DS_NPADRONIZADO,'XXX'), 'XXX'
        , CIRURGIA.DS_CIRURGIA
        , 'N.P.' || CIR_AVI.DS_NPADRONIZADO )   ds_cirurgia
      ,(SELECT nm_prestador FROM PRESTADOR WHERE cd_prestador = dbamv.f_verif_prestador(avi_cir.cd_aviso_cirurgia, cirurgia.cd_cirurgia)) cirurgiao
      ,(SELECT nm_prestador FROM PRESTADOR WHERE cd_prestador = dbamv.f_verif_prestador_anest(avi_cir.cd_aviso_cirurgia, cirurgia.cd_cirurgia)) ANESTESISTA
      ,Decode(SUBSTR(PREOPERATORIO.CONSUL_PRE_ANEST,5,3),NULL, 'NÃO',SUBSTR(PREOPERATORIO.CONSUL_PRE_ANEST,5,3)) CONSUL_PRE_ANEST
      from   dbamv.cen_cir             cen_cir
            ,dbamv.sal_cir             sal_cir
            ,dbamv.aviso_cirurgia      avi_cir
            ,dbamv.cirurgia            cirurgia
            ,dbamv.cirurgia_aviso      cir_avi
            ,dbamv.atendime            atendime
            ,dbamv.leito               leito
            ,dbamv.convenio            convenio
            ,Dbamv.Empresa_Convenio
            ,DBAMV.TIP_ANEST
            ,DBAMV.TIP_ANEST_AVISO_CIRURGIA
            ,(SELECT  evd.CD_DOCUMENTO
                    , cd_editor_registro
                    , dbamv.fnc_painel_ret_vl_campo_doc(pregistro=>b.cd_editor_registro, pidentificador=>'CB_SN_REALIZOU_CONSULTA_PRE_ANESTESICA_1') CONSUL_PRE_ANEST -- 893
                    , a.cd_atendimento
                    , a.cd_usuario
                    , a.dh_criacao
                    , TP_STATUS Status
                    , nm_documento
                  FROM dbamv.pw_documento_clinico   a
                    , dbamv.pw_editor_clinico       b
                    , DBAMV.editor_registro         r
                    , dbamv.editor_layout           el
                    , dbamv.editor_versao_documento evd
                WHERE a.cd_documento_clinico = b.cd_documento_clinico
                  AND r.cd_registro          = b.cd_editor_registro
                  AND r.cd_layout            = el.cd_layout
                  AND el.cd_versao_documento = evd.cd_versao_documento
                  AND el.ds_layout           = 'Tela'
                  AND a.TP_STATUS IN ('FECHADO','ASSINADO')
                  AND SUBSTR(DBAMV.fnc_painel_ret_vl_campo_doc(pregistro=>b.cd_editor_registro, pidentificador=>'CB_SN_REALIZOU_CONSULTA_PRE_ANESTESICA_1'),5,3) = 'SIM'
                  AND evd.CD_DOCUMENTO       IN (892))PREOPERATORIO
      Where Empresa_Convenio.Cd_Convenio = Convenio.Cd_Convenio
      And   avi_cir.cd_aviso_cirurgia    = cir_avi.cd_aviso_cirurgia
      and   cir_avi.cd_cirurgia          = cirurgia.cd_cirurgia
      and   cir_avi.cd_convenio          = convenio.cd_convenio
--      AND   convenio.cd_convenio         IN (45)
      AND   TIP_ANEST.cd_tip_anest       NOT IN (17,49)
      and   avi_cir.cd_sal_cir           = sal_cir.cd_sal_cir
      and   avi_cir.cd_cen_cir           = cen_cir.cd_cen_cir
      and   avi_cir.tp_situacao          = 'R'
      and   avi_cir.cd_atendimento       = atendime.cd_atendimento
      and   atendime.cd_leito            = leito.cd_leito(+)
      AND   atendime.cd_atendimento      = PREOPERATORIO.cd_atendimento(+)
      AND   TIP_ANEST_AVISO_CIRURGIA.CD_TIP_ANEST	        = TIP_ANEST.CD_TIP_ANEST(+)
      AND   TIP_ANEST_AVISO_CIRURGIA.CD_AVISO_CIRURGIA(+) = avi_cir.CD_AVISO_CIRURGIA
--      AND   atendime.cd_atendimento      =  22255
--      AND   atendime.cd_atendimento      =  18076
      AND trunc(avi_cir.DT_REALIZACAO) BETWEEN trunc(@P_DT_INICIO) AND trunc(@P_DT_FIM)
--      AND TRUNC(avi_cir.DT_REALIZACAO) BETWEEN '01/03/2022' AND '19/03/2022'


--ORDER BY 1



--SELECT * FROM convenio  WHERE nm_convenio  LIKE '%PREF%'

--SELECT * FROM TIP_ANEST  WHERE ds_tip_anest LIKE '%LOCAL%'



--PACIENTES COM CONSULTA PREANESTESICA
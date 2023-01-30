select
       avi_cir.cd_aviso_cirurgia          cd_aviso_cirurgia
      ,avi_cir.cd_atendimento             cd_atendimento
      ,avi_cir.cd_paciente                cd_paciente
      ,avi_cir.nm_paciente                nm_paciente
      ,trunc(avi_cir.dt_realizacao)       dt_realizacao
      ,TIP_ANEST.DS_TIP_ANEST             DS_TIP_ANEST
      ,leito.ds_resumo                    ds_resumo
      ,DECODE(nvl(CIR_AVI.DS_NPADRONIZADO,'XXX'), 'XXX'
        , CIRURGIA.DS_CIRURGIA
        , 'N.P.' || CIR_AVI.DS_NPADRONIZADO )   ds_cirurgia
--      ,dbamv.f_verif_prestador_anest(avi_cir.cd_aviso_cirurgia, cirurgia.cd_cirurgia)    cd_anestesista
      ,(SELECT nm_prestador FROM PRESTADOR WHERE cd_prestador = dbamv.f_verif_prestador_anest(avi_cir.cd_aviso_cirurgia, cirurgia.cd_cirurgia)) ANESTESISTA
      ,POSOPERATORIO.APRES_DOR
      ,POSOPERATORIO.ACAO
      ,POSOPERATORIO.SCORE_DOR
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
                    , dbamv.fnc_retorna_reposta_editor(pCdEditor=>b.cd_editor_registro,pDs_identificador=>'SN_CB_SRPA_APRESENTA_DOR_1',pNumCaracteres=>3,pCarInicial=>5)APRES_DOR
--                    , dbamv.fnc_painel_ret_vl_campo_doc(pregistro=>b.cd_editor_registro, pidentificador=>'SN_CB_SRPA_APRESENTA_DOR_1') APRES_DOR01 -- 893
                    , dbamv.fnc_retorna_reposta_editor(pCdEditor=>b.cd_editor_registro,pDs_identificador=>'DS_HR_SRPA_ESCALA_DOR_1',pNumCaracteres=>10,pCarInicial=>1)SCORE_DOR
--                    , dbamv.fnc_painel_ret_vl_campo_doc(pregistro=>b.cd_editor_registro, pidentificador=>'DS_HR_SRPA_ESCALA_DOR_1') SCORE_DOR -- 893
                    , dbamv.fnc_retorna_reposta_editor(pCdEditor=>b.cd_editor_registro,pDs_identificador=>'DS_ACAO_PARA_DOR_1',pNumCaracteres=>300,pCarInicial=>1)ACAO
--                    , dbamv.fnc_painel_ret_vl_campo_doc(pregistro=>b.cd_editor_registro, pidentificador=>'DS_ACAO_PARA_DOR_1') ACAO -- 893
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
                  AND a.TP_STATUS IN ('ASSINADO','FECHADO')
--                  AND SUBSTR(DBAMV.fnc_painel_ret_vl_campo_doc(pregistro=>b.cd_editor_registro, pidentificador=>'SN_CB_SRPA_APRESENTA_DOR_1'),5,3) = 'SIM'
                  AND dbamv.fnc_retorna_reposta_editor(pCdEditor=>b.cd_editor_registro,pDs_identificador=>'SN_CB_SRPA_APRESENTA_DOR_1',pNumCaracteres=>3,pCarInicial=>5) = 'SIM'
                  AND evd.CD_DOCUMENTO       IN (894))POSOPERATORIO
      Where Empresa_Convenio.Cd_Convenio = Convenio.Cd_Convenio
      And   avi_cir.cd_aviso_cirurgia    = cir_avi.cd_aviso_cirurgia
      and   cir_avi.cd_cirurgia          = cirurgia.cd_cirurgia
      and   cir_avi.cd_convenio          = convenio.cd_convenio
      and   avi_cir.cd_sal_cir           = sal_cir.cd_sal_cir
      and   avi_cir.cd_cen_cir           = cen_cir.cd_cen_cir
      and   avi_cir.tp_situacao          = 'R'
      and   avi_cir.cd_atendimento       = atendime.cd_atendimento
      and   atendime.cd_leito            = leito.cd_leito(+)
      AND   atendime.cd_atendimento      = POSOPERATORIO.cd_atendimento
      AND   TIP_ANEST_AVISO_CIRURGIA.CD_TIP_ANEST	        = TIP_ANEST.CD_TIP_ANEST(+)
      AND   TIP_ANEST_AVISO_CIRURGIA.CD_AVISO_CIRURGIA(+) = avi_cir.CD_AVISO_CIRURGIA
      AND   cir_avi.sn_principal = 'S'
      AND trunc(avi_cir.DT_REALIZACAO) BETWEEN trunc(@P_DT_INICIO) AND trunc(@P_DT_FIM)
--      AND trunc(avi_cir.DT_REALIZACAO) BETWEEN '01/02/2022' AND '21/03/2022'


ORDER BY 1






--SELECT fnc_retorna_reposta_editor(73377,'SN_CB_SRPA_APRESENTA_DOR_1',3,5)campo FROM dual
# .sql file

select avi_cir.cd_aviso_cirurgia          cd_aviso_cirurgia
      ,avi_cir.cd_atendimento             cd_atendimento
      ,avi_cir.cd_paciente                cd_paciente
      ,cir_avi.cd_cirurgia_aviso          cd_cirurgia_aviso
      ,avi_cir.nm_paciente                nm_paciente
      ,avi_cir.nr_telefone_contato        nr_telefone_contato
      ,trunc(avi_cir.dt_realizacao)       dt_realizacao
      ,to_char(avi_cir.dt_realizacao, 'hh24:mi') hr_inicio
      ,to_char(dbamv.soma_sub_data(avi_cir.dt_realizacao,avi_cir.vl_tempo_duracao,'+'),'hh24:mi') hr_fim
      ,(SELECT nm_prestador FROM PRESTADOR WHERE cd_prestador = dbamv.f_verif_prestador(avi_cir.cd_aviso_cirurgia, cirurgia.cd_cirurgia)) cirurgiao
      ,dbamv.f_verif_prestador_anest(avi_cir.cd_aviso_cirurgia, cirurgia.cd_cirurgia)             cd_anestesista
      ,TIP_ANEST.DS_TIP_ANEST             DS_TIP_ANEST
      ,avi_cir.cd_cen_cir                 cd_cen_cir
      ,cen_cir.ds_cen_cir                 ds_cen_cir
      ,sal_cir.ds_sal_cir                 ds_sal_cir
      ,leito.ds_resumo                    ds_resumo
      ,cirurgia.cd_cirurgia               cd_cirurgia
      ,DECODE(nvl(CIR_AVI.DS_NPADRONIZADO,'XXX'), 'XXX'
        , CIRURGIA.DS_CIRURGIA
        , 'N.P.' || CIR_AVI.DS_NPADRONIZADO )   ds_cirurgia
      ,convenio.nm_convenio                     nm_convenio
      ,cirurgia.tp_cirurgia                     tp_cirurgia
      ,TRANSOPERATORIO.PORTAS_FECHADAS
      ,TRANSOPERATORIO.TEMPERA_SALA
      ,TRANSOPERATORIO.HORA_ADM
      ,TRANSOPERATORIO.HORA_INCISAO
      ,TRANSOPERATORIO.NR_PESSOA_SALA
      ,TRANSOPERATORIO.TRICOTOMIA
      ,TRANSOPERATORIO.USO_ATB
      ,PREOPERATORIO.TOMOU_BANHO
      ,PRODUTOS.cd_produto
      ,PRODUTOS.ds_produto
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
--                    , dbamv.fnc_painel_ret_vl_campo_doc(pregistro=>b.cd_editor_registro, pidentificador=>'CB_PORTAS_FECHADAS_TRANSOPERATORIO_1') PORTAS_FECHADAS -- 893
                    , dbamv.fnc_retorna_reposta_editor(pCdEditor=>b.cd_editor_registro,pDs_identificador=>'CB_PORTAS_FECHADAS_TRANSOPERATORIO_1',pNumCaracteres=>3,pCarInicial=>5)PORTAS_FECHADAS


--                    , dbamv.fnc_painel_ret_vl_campo_doc(pregistro=>b.cd_editor_registro, pidentificador=>'DS_QUANTIDADE_DE_PESSOAS_EM_SALA_TRANSOPERATORIO_1') TEMPERA_SALA  -- 893
                    , dbamv.fnc_retorna_reposta_editor(pCdEditor=>b.cd_editor_registro,pDs_identificador=>'DS_QUANTIDADE_DE_PESSOAS_EM_SALA_TRANSOPERATORIO_1',pNumCaracteres=>30,pCarInicial=>1)TEMPERA_SALA


--                    , dbamv.fnc_painel_ret_vl_campo_doc(pregistro=>b.cd_editor_registro, pidentificador=>'HORARIO_DO_ATB_1') HORA_ADM -- 893
                    , dbamv.fnc_retorna_reposta_editor(pCdEditor=>b.cd_editor_registro,pDs_identificador=>'HORARIO_DO_ATB_1',pNumCaracteres=>20,pCarInicial=>1)HORA_ADM

--                    , dbamv.fnc_painel_ret_vl_campo_doc(pregistro=>b.cd_editor_registro, pidentificador=>'HR_INCISAO_CIRURGICA_1') HORA_INCISAO -- 893
                    , dbamv.fnc_retorna_reposta_editor(pCdEditor=>b.cd_editor_registro,pDs_identificador=>'HR_INCISAO_CIRURGICA_1',pNumCaracteres=>20,pCarInicial=>1)HORA_INCISAO


--                    , dbamv.fnc_painel_ret_vl_campo_doc(pregistro=>b.cd_editor_registro, pidentificador=>'DS_TEMPERATURA_DA_SALA_TRANSOPERATORIO_1') NR_PESSOA_SALA   -- 893
                    , dbamv.fnc_retorna_reposta_editor(pCdEditor=>b.cd_editor_registro,pDs_identificador=>'DS_TEMPERATURA_DA_SALA_TRANSOPERATORIO_1',pNumCaracteres=>20,pCarInicial=>1)NR_PESSOA_SALA

--                    , dbamv.fnc_painel_ret_vl_campo_doc(pregistro=>b.cd_editor_registro, pidentificador=>'CB_SN_TRANSOPERATORIO_REALIZADO_TRICOTOMIA_1') TRICOTOMIA  -- 893
                    , dbamv.fnc_retorna_reposta_editor(pCdEditor=>b.cd_editor_registro,pDs_identificador=>'CB_SN_TRANSOPERATORIO_REALIZADO_TRICOTOMIA_1',pNumCaracteres=>3,pCarInicial=>5)TRICOTOMIA

--                    , dbamv.fnc_painel_ret_vl_campo_doc(pregistro=>b.cd_editor_registro, pidentificador=>'DS_LOCAL_TRANSOPERATORIO_1') LOCAL_TRICOTOMIA  -- 893
--                    , dbamv.fnc_painel_ret_vl_campo_doc(pregistro=>b.cd_editor_registro, pidentificador=>'CB_SN_TRANSOPERATORIO_ADMINISTRADO_ANTIBIOTICO_1') USO_ATB  -- 893
                    , dbamv.fnc_retorna_reposta_editor(pCdEditor=>b.cd_editor_registro,pDs_identificador=>'CB_SN_TRANSOPERATORIO_ADMINISTRADO_ANTIBIOTICO_1',pNumCaracteres=>3,pCarInicial=>5)USO_ATB

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
                  AND evd.CD_DOCUMENTO       IN (893))TRANSOPERATORIO
          ,(SELECT
--                    dbamv.fnc_painel_ret_vl_campo_doc(pregistro=>b.cd_editor_registro, pidentificador=>'CK_BANHO_REGISTRO_ENFERMAGEM_1') TOMOU_BANHO -- 892
                    dbamv.fnc_retorna_reposta_editor(pCdEditor=>b.cd_editor_registro,pDs_identificador=>'CK_BANHO_REGISTRO_ENFERMAGEM_1',pNumCaracteres=>3,pCarInicial=>5)TOMOU_BANHO
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
                AND evd.CD_DOCUMENTO       IN (892))PREOPERATORIO
          ,(SELECT DISTINCT
                   produto.cd_produto
                  ,produto.ds_produto
                  ,mvto_estoque.cd_atendimento
              FROM produto
                  ,mvto_estoque
                  ,itmvto_estoque
              WHERE produto.cd_classe = 4
              AND   produto.cd_especie =1
              AND   mvto_estoque.cd_mvto_estoque = itmvto_estoque.cd_mvto_estoque
              AND   itmvto_estoque.cd_produto = produto.cd_produto)PRODUTOS

      Where Empresa_Convenio.Cd_Convenio = Convenio.Cd_Convenio
      And   avi_cir.cd_aviso_cirurgia    = cir_avi.cd_aviso_cirurgia
      and   cir_avi.cd_cirurgia          = cirurgia.cd_cirurgia
      and   cir_avi.cd_convenio          = convenio.cd_convenio
      and   avi_cir.cd_sal_cir           = sal_cir.cd_sal_cir
      and   avi_cir.cd_cen_cir           = cen_cir.cd_cen_cir
      and   avi_cir.tp_situacao          = 'R'
      and   avi_cir.cd_atendimento       = atendime.cd_atendimento
      and   atendime.cd_leito            = leito.cd_leito(+)
      AND   atendime.cd_atendimento      = TRANSOPERATORIO.cd_atendimento(+)
      AND   atendime.cd_atendimento      = PREOPERATORIO.cd_atendimento(+)
      AND   atendime.cd_atendimento      = PRODUTOS.cd_atendimento
      AND   TIP_ANEST_AVISO_CIRURGIA.CD_TIP_ANEST	        = TIP_ANEST.CD_TIP_ANEST(+)
      AND   TIP_ANEST_AVISO_CIRURGIA.CD_AVISO_CIRURGIA(+) = avi_cir.CD_AVISO_CIRURGIA
--      AND   atendime.cd_atendimento      =  22255
--      AND   atendime.cd_atendimento      =  18076
      AND trunc(avi_cir.DT_REALIZACAO) BETWEEN trunc(@P_DT_INICIO) AND trunc(@P_DT_FIM)
--      AND TRUNC(avi_cir.DT_REALIZACAO) BETWEEN '01/03/2022' AND  '15/03/2022'
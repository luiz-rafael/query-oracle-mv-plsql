SELECT * FROM (
select avi_cir.cd_aviso_cirurgia          cd_aviso_cirurgia
      ,avi_cir.cd_atendimento                cd_atendimento
      ,avi_cir.cd_paciente                     cd_paciente
      ,cir_avi.cd_cirurgia_aviso            cd_cirurgia_aviso
      ,avi_cir.nm_paciente                    nm_paciente
      ,avi_cir.nr_telefone_contato         nr_telefone_contato
      ,trunc(avi_cir.dt_realizacao)         dt_realizacao
      ,to_char(avi_cir.dt_realizacao, 'hh24:mi') hr_inicio
      ,to_char(dbamv.soma_sub_data(avi_cir.dt_realizacao,avi_cir.vl_tempo_duracao,'+'),'hh24:mi') hr_fim
      ,(SELECT nm_prestador FROM PRESTADOR WHERE cd_prestador = dbamv.f_verif_prestador(avi_cir.cd_aviso_cirurgia, cirurgia.cd_cirurgia)) cirurgiao
      ,dbamv.f_verif_prestador_anest(avi_cir.cd_aviso_cirurgia, cirurgia.cd_cirurgia)    cd_anestesista
      ,TIP_ANEST.DS_TIP_ANEST
      ,avi_cir.cd_cen_cir                       cd_cen_cir
      ,cen_cir.ds_cen_cir                       ds_cen_cir
      ,sal_cir.ds_sal_cir                       ds_sal_cir
      ,leito.ds_resumo                          ds_resumo
      ,cirurgia.cd_cirurgia                     cd_cirurgia
     -- ,DECODE(CIR_AVI.DS_NPADRONIZADO, NULL
     --                                                                     , CIRURGIA.DS_CIRURGIA
     --                                                                     , 'N.P.' || CIR_AVI.DS_NPADRONIZADO )  ds_cirurgia
      , DECODE(nvl(CIR_AVI.DS_NPADRONIZADO,'XXX'), 'XXX'
                                     , CIRURGIA.DS_CIRURGIA
                                     , 'N.P.' || CIR_AVI.DS_NPADRONIZADO )  ds_cirurgia
      ,convenio.nm_convenio             nm_convenio
      ,cirurgia.tp_cirurgia                     tp_cirurgia
      ,Decode(loc_proced.ds_loc_proced,NULL,'NAO INFORMADO',loc_proced.ds_loc_proced)ds_loc_proced
      from   dbamv.cen_cir             cen_cir
            ,dbamv.sal_cir             sal_cir
            ,dbamv.aviso_cirurgia      avi_cir
            ,dbamv.cirurgia            cirurgia
            ,dbamv.cirurgia_aviso      cir_avi
            ,dbamv.atendime            atendime
            ,dbamv.leito               leito
            ,dbamv.convenio            convenio
      --     ,dbamv.prestador_aviso             prestador_aviso  -- PDA 170132 -- PDA 169006
            ,Dbamv.Empresa_Convenio
            ,DBAMV.TIP_ANEST
            ,DBAMV.TIP_ANEST_AVISO_CIRURGIA
            ,dbamv.loc_proced
      Where Empresa_Convenio.Cd_Convenio = Convenio.Cd_Convenio
      And   avi_cir.cd_aviso_cirurgia    = cir_avi.cd_aviso_cirurgia
      and   cir_avi.cd_cirurgia                = cirurgia.cd_cirurgia
      and   cir_avi.cd_convenio            = convenio.cd_convenio
      and   avi_cir.cd_sal_cir                 = sal_cir.cd_sal_cir
      and   avi_cir.cd_cen_cir                = cen_cir.cd_cen_cir
      and   avi_cir.tp_situacao              = 'R'
      and   avi_cir.cd_atendimento       =  atendime.cd_atendimento
      and   atendime.cd_leito                =  leito.cd_leito(+)
      AND   TIP_ANEST_AVISO_CIRURGIA.CD_TIP_ANEST	    = TIP_ANEST.CD_TIP_ANEST(+)
      AND   TIP_ANEST_AVISO_CIRURGIA.CD_AVISO_CIRURGIA(+) = avi_cir.CD_AVISO_CIRURGIA
      AND   atendime.cd_loc_proced =  loc_proced.cd_loc_proced(+)
      --and   avi_cir.dt_realizacao  BETWEEN To_Date(Concat(To_Char('01/03/2022','dd/mm/yyyy'),'00:00'),'dd/mm/yyyy hh24:mi') and  To_Date(Concat(To_Char('13/03/2022','dd/mm/yyyy'),'23:59'),'dd/mm/yyyy hh24:mi')
--      AND TRUNC(avi_cir.DT_REALIZACAO) BETWEEN '01/03/2022' AND  '01/03/2022'
      AND TRUNC(avi_cir.DT_REALIZACAO) BETWEEN @P_DT_INICIO AND @P_DT_FIM
--      AND  loc_proced.cd_loc_proced IN ({V_LOC_PROC_AUX})
      AND Decode({V_LOC_PROC_AUX}, 0,
-- PDA 607567 and cirurgia.tp_classif_psih = 'C'   -- pda 291765
--and   prestador_aviso.cd_cirurgia_aviso = cir_avi.cd_cirurgia_aviso -- PDA 170132 -- PDA 169006
--and   prestador_aviso.SN_PRINCIPAL = 'S' -- PDA 170132 -- PDA 169006

Order by hr_inicio

)
ORDER BY CD_CEN_CIR,DS_CEN_CIR,
DT_REALIZACAO,
CD_ATENDIMENTO,CD_PACIENTE,NM_PACIENTE,NR_TELEFONE_CONTATO,HR_INICIO,CD_AVISO_CIRURGIA,HR_FIM,TP_CIRURGIA




SELECT cd_loc_proced
      ,ds_loc_proced
  FROM dbamv.loc_proced
ORDER BY 2
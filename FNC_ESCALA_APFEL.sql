# .sql file


CREATE OR REPLACE FUNCTION FNC_ESCALA_APFEL(pATEND INTEGER)
RETURN VARCHAR2 IS

 ESCALA_APFEL VARCHAR2(300);

BEGIN
    WITH text AS (SELECT  ROW_NUMBER() OVER(ORDER BY dh_avaliacao desc) AS Linha,
                                  'Data da avalia��o: '||to_char(pagu_avaliacao.dh_avaliacao,
                                    'DD/MM/YY HH24:mi:ss')
                                  ||' - Resultado: '||pagu_avaliacao.vl_resultado||' - '
                                  ||PAGU_FORMULA_INTERPRETACAO.ds_interpretacao
                                  AS DESCRICAO
                            FROM pagu_avaliacao
                              , pagu_formula
                              , atendime
                              , PAGU_FORMULA_INTERPRETACAO

                            WHERE pagu_formula.cd_formula = pagu_avaliacao.cd_formula
                            AND pagu_avaliacao.cd_formula = 94
                            AND pagu_avaliacao.cd_formula = pagu_formula_interpretacao.cd_formula(+)
                            AND pagu_avaliacao.cd_atendimento(+) =  atendime.cd_atendimento
                            AND atendime.cd_atendimento = pATEND
                            AND pagu_avaliacao.vl_resultado BETWEEN vl_inicial AND vl_final
                   ORDER BY dh_avaliacao DESC
                                                       )
                   SELECT descricao
                      INTO ESCALA_APFEL
                      FROM text
                      WHERE linha = 1;



  RETURN ESCALA_APFEL;
END;

----ESCALA DE BRADEN DS E ULTIMO RESULTADO (trocar o c�digo de acordo com o cadastro na tabela)

--WITH text AS (

--   SELECT  ROW_NUMBER() OVER(ORDER BY dh_avaliacao desc) AS Linha,
--                'Data da avalia��o: '||to_char(pagu_avaliacao.dh_avaliacao,
--                  'DD/MM/YY HH24:mi:ss')
--                ||' - Resultado: '||pagu_avaliacao.vl_resultado||' - '
--                ||PAGU_FORMULA_INTERPRETACAO.ds_interpretacao
--                AS DESCRICAO
--          FROM pagu_avaliacao
--             , pagu_formula
--             , atendime
--             , PAGU_FORMULA_INTERPRETACAO

--          WHERE pagu_formula.cd_formula = pagu_avaliacao.cd_formula
--          AND pagu_avaliacao.cd_formula = 94
--          AND pagu_avaliacao.cd_formula = pagu_formula_interpretacao.cd_formula(+)
--          AND pagu_avaliacao.cd_atendimento(+) =  atendime.cd_atendimento
--          AND atendime.cd_atendimento = 13956
--          AND pagu_avaliacao.vl_resultado BETWEEN vl_inicial AND vl_final
--ORDER BY dh_avaliacao DESC
--                                    )
--SELECT  descricao FROM text WHERE linha = 1



--SELECT vl_resultado
--    FROM (
--        SELECT dh_avaliacao, vl_resultado
--            FROM pagu_avaliacao
--            WHERE cd_atendimento = 6641
--            order BY vl_resultado desc   )
--    WHERE ROWNUM = 1




--  SELECT dh_avaliacao, vl_resultado
--            FROM pagu_avaliacao
--            WHERE cd_atendimento = 20002



--     SELECT * FROM PAGU_FORMULA_INTERPRETACAO where cd_formula = 19










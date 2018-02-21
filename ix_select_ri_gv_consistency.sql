/* Formatted on 2011/06/21 09:54 (Formatter Plus v4.8.7) */
SELECT DISTINCT rim.ricode ri, rim.vscode riv, ri.des ri_des, tmm.upcode UP,
                UP.des up_des, gvm.gvcode gv, rim.gvvscode gvv_ri,
                gvm.vscode gvv_max, gv.des gv_des, gvm.zncode zn,
                zn.des zn_des, gvm.DIGITS,
                DECODE (tmm.tmcode, 12, 12, 22, 22, 56, 56, 0) roam
           FROM MPULKRIM rim,
                MPUUPTAB UP,
                MPUGVTAB gv,
                MPULKGVM gvm,
                MPUZNTAB zn,
                MPULKTMM tmm,
                MPURITAB ri
          WHERE ri.ricode = rim.ricode
            AND gv.gvcode = rim.gvcode
            AND gvm.gvcode = rim.gvcode
            AND zn.zncode = gvm.zncode
            AND tmm.ricode = rim.ricode
            AND UP.upcode = tmm.upcode
            AND rim.vscode = (SELECT MAX (vscode)
                                FROM MPURIVSD
                               WHERE ricode = rim.ricode)
            AND gvm.vscode = (SELECT MAX (vscode)
                                FROM MPUGVVSD
                               WHERE gvcode = gvm.gvcode)
            AND tmm.vscode = (SELECT MAX (vscode)
                                FROM RATEPLAN_VERSION
                               WHERE tmcode = tmm.tmcode)
            AND tmm.tmcode NOT IN (SELECT tmcode
                                     FROM RATEPLAN_AVAILABILITY_PERIOD
                                    WHERE tmcode <> 71)
            AND NOT EXISTS (
                   SELECT *
                     FROM MPUGVVSD gvv
                    WHERE gvv.gvcode = rim.gvcode
                      AND gvv.vscode = rim.gvvscode
                      AND gvv.vscode = (SELECT MAX (vscode)
                                          FROM MPUGVVSD
                                         WHERE gvcode = gvv.gvcode))
            AND (   NOT EXISTS (
                       SELECT *
                         FROM MPULKGVM
                        WHERE gvcode = rim.gvcode
                          AND vscode = rim.gvvscode
                          AND zncode = gvm.zncode
                          AND zocode = gvm.zocode
                                                 --AND zpcode = gvm.zpcode
                    )
                 OR NOT EXISTS (
                       SELECT *
                         FROM MPULKRIM
                        WHERE ricode = rim.ricode
                          AND vscode = rim.vscode
                          AND gvcode = rim.gvcode
                          AND gvvscode = rim.gvvscode
                          AND zncode = gvm.zncode)
                )
       ORDER BY ri.des

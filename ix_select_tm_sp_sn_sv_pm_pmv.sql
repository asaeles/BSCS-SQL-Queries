/* Formatted on 2011/11/17 11:28 (Formatter Plus v4.8.7) */
SELECT   tmb.tmcode tm, tmb.vscode, tm.des rate_plan, tmb.spcode sp,
         sp.des service_package, tmb.sncode sn, sn.des service, nxv.svlcode,
         sv.svcode sv, sv.des srv_desc, sv.srvcode srv, pm.sccode sc,
         svpm.parameter_id pm, svpm.prm_no NO, pm.prm_des parameter,
         pmd.prm_value_seqno pmsq, pmd.prm_value_des pm_description,
         DECODE (pmd.prm_value_string,
                 NULL, TO_CHAR (pmd.prm_value_number),
                 pmd.prm_value_string
                ) pm_value,
         pmd.prm_value_def dflt
    FROM MPULKTMB tmb,
         RATEPLAN tm,
         MPUSPTAB sp,
         MPUSNTAB sn,
         (SELECT sncode, svlcode, s1code scode
            FROM MPULKNXV
           WHERE s1code <> 0
          UNION
          SELECT sncode, svlcode, s2code scode
            FROM MPULKNXV
           WHERE s2code <> 0
          UNION
          SELECT sncode, svlcode, sscode scode
            FROM MPULKNXV
           WHERE sscode <> 0) nxv,
         MPSSVTAB sv,
         SERVICE_PARAMETER svpm,
         MKT_PARAMETER pm,
         MKT_PARAMETER_DOMAIN pmd
   WHERE tm.tmcode = tmb.tmcode
     AND sp.spcode = tmb.spcode
     AND sn.sncode = tmb.sncode
     AND nxv.sncode(+) = sn.sncode
     AND sv.svcode(+) = nxv.scode
     /*DECODE (nxv.s1code,
             0, DECODE (nxv.s2code, 0, nxv.sscode, nxv.s2code),
             nxv.s1code
            )*/
     AND svpm.svcode(+) = sv.svcode
     AND svpm.sccode(+) = sv.sccode
     AND pm.sccode(+) = svpm.sccode
     AND pm.parameter_id(+) = svpm.parameter_id
     AND pmd.sccode(+) = pm.sccode
     AND pmd.parameter_id(+) = pm.parameter_id
     AND tmb.vscode = (SELECT MAX (vscode)
                         FROM RATEPLAN_VERSION
                        WHERE tmcode = tmb.tmcode)
     AND tmb.tmcode = 20
     AND tmb.spcode = 23
ORDER BY tm.des,
         sp.des,
         sn.sncode,
         sv.svcode,
         svpm.parameter_id,
         svpm.prm_no,
         pmd.prm_value_seqno;

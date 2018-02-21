/* Formatted on 11/01/2015 3:01:24 PM (QP5 v5.185.11230.41888) */
  SELECT DISTINCT tm.tmcode tm, tmb.vscode vs, tmb.vsdate vsd, tm.des rate_plan,
                  sp.spcode sp, sp.des sevice_package, en.translation eng,
                  ar.translation ara, sn.sncode sn, sn.des service,
                  tmb.subscript, tmb.accessfee,
                  DECODE (tmb.proind, 'Y', 'Yes', 'No') prorated,
                  DECODE (tmb.advind, 'P', 'Past', 'In Advance') payment
    FROM (SELECT tmcode, vscode, vsdate, spcode, sncode, subscript, accessfee,
                 echind, amtind, frqind, srvind, proind, advind, susind, csind,
                 clcode, interval_type, prm_print_ind, printsubscrind,
                 printaccessind, access_restricted_ind
            FROM mpulktmb
          UNION
          SELECT tmcode, vscode, vsdate, spcode, sncode, subscript, accessfee,
                 echind, amtind, frqind, srvind, proind, advind, susind, csind,
                 clcode, interval_type, prm_print_ind, printsubscrind,
                 printaccessind, access_restricted_ind
            FROM mpulktm1) tmb,
         rateplan tm,
         mpusptab sp,
         mpusntab sn,
         nls_dict en,
         nls_dict ar
   WHERE     tm.tmcode = tmb.tmcode
         AND sp.spcode = tmb.spcode
         AND sn.sncode = tmb.sncode
         AND en.key_value(+) = sp.spcode
         AND ar.key_value(+) = sp.spcode
         AND en.base_tab(+) = 'MPUSPTAB'
         AND ar.base_tab(+) = 'MPUSPTAB'
         AND en.lng_id(+) = 1
         AND ar.lng_id(+) = 2
         --AND tm.des NOT LIKE 'Internal Use%'
         AND tmb.tmcode NOT IN (14, 21, 183)
         --Special Number, Global Dummy Rateplan, Receiver Dial
         AND tmb.tmcode NOT IN (22, 55, 56, 74)
         --Roaming, CUG Rate Plan, IOT-MIG: Global Roaming, Rated CDRs
         AND tmb.vscode = (SELECT MAX (vscode)
                             FROM rateplan_version
                            WHERE tmcode = tmb.tmcode)
         AND tmb.tmcode NOT IN
                (SELECT tmcode
                   FROM rateplan_availability_period
                  WHERE available_to < TRUNC (SYSDATE) AND tmcode <> 77)
         AND (tmb.vscode <> 0 OR tmb.vsdate > ADD_MONTHS (SYSDATE, -1))
         AND tmb.tmcode NOT IN (SELECT DISTINCT scenario_tmcode
                                  FROM business_scenario_item
                                 WHERE scenario_tmcode IS NOT NULL)
         AND tmb.sncode IN (1, 26, 27)
         AND tmb.spcode NOT IN (11, 20, 58, 82)
ORDER BY tm.des, sp.des;
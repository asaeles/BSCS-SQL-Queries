  SELECT DISTINCT tm.tmcode tm,             /*tmb.vscode vs, tmb.vsdate vsd,*/
                               tm.des rate_plan, sp.spcode sp,
                  sp.des sevice_package, en.translation eng, ar.translation ara,
                  sn.sncode sn, sn.shdes, sn.des service, b.cfginfo2 sn_eng, b.cfginfo3 sn_ara,
                  tmb.interval_type dm, nvl(tmb.subscript, 0) sub1, nvl(tmb.accessfee, 0) acc1,
                  pvb.des, nvl(pvb.subscript, 0) sub2, nvl(pvb.accessfee, 0) acc2,
                  DECODE (tmb.proind, 'Y', 'Yes', 'No') prorated,
                  DECODE (tmb.advind, 'P', 'Past', 'In Advance') payment
    FROM (SELECT tmcode, vscode, vsdate, spcode, sncode, subscript, accessfee,
                 echind, amtind, frqind, srvind, proind, advind, susind, csind,
                 clcode, interval_type, prm_print_ind, printsubscrind,
                 printaccessind, access_restricted_ind, pv_combi_id
            FROM mpulktmb
          UNION
          SELECT tmcode, vscode, vsdate, spcode, sncode, subscript, accessfee,
                 echind, amtind, frqind, srvind, proind, advind, susind, csind,
                 clcode, interval_type, prm_print_ind, printsubscrind,
                 printaccessind, access_restricted_ind, pv_combi_id
            FROM mpulktm1) tmb,
         mpulkpvb pvb,
         rateplan tm,
         mpusptab sp,
         mpusntab sn,
         nls_dict en,
         nls_dict ar,
         bghconfig b
   WHERE     pvb.pv_combi_id(+) = tmb.pv_combi_id
         AND tm.tmcode = tmb.tmcode
         AND sp.spcode = tmb.spcode
         AND sn.sncode = tmb.sncode
         AND en.key_value(+) = sp.spcode
         AND ar.key_value(+) = sp.spcode
         AND b.cfginfo1(+) = sn.shdes
         AND en.base_tab(+) = 'MPUSPTAB'
         AND ar.base_tab(+) = 'MPUSPTAB'
         AND b.cfgcode(+) = 'SERVICES'
         AND en.lng_id(+) = 1
         AND ar.lng_id(+) = 2
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
         --AND (LOWER(tm.des) LIKE ('%max%') OR LOWER(sp.des) LIKE ('%max%'))
         --AND tmb.sncode in (1, 27)
         --AND tmb.spcode not in (11, 20)
--         AND sn.des LIKE '%lack%'
         --AND tmb.tmcode = 57
         --AND LOWER(sp.des) LIKE '%internal%'
--         AND tmb.vscode != 0
         --AND tmb.sncode in (443, 145)
--         AND access_restricted_ind = 'Y'
--         AND clcode IS NULL
--         AND (en.translation <> sp.des OR ar.translation <> sp.des)
ORDER BY tm.des, sp.des, b.cfginfo2;

--, sp.des, sn.sncode;
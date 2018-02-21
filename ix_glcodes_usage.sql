SELECT gla.glacode glcode, gla.gladesc description, tmb.tmcode tm, tm.des rate_plan, tmb.spcode sp,
       sp.des service_pack, tmb.sncode sn, sn.des service, tmb.usgglcode usage
  FROM glaccount_all gla, mpulktmb tmb, rateplan tm, mpusptab sp, mpusntab sn
 WHERE     (   tmb.accglcode = gla.glacode
            OR tmb.subglcode = gla.glacode
            OR tmb.usgglcode = gla.glacode
            OR tmb.subglcode_mincom = gla.glacode
            OR tmb.accglcode_mincom = gla.glacode
            OR tmb.usgglcode_mincom = gla.glacode)
       AND tm.tmcode = tmb.tmcode
       AND sp.spcode = tmb.spcode
       AND sn.sncode = tmb.sncode
       AND gla.gladesc IN ('Corporate_SMS_Premium Short Codes', 'Personal_SMS_Premium Short Codes')
       AND tmb.vscode = (SELECT MAX (vscode)
                           FROM rateplan_version
                          WHERE tmcode = tmb.tmcode);

  SELECT DISTINCT gla.glacode glcode, gla.gladesc description, egm.egcode eg, eg.des extended_gl,
                  egm.zncode zn, zn.des zone, tmm.tmcode tm, tm.des rate_plan, tmm.spcode sp,
                  sp.des service_pack, tmm.sncode sn, sn.des service, rim.*
    FROM glaccount_all gla, mpulkegm egm, mpuegtab eg, mpuzntab zn, mpulktmm tmm, rateplan tm,
         mpusptab sp, mpusntab sn, mpulkrim rim,
         (SELECT TO_DATE ('1/10/2013', 'dd/mm/rrrr') md FROM DUAL) d
   WHERE     (egm.usgglcode = gla.glacode OR egm.usgglcode_mincom = gla.glacode)
         AND eg.egcode = egm.egcode
         AND zn.zncode = egm.zncode
         AND tmm.egcode = egm.egcode
         AND tm.tmcode = tmm.tmcode
         AND sp.spcode = tmm.spcode
         AND sn.sncode = tmm.sncode
         AND rim.ricode = tmm.ricode
         AND rim.zncode = egm.zncode
         AND egm.vscode = (SELECT MAX (vscode)
                             FROM mpuegvsd
                            WHERE egcode = egm.egcode AND vsdate < d.md)
         AND tmm.vscode = (SELECT MAX (vscode)
                             FROM rateplan_version
                            WHERE tmcode = tmm.tmcode AND vsdate < d.md)
         AND rim.vscode = (SELECT MAX (vscode)
                             FROM mpurivsd
                            WHERE ricode = rim.ricode AND vsdate < d.md)
         AND gla.gladesc IN ('Corporate_SMS_Premium Short Codes')
ORDER BY gla.glacode, egm.egcode, zn.des, tmm.tmcode;


  SELECT DISTINCT tmb1.tmcode tm1,
                  tm1.des old_tm,
                  tmb1.spcode sp1,
                  sp1.des old_sp,
                  tmb2.tmcode tm2,
                  tm2.des new_tm,
                  tmb2.spcode sp2,
                  sp2.des new_sp
    FROM mpulktmb tmb1,
         mpulktmb tmb2,
         rateplan tm1,
         mpusptab sp1,
         rateplan tm2,
         mpusptab sp2
   WHERE     sp1.spcode = tmb1.spcode
         AND sp2.spcode = tmb2.spcode
         AND tm1.tmcode = tmb1.tmcode
         AND tm2.tmcode = tmb2.tmcode
         --AND tmb1.tmcode IN (29, 57)
         AND tmb1.sncode = 1
         --AND tmb1.spcode in (237, 201)
         AND tmb1.vscode = (SELECT MAX (vscode)
                              FROM rateplan_version
                             WHERE tmcode = tmb1.tmcode)
         --AND tmb2.tmcode IN (29, 57)
         AND tmb2.sncode = 1
         AND tmb2.vscode = (SELECT MAX (vscode)
                              FROM rateplan_version
                             WHERE tmcode = tmb2.tmcode)
         AND (tmb1.tmcode || tmb1.spcode) <> (tmb2.tmcode || tmb2.spcode)
         AND EXISTS
                (SELECT *
                   FROM pec_migration
                  WHERE     old_tm = tmb1.tmcode
                        AND old_sp = tmb1.spcode
                        AND new_tm = tmb2.tmcode
                        AND new_sp = tmb2.spcode)
ORDER BY tmb1.tmcode, tmb1.spcode, tmb2.tmcode, tmb2.spcode;

  SELECT DISTINCT tm1.tmcode tm1,
                  tm1.des old_tm,
                  sp1.spcode sp1,
                  sp1.des old_sp,
                  tm2.tmcode tm2,
                  tm2.des new_tm,
                  sp2.spcode sp2,
                  sp2.des new_sp
    FROM alcatel.pec_migration pm,
         rateplan tm1,
         mpusptab sp1,
         rateplan tm2,
         mpusptab sp2
   WHERE     tm1.tmcode = pm.old_tm
         AND sp1.spcode = pm.old_sp
         AND tm2.tmcode = pm.new_tm
         AND sp2.spcode = pm.new_sp
ORDER BY tm1.tmcode, sp1.spcode, tm2.tmcode, sp2.spcode;
  SELECT DISTINCT
         zp.digits,
         tmm.sncode sn,
         DECODE (
            tmm.sncode,
            1, DECODE (sr.zpcode, NULL, rppv.parameter_value_float / 1000, 0),
            rppv.parameter_value_float / 1000)
            "1st Min of Call in Peak (EGP)"
    FROM (--Select all dialed numbers for translation
          SELECT '+' || SUBSTR (pt.ddigits, 3) digits, zp.zpcode
            FROM mpdpttab pt, mpuzptab zp
           WHERE zp.digits = '+' || SUBSTR (pt.trdigits, 3)
          UNION
          --Iclude any special number that might not have been
          --included in the translation table above and can be called
          --So I will exclude numbers with letters
          SELECT zp.digits digits, zp.zpcode
            FROM special_number sr, mpuzptab zp
           WHERE     zp.zpcode = sr.zpcode
                 AND NOT REGEXP_LIKE (zp.digits, '[a-zA-Z]')) zp,
         special_number sr,
         mpulktmm tmm,
         mpulkrim rim,
         mpulkgvm gvm,
         mputttab tt,
         rate_pack_element rpe,
         rate_pack_parameter_value rppv
   WHERE     sr.zpcode(+) = zp.zpcode
         AND rim.ricode = tmm.ricode
         AND gvm.gvcode = rim.gvcode
         AND gvm.vscode = rim.gvvscode
         AND gvm.zncode = rim.zncode
         AND tt.ttcode = rim.ttcode
         AND rpe.rate_pack_entry_id = rim.rate_pack_entry_id
         AND rppv.rate_pack_element_id = rpe.rate_pack_element_id
         AND gvm.zpcode = zp.zpcode
         AND tmm.tmcode = 75
         AND tmm.sncode IN (1, 54)
         AND tmm.usage_type_id = 2
         AND LOWER (SUBSTR (tt.des, 1, 3)) = 'pea'
         AND rppv.parameter_rownum = 1
         AND rppv.parameter_seqnum = 4
         AND tmm.vscode = (SELECT MAX (vscode)
                             FROM rateplan_version
                            WHERE tmcode = tmm.tmcode)
         AND rim.vscode = (SELECT MAX (vscode)
                             FROM mpurivsd
                            WHERE ricode = rim.ricode)
ORDER BY tmm.sncode, TO_NUMBER (zp.digits)
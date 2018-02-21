/* Formatted on 2010/09/29 14:50 (Formatter Plus v4.8.7) */
/* Simple */
SELECT z.*,
       DECODE (spn.special_number_id,
               NULL, 'Not Special',
               'Special: ' || spn.special_number_des
              ) special
  FROM (SELECT *
          FROM (SELECT   zp.zpcode, zp.des, zp.DIGITS,
                         DECODE (pt.trdigits, NULL, 'No', 'Yes') translated
                    FROM MPDPTTAB pt,
                         MPUZPTAB zp,
                         (SELECT '+20' || TO_CHAR (117) num
                            FROM DUAL) dummy
                   WHERE '+' || SUBSTR (pt.ddigits(+), 3) = dummy.num
                     AND DECODE (pt.trdigits,
                                 NULL, dummy.num,
                                 '+' || SUBSTR (pt.trdigits, 3)
                                ) LIKE zp.DIGITS || '%'
                ORDER BY LENGTH (zp.DIGITS) DESC)
         WHERE ROWNUM < 2) z,
       SPECIAL_NUMBER spn
 WHERE spn.zpcode(+) = z.zpcode AND spn.special_number_vsdate(+) <=
                                                               TRUNC (SYSDATE)
       AND spn.special_number_status(+) = 'X';

SELECT   /*+ ORDERED */
         tmm.tmcode tm, tm.des rate_plan, tmm.spcode sp,
         sp.des service_package, tmm.sncode sn, sn.des service, gvm.zncode zn,
         zn.des tariff_zone, rim.ttcode tt, tt.des tariff_time,
         rim.rate_type_id rt, rt.rate_type_des rate_type,
         rppv.parameter_rownum rn, rppv.parameter_value_float / 1000 egp
    FROM MPULKGVM gvm,
         MPULKTMM tmm,
         mputmtab tm,
         MPUSPTAB sp,
         MPUSNTAB sn,
         MPULKRIM rim,
         MPUZNTAB zn,
         MPUTTTAB tt,
         UDC_RATE_TYPE_TABLE rt,
         RATE_PACK_ELEMENT rpe,
         RATE_PACK_PARAMETER_VALUE rppv
   WHERE gvm.zpcode = 9257
     AND tm.tmcode = tmm.tmcode
     AND tm.vscode = tmm.vscode
     AND sp.spcode = tmm.spcode
     AND sn.sncode = tmm.sncode
     AND rim.ricode = tmm.ricode
     AND rim.gvcode = gvm.gvcode
     AND rim.gvvscode = gvm.vscode
     AND rim.zncode = gvm.zncode
     AND zn.zncode = gvm.zncode
     AND tt.ttcode = rim.ttcode
     AND rt.rate_type_id = rim.rate_type_id
     AND rpe.rate_pack_entry_id = rim.rate_pack_entry_id
     AND rppv.rate_pack_element_id = rpe.rate_pack_element_id
     --AND tmm.sncode = 1
     AND rim.vscode = (SELECT MAX (vscode)
                         FROM MPURIVSD
                        WHERE ricode = rim.ricode)
     AND tmm.vscode = (SELECT MAX (vscode)
                         FROM mputmtab
                        WHERE tmcode = tmm.tmcode)
     AND rppv.parameter_seqnum = 4
     AND (rim.rate_type_id = 1 OR rppv.parameter_value_float <> 0)
ORDER BY tmm.tmcode,
         tmm.sncode,
         tmm.spcode,
         rim.ttcode,
         rim.rate_type_id,
         rppv.parameter_rownum;

SELECT   /*+ ORDERED */
         tmm.tmcode tm, tm.des rate_plan, tmm.spcode sp,
         sp.des service_package, tmm.sncode sn, sn.des service, gvm.zncode zn,
         zn.des tariff_zone, rim.ttcode tt, tt.des tariff_time,
         rim.rate_type_id rt, rt.rate_type_des rate_type,
         rppv.parameter_rownum rn, rppv.parameter_value_float / 1000 egp   /*,
 rim.rate_pack_entry_id, m.*,
 DECODE (spn.special_number_id, NULL, 'N', 'Y') spec*/
    FROM (SELECT *
            FROM (SELECT   zp.zpcode, zp.des, zp.DIGITS
                      FROM MPDPTTAB pt,
                           MPUZPTAB zp,
                           (SELECT '+20' || TO_CHAR (0) num
                              FROM DUAL) dummy
                     WHERE '+' || SUBSTR (pt.ddigits(+), 3) = dummy.num
                       AND DECODE (pt.trdigits,
                                   NULL, dummy.num,
                                   '+' || SUBSTR (pt.trdigits, 3)
                                  ) LIKE zp.DIGITS || '%'
                  ORDER BY LENGTH (zp.DIGITS) DESC)
           WHERE ROWNUM < 2) m,
         SPECIAL_NUMBER spn,
         MPULKGVM gvm,
         MPULKTMM tmm,
         mputmtab tm,
         MPUSPTAB sp,
         MPUSNTAB sn,
         MPULKRIM rim,
         MPUZNTAB zn,
         MPUTTTAB tt,
         UDC_RATE_TYPE_TABLE rt,
         RATE_PACK_ELEMENT rpe,
         RATE_PACK_PARAMETER_VALUE rppv
   WHERE spn.zpcode(+) = m.zpcode
     AND gvm.zpcode = m.zpcode
     AND tm.tmcode = tmm.tmcode
     AND tm.vscode = tmm.vscode
     AND sp.spcode = tmm.spcode
     AND sn.sncode = tmm.sncode
     AND rim.ricode = tmm.ricode
     AND rim.gvcode = gvm.gvcode
     AND rim.gvvscode = gvm.vscode
     AND rim.zncode = gvm.zncode
     AND zn.zncode = gvm.zncode
     AND tt.ttcode = rim.ttcode
     AND rt.rate_type_id = rim.rate_type_id
     AND rpe.rate_pack_entry_id = rim.rate_pack_entry_id
     AND rppv.rate_pack_element_id = rpe.rate_pack_element_id
     AND spn.special_number_vsdate(+) <= TRUNC (SYSDATE)
     AND spn.special_number_status(+) = 'X'
     AND tmm.tmcode = 84
     AND rim.vscode = (SELECT MAX (vscode)
                         FROM MPURIVSD
                        WHERE ricode = rim.ricode)
     AND tmm.vscode = (SELECT MAX (vscode)
                         FROM mputmtab
                        WHERE tmcode = tmm.tmcode)
     AND rppv.parameter_seqnum = 4
     AND (rim.rate_type_id = 1 OR rppv.parameter_value_float <> 0)
ORDER BY tmm.tmcode,
         tmm.sncode,
         tmm.spcode,
         rim.ttcode,
         rim.rate_type_id,
         rppv.parameter_rownum;

DECLARE
   v_num          VARCHAR2 (30) := '1195';
   v_tmcode       INTEGER       := 84;
   v_zpcode       INTEGER;
   v_is_special   NUMBER;

   CURSOR c_all
   IS
      SELECT   /*+ ORDERED */
               tmm.tmcode tm, tm.des rate_plan, tmm.spcode sp,
               sp.des service_package, tmm.sncode sn, sn.des service,
               gvm.zncode zn, zn.des tariff_zone, rim.ttcode tt,
               tt.des tariff_time, rim.rate_type_id rt,
               rt.rate_type_des rate_type, rppv.parameter_rownum rn,
               rppv.parameter_value_float / 1000 egp
          FROM MPULKGVM gvm,
               MPULKTMM tmm,
               mputmtab tm,
               MPUSPTAB sp,
               MPUSNTAB sn,
               MPULKRIM rim,
               MPUZNTAB zn,
               MPUTTTAB tt,
               UDC_RATE_TYPE_TABLE rt,
               RATE_PACK_ELEMENT rpe,
               RATE_PACK_PARAMETER_VALUE rppv
         WHERE gvm.zpcode = v_zpcode
           AND tmm.tmcode = v_tmcode
           AND tm.tmcode = tmm.tmcode
           AND tm.vscode = tmm.vscode
           AND sp.spcode = tmm.spcode
           AND sn.sncode = tmm.sncode
           AND rim.ricode = tmm.ricode
           AND rim.gvcode = gvm.gvcode
           AND rim.gvvscode = gvm.vscode
           AND rim.zncode = gvm.zncode
           AND zn.zncode = gvm.zncode
           AND tt.ttcode = rim.ttcode
           AND rt.rate_type_id = rim.rate_type_id
           AND rpe.rate_pack_entry_id = rim.rate_pack_entry_id
           AND rppv.rate_pack_element_id = rpe.rate_pack_element_id
           AND rim.vscode = (SELECT MAX (vscode)
                               FROM MPURIVSD
                              WHERE ricode = rim.ricode)
           AND tmm.vscode = (SELECT MAX (vscode)
                               FROM mputmtab
                              WHERE tmcode = tmm.tmcode)
           AND rppv.parameter_seqnum = 4
           AND (rim.rate_type_id = 1 OR rppv.parameter_value_float <> 0)
      ORDER BY tmm.tmcode,
               tmm.sncode,
               tmm.spcode,
               rim.ttcode,
               rim.rate_type_id,
               rppv.parameter_rownum;
BEGIN
   SELECT zpcode
     INTO v_zpcode
     FROM (SELECT   zp.zpcode, zp.des, zp.DIGITS
               FROM MPDPTTAB pt,
                    MPUZPTAB zp,
                    (SELECT '+20' || v_num num
                       FROM DUAL) dummy
              WHERE '+' || SUBSTR (pt.ddigits(+), 3) = dummy.num
                AND DECODE (pt.trdigits,
                            NULL, dummy.num,
                            '+' || SUBSTR (pt.trdigits, 3)
                           ) LIKE zp.DIGITS || '%'
           ORDER BY LENGTH (zp.DIGITS) DESC)
    WHERE ROWNUM < 2;

   SELECT COUNT (*)
     INTO v_is_special
     FROM SPECIAL_NUMBER spn
    WHERE spn.zpcode = v_zpcode
      AND spn.special_number_vsdate <= TRUNC (SYSDATE)
      AND spn.special_number_status = 'X';

   DBMS_OUTPUT.PUT_LINE
      ('TM;RATE_PLAN;SP;SERVICE_PACKAGE;SN;SERVICE;ZN;TARIFF_ZONE;TT;TARIFF_TIME;RT;RATE_TYPE;RN;EGP'
      );

   IF v_is_special = 0
   THEN
      FOR r_all IN c_all
      LOOP
         DBMS_OUTPUT.PUT_LINE (   r_all.tm
                               || ';'
                               || r_all.rate_plan
                               || ';'
                               || r_all.sp
                               || ';'
                               || r_all.service_package
                               || ';'
                               || r_all.sn
                               || ';'
                               || r_all.service
                               || ';'
                               || r_all.zn
                               || ';'
                               || r_all.tariff_zone
                               || ';'
                               || r_all.tt
                               || ';'
                               || r_all.tariff_time
                               || ';'
                               || r_all.rt
                               || ';'
                               || r_all.rate_type
                               || ';'
                               || r_all.rn
                               || ';'
                               || r_all.egp
                              );
      END LOOP;
   ELSE
      DBMS_OUTPUT.PUT_LINE ('*;*;*;*;*;*;*;*;*;*;*;*;*;0');
   END IF;

   NULL;
END;

----------------------------------------------------------------------------------------------------------------------------------------------------------------------

DECLARE
   v_num          VARCHAR2 (30)   := '1195';
   v_tmcode       INTEGER         := 84;
   v_zpcode       INTEGER;
   v_is_special   NUMBER;
   v_line         VARCHAR2 (3000);

   CURSOR c_rpe_id
   IS
      SELECT   /*+ ORDERED */
               tmm.tmcode tm, tm.des rate_plan, tmm.spcode sp,
               sp.des service_package, tmm.sncode sn, sn.des service,
               gvm.zncode zn, zn.des tariff_zone, rim.ttcode tt,
               tt.des tariff_time, rim.rate_type_id rt,
               rt.rate_type_des rate_type, rim.rate_pack_entry_id
          FROM MPULKGVM gvm,
               MPULKTMM tmm,
               mputmtab tm,
               MPUSPTAB sp,
               MPUSNTAB sn,
               MPULKRIM rim,
               MPUZNTAB zn,
               MPUTTTAB tt,
               UDC_RATE_TYPE_TABLE rt
         WHERE gvm.zpcode = v_zpcode
           AND tmm.tmcode = v_tmcode
           AND tm.tmcode = tmm.tmcode
           AND tm.vscode = tmm.vscode
           AND sp.spcode = tmm.spcode
           AND sn.sncode = tmm.sncode
           AND rim.ricode = tmm.ricode
           AND rim.gvcode = gvm.gvcode
           AND rim.gvvscode = gvm.vscode
           AND rim.zncode = gvm.zncode
           AND zn.zncode = gvm.zncode
           AND tt.ttcode = rim.ttcode
           AND rt.rate_type_id = rim.rate_type_id
           AND rim.vscode = (SELECT MAX (vscode)
                               FROM MPURIVSD
                              WHERE ricode = rim.ricode)
           AND tmm.vscode = (SELECT MAX (vscode)
                               FROM mputmtab
                              WHERE tmcode = tmm.tmcode)
      ORDER BY tmm.tmcode,
               tmm.sncode,
               tmm.spcode,
               rim.ttcode,
               rim.rate_type_id;
BEGIN
   SELECT zpcode
     INTO v_zpcode
     FROM (SELECT   zp.zpcode, zp.des, zp.DIGITS
               FROM MPDPTTAB pt,
                    MPUZPTAB zp,
                    (SELECT '+20' || v_num num
                       FROM DUAL) dummy
              WHERE '+' || SUBSTR (pt.ddigits(+), 3) = dummy.num
                AND DECODE (pt.trdigits,
                            NULL, dummy.num,
                            '+' || SUBSTR (pt.trdigits, 3)
                           ) LIKE zp.DIGITS || '%'
           ORDER BY LENGTH (zp.DIGITS) DESC)
    WHERE ROWNUM < 2;

   SELECT COUNT (*)
     INTO v_is_special
     FROM SPECIAL_NUMBER spn
    WHERE spn.zpcode = v_zpcode
      AND spn.special_number_vsdate <= TRUNC (SYSDATE)
      AND spn.special_number_status = 'X';

   DBMS_OUTPUT.PUT_LINE
      ('TM;RATE_PLAN;SP;SERVICE_PACKAGE;SN;SERVICE;ZN;TARIFF_ZONE;TT;TARIFF_TIME;RT;RATE_TYPE;RN;EGP'
      );

   IF v_is_special = 0
   THEN
      FOR r_rpe_id IN c_rpe_id
      LOOP
         v_line :=
               r_rpe_id.tm
            || ';'
            || r_rpe_id.rate_plan
            || ';'
            || r_rpe_id.sp
            || ';'
            || r_rpe_id.service_package
            || ';'
            || r_rpe_id.sn
            || ';'
            || r_rpe_id.service
            || ';'
            || r_rpe_id.zn
            || ';'
            || r_rpe_id.tariff_zone
            || ';'
            || r_rpe_id.tt
            || ';'
            || r_rpe_id.tariff_time
            || ';'
            || r_rpe_id.rt
            || ';'
            || r_rpe_id.rate_type
            || ';';

SELECT DISTINCT rppv.parameter_value_float INTO v_count FROM RATE_PACK_ELEMENT rpe,
                                RATE_PACK_PARAMETER_VALUE rppv
                          WHERE rpe.rate_pack_entry_id =
                                                   r_rpe_id.rate_pack_entry_id
                            AND rppv.rate_pack_element_id =
                                                      rpe.rate_pack_element_id
                            AND rppv.parameter_seqnum = 4
                            AND ((rppv.parameter_rownum = 2 AND rppv.parameter_value_float <> 0) OR rppv.parameter_rownum <> 2)
                       ORDER BY rppv.parameter_rownum;
IF v_count := 3
         FOR r_egp IN ()
         LOOP
            NULL;
         END LOOP;

         v_line :=
               v_line
      END LOOP;
   ELSE
      DBMS_OUTPUT.PUT_LINE ('*;*;*;*;*;*;*;*;*;*;*;*;*;0');
   END IF;

   NULL;
END;

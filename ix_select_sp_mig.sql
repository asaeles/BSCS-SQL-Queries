/* Formatted on 2011/01/02 14:46 (Formatter Plus v4.8.7) */
SELECT psp.co_id, dn.dn_num, tmh.tmcode, psp.spcode, psp2.spcode
  FROM PR_SERV_SPCODE_HIST psp2,
       PR_SERV_SPCODE_HIST psp,
       RATEPLAN_HIST tmh,
       CONTR_SERVICES_CAP csc,
       DIRECTORY_NUMBER dn
 WHERE psp2.co_id = psp.co_id
   AND psp2.sncode = psp.sncode
   AND tmh.co_id = psp.co_id
   AND csc.co_id = psp.co_id
   AND csc.cs_deactiv_date IS NULL
   AND dn.dn_id = csc.dn_id
   AND psp.sncode = 1
   AND psp.spcode IN (88, 137)
   AND psp2.spcode = 184
   AND TRUNC (psp2.valid_from_date) = '01-01-2011'
   AND psp.histno =
          (SELECT MAX (histno)
             FROM PR_SERV_SPCODE_HIST
            WHERE co_id = psp.co_id
              AND sncode = psp.sncode
              AND histno < psp2.histno)
   AND psp2.histno = (SELECT spcode_histno
                        FROM PROFILE_SERVICE
                       WHERE co_id = psp2.co_id AND sncode = psp2.sncode)
   AND tmh.seqno = (SELECT MAX (seqno) - 1
                      FROM RATEPLAN_HIST
                     WHERE co_id = tmh.co_id);

--   AND ROWNUM < 100;

SELECT *
  FROM PR_SERV_SPCODE_HIST
 WHERE co_id = 646600 AND sncode = 1;

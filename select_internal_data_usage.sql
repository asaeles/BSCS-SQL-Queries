/* Formatted on 1/31/2013 5:58:55 PM (QP5 v5.185.11230.41888) */
  SELECT distinct t.CUSTOMER_ID,
         t.CO_ID,
         dn.dn_num dial,
         TRUNC (DU / 1024 / 1024 / 1024, 2) gb,
         co.tmcode,
         cc.*
    FROM temp_ash2@bscs_to_rtx_link t,
         ccontact_all cc,
         contract_all co,
         contr_services_cap csc,
         directory_number dn
   WHERE     cc.customer_id = t.customer_id
         AND co.co_id = t.co_id
         AND csc.co_id = t.co_id
         AND dn.dn_id = csc.dn_id
         AND csc.cs_deactiv_date IS NULL
         AND csc.sncode = 1
         AND t.du IS NOT NULL
         --AND co.tmcode <> 30
ORDER BY 4 DESC;

SELECT *
  FROM rateplan@rtx_to_bscs_link
 WHERE tmcode > 70;


select * from temp_ash2@bscs_to_rtx_link

SELECT t.CUSTOMER_ID,
       t.CO_ID,
       co.tmcode,
       psp.spcode,
       cc.*
  FROM temp_ash@bscs_to_rtx_link t, ccontact_all cc, contract_all co, profile_service ps, PR_SERV_SPCODE_HIST psp
 WHERE     cc.customer_id = t.customer_id
       AND co.co_id = t.co_id
       AND ps.co_id = co.co_id
       AND PSP.CO_ID = ps.co_id
       and PSP.PROFILE_ID = PS.PROFILE_ID
       and PSP.SNCODE = PS.SNCODE
       and PSP.HISTNO = PS.SPCODE_HISTNO
       ANd lower(cc.ccfname) not like '%roaming%'
       ANd lower(cc.ccname) not like '%co %'
       ANd lower(cc.ccname) not like '%co/ %'
       ANd lower(cc.ccname) not like '%c/o %'
       and ps.sncode = 1
       AND co.tmcode = 31
       
       group by psp.spcode;

  SELECT co.tmcode, tm.des, COUNT (1)
    FROM temp_ash@bscs_to_rtx_link t, contract_all co, rateplan tm
   WHERE co.co_id = t.co_id AND tm.tmcode = co.tmcode
GROUP BY co.tmcode, tm.des
ORDER BY 3;


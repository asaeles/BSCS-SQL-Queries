SELECT /*+ FIRST_ROWS ORDERED */
       dn.dn_num, co.ch_status st, co.tmcode tm, tm.des rate_plan,
       psp.spcode sp, sp.des service_package
  FROM contract_all co,
       contr_services_cap csc,
       directory_number dn,
       pr_serv_spcode_hist psp,
       rateplan tm,
       mpusptab sp
 WHERE csc.co_id = co.co_id
   AND dn.dn_id = csc.dn_id
   AND psp.co_id = csc.co_id
   AND tm.tmcode = co.tmcode
   AND sp.spcode = psp.spcode
   AND co.tmcode <> 20
   AND co.ch_status <> 'd'
   AND csc.cs_deactiv_date IS NULL
   AND csc.main_dirnum = 'X'
   AND psp.profile_id = 0
   AND psp.histno =
          (SELECT MAX (histno)
             FROM pr_serv_spcode_hist
            WHERE co_id = psp.co_id
              AND profile_id = psp.profile_id
              AND sncode = csc.sncode)
SELECT dn.dn_num, bd.billcycle bc, bd.bch_run_date bc_date, sh.status bm,
       sh.valid_from_date bm_date, sh2.status bmb,
       sh2.valid_from_date bmb_date,
         TO_DATE ('01/01/1970', 'MM/DD/YYYY')
       + (next_reset_date / 86400) next_res_dt,
         TO_DATE ('01/01/1970', 'MM/DD/YYYY')
       + (balance_snapshot_date / 86400) bill_snap_dt,
       (pv.prm_value_number + cbv.credit_value) LIMIT, actual_value cur_val
  FROM DIRECTORY_NUMBER dn,
       CONTR_SERVICES_CAP csc,
       CONTRACT_ALL co,
       PROFILE_SERVICE ps,
       PARAMETER_VALUE pv,
       PR_SERV_STATUS_HIST sh,
       PR_SERV_STATUS_HIST sh2,
       COC_BALANCE_VALUE cbv,
       BILLCYCLE_ASSIGNMENT_HISTORY bah,
       BILLCYCLE_DEFINITION bd
 WHERE csc.dn_id = dn.dn_id
   AND co.co_id = csc.co_id
   AND ps.co_id = co.co_id
   AND pv.prm_value_id = ps.prm_value_id
   AND sh.co_id = ps.co_id
   AND sh.sncode = ps.sncode
   AND sh.profile_id = ps.profile_id
   AND sh2.co_id = co.co_id
   AND cbv.co_id = co.co_id
   AND bah.customer_id = co.customer_id
   AND bd.billcycle = bah.billcycle
   AND csc.cs_deactiv_date IS NULL
   AND pv.prm_no = 1
   AND sh.sncode = 65
   AND sh2.sncode = 133
   AND sh.histno =
          (SELECT MAX (histno)
             FROM PR_SERV_STATUS_HIST
            WHERE co_id = sh.co_id
              AND sncode = sh.sncode
              AND profile_id = sh.profile_id)
   AND sh2.histno =
          (SELECT MAX (histno)
             FROM PR_SERV_STATUS_HIST
            WHERE co_id = sh2.co_id
              AND sncode = sh2.sncode
              AND profile_id = sh2.profile_id)
   AND bah.seqno = (SELECT MAX (seqno)
                      FROM BILLCYCLE_ASSIGNMENT_HISTORY
                     WHERE customer_id = bah.customer_id)
   AND co.co_id = 8308;

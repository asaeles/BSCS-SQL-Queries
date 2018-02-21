SELECT /*+ FIRST_ROWS ORDERED */
      cu.customer_id cu_id, cu.custcode, cu.cslevel lvl, cu.prgcode prg,
       co.co_id, co.ch_status st, co.tmcode tm, dn.dn_num dial
  FROM customer_all cu, contract_all co, contr_services_cap csc,
       directory_number dn
 WHERE     co.customer_id = cu.customer_id
       AND csc.co_id = co.co_id
       AND dn.dn_id = csc.dn_id
       AND cu.custcode LIKE '1.%'                                           --
       AND cu.cstype = 'a'
       AND cu.tmcode IN (20, 29, 57)                                        --
       AND co.tmcode IN (20, 29, 57)                                        --
       --AND cu.prgcode = 1                                                 --
       AND cu.paymntresp = 'X'                                              --
       AND co.ch_status IN ('a', 's')
       AND csc.sncode != 1                                                  --
       AND csc.main_dirnum = 'X'
       AND csc.cs_activ_date IS NOT NULL
       AND csc.cs_deactiv_date IS NULL
       AND cu.customer_id > DBMS_RANDOM.VALUE (1, 10000)
       AND ROWNUM < 2;

SELECT /*+ FIRST_ROWS ORDERED */
      cu.customer_id cu_id, cu.custcode, cu.cslevel lvl, cu.prgcode prg,
       cu.tmcode cu_tm, tm.des rate_plan
  FROM customer_all cu, rateplan tm
 WHERE     tm.tmcode = cu.tmcode
       AND cu.custcode NOT LIKE '1.%'
       AND cu.cstype = 'a'
       AND cu.cslevel NOT IN (10, 40)
       AND cu.tmcode NOT IN (20, 29, 57, 42)                                    --
       AND cu.prgcode IN (2, 4)
       AND cu.paymntresp = 'X'                                              --
       AND cu.customer_id > DBMS_RANDOM.VALUE (1, 10000)
       AND ROWNUM < 2;
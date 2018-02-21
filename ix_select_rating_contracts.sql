SELECT /*+ FIRST_ROWS ORDERED */
      co.co_id || ','
  FROM contract_set ct, contract_all co
 WHERE     co.co_id >= ct.lower_bound
       AND co.co_id <= ct.upper_bound
       AND co.ch_status = 'a'
       AND co.tmcode != 20;

SELECT /*+ FIRST_ROWS ORDERED */
      co.co_id, co.tmcode, co.co_code, p.port_num, csc.sncode, dn.dn_num,
       cu.custcode
  FROM contract_all co, contr_devices cd, port p, contr_services_cap csc,
       directory_number dn, customer_all cu
 WHERE     cd.co_id = co.co_id
       AND p.port_id = cd.port_id
       AND csc.co_id = co.co_id
       AND dn.dn_id = csc.dn_id
       AND cu.customer_id = co.customer_id
       AND cd.cd_activ_date IS NOT NULL
       AND cd.cd_deactiv_date IS NULL
       AND csc.cs_activ_date IS NOT NULL
       AND csc.cs_deactiv_date IS NULL
       AND csc.main_dirnum = 'X'
       AND EXISTS
              (SELECT *
                 FROM contract_service
                WHERE co_id = co.co_id AND sncode = 92)
       AND co.co_id IN
              (106882380,
               106882381,
               106882383,
               106882385,
               106882386,
               106882390,
               106882393,
               106882396,
               106882397,
               106882398,
               106882402,
               106882404,
               106882405,
               106882406,
               106882412,
               106882413,
               106882414,
               106882420,
               106882421,
               106882423,
               106882424,
               106882425,
               106882427,
               106882428,
               106882429,
               106882430,
               106882432,
               106882434);
EDIT alcatel.cms_int_history where action_id = 3;

INSERT INTO alcatel.cms_int
   SELECT NULL, origin, original_id, 88, action_id, priority, insertion_date,
          status_update_date, input_data, error_message, output_data
     FROM alcatel.cms_int_history
    WHERE request_id = 163652214;

EDIT alcatel.cms_int where origin = '39264';

EDIT alcatel.cms_int_network where origin = '39264';
--244 184

SELECT * FROM alcatel.batch_process_config;

SELECT *
  FROM alcatel.batch_hdr
 WHERE process_id = 27;

SELECT *
  FROM alcatel.batch_hdr
 WHERE batch_number = 98436;

SELECT *
  FROM alcatel.cms_int
 WHERE origin = '98436';

  SELECT DISTINCT dn.dn_num, co.co_id, co.ch_status st, co.tmcode tm1,
                  psp.spcode sp1, cs.sncode sn, tmb2.tmcode tm2,
                  NVL (tmb.spcode, tmb2.spcode) sp2
    FROM directory_number dn, contr_services_cap csc, contract_all co,
         contract_service cs, profile_service ps, pr_serv_status_hist psh,
         pr_serv_spcode_hist psp, mpulktm1 tmb, mpulktm1 tmb2
   WHERE     csc.dn_id = dn.dn_id
         AND co.co_id = csc.co_id
         AND cs.co_id = co.co_id
         AND ps.co_id = cs.co_id
         AND ps.sncode = cs.sncode
         AND psh.co_id = ps.co_id
         AND psh.sncode = ps.sncode
         AND psh.profile_id = ps.profile_id
         AND psh.histno = ps.status_histno
         AND psp.co_id = ps.co_id
         AND psp.sncode = ps.sncode
         AND psp.profile_id = ps.profile_id
         AND psp.histno = ps.spcode_histno
         AND tmb.spcode(+) = psp.spcode
         AND tmb.sncode(+) = psp.sncode
         AND tmb2.sncode(+) = cs.sncode
         AND csc.cs_activ_date IS NOT NULL
         AND csc.cs_deactiv_date IS NULL
         AND co.ch_status != 'd'
         AND ps.profile_id = 0
         AND tmb.tmcode(+) = 103
         AND tmb2.tmcode(+) = 103
         --AND csc.co_id = 13179
         AND dn.dn_num = '1222119866'
ORDER BY psp.spcode, cs.sncode;

SELECT *
  FROM contract_all
 WHERE tmcode = 122;
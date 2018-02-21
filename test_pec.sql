/* Formatted on 4/26/2012 1:10:49 PM (QP5 v5.185.11230.41888) */
SELECT *
  FROM contract_all
 WHERE ch_status = 's' AND tmcode <> 20;

SELECT co.co_id,
       co.co_code,
       CO.CH_STATUS status,
       co.tmcode,
       tm.des,
       psp.spcode,
       sp.des,
       BAH.BILLCYCLE
  FROM contract_all co,
       rateplan tm,
       CONTR_SERVICES_CAP csc,
       PROFILE_SERVICE ps,
       PR_SERV_SPCODE_HIST psp,
       mpusptab sp,
       BILLCYCLE_ASSIGNMENT_HISTORY bah
 WHERE     co.co_id = 2795
       AND TM.TMCODE = co.tmcode
       AND csc.co_id = co.co_id
       AND ps.sncode = csc.sncode
       AND ps.co_id = co.co_id
       AND psp.co_id = ps.co_id
       AND psp.profile_id = ps.profile_id
       AND PSP.SNCODE = ps.sncode
       AND PSP.HISTNO = PS.SPCODE_HISTNO
       AND SP.SPCODE = psp.spcode
       AND BAH.CUSTOMER_ID = CO.CUSTOMER_ID
       AND csc.main_dirnum IS NOT NULL
       AND csc.seqno = (SELECT MAX (seqno)
                          FROM contr_services_cap
                         WHERE co_id = csc.co_id)
       AND BAH.SEQNO = (SELECT MAX (seqno)
                          FROM BILLCYCLE_ASSIGNMENT_HISTORY
                         WHERE customer_id = bah.customer_id);

UPDATE info_contr_combo
   SET combo01 = NULL
 WHERE combo01 IS NOT NULL;

SELECT new_sp, pcl.des
  FROM PEC_MIGRATION pm, pec_combo_list pcl
 WHERE pcl.spcode = pm.new_sp AND old_tm = 38 AND old_sp = 40;

UPDATE info_contr_combo
   SET combo01 = 'Star iPhone 399'
 WHERE co_id = 2795;

EDIT info_contr_combo WHERE co_id = 2795;

--cd /workdata/ALU_BIN/PEC/
--PEC_INSTANCES.sh start 03 1
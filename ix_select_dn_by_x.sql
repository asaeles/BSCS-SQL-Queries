/* Formatted on 2010/12/02 14:18 (Formatter Plus v4.8.7) */
SELECT   DECODE (dn.dn_id, dn2.dn_id, dn.dn_num, 'NEW: ' || dn2.dn_num) dial,
         cu.custcode, /*cu.billcycle bc, */ cu.customer_id,
         cu.cscurbalance bal, ub.unbilled_amount unb_amt, co.co_id, tm.tmcode,
         tm.des rate_plan, sp.spcode, sp.des service_package, sn.sncode,
         sn.des service, cc.ccline1, cc.ccline2, cc.ccline3, cc.ccline4,
         cc.ccline5, cc.ccline6, icc.combo01, icc.combo19, icc.combo20
    FROM CONTRACT_ALL co,
         PROFILE_SERVICE ps,
         PR_SERV_SPCODE_HIST psp,
         CONTR_SERVICES_CAP csc,
         DIRECTORY_NUMBER dn,
         CONTR_SERVICES_CAP csc2,
         DIRECTORY_NUMBER dn2,
         RATEPLAN tm,
         MPUSPTAB sp,
         MPUSNTAB sn,
         CCONTACT_ALL cc,
         CUSTOMER_ALL cu,
         MPUUBTAB ub,
         INFO_CUST_COMBO icc
   WHERE ps.co_id = co.co_id
     AND ps.sncode = 1
     AND psp.sncode = ps.sncode
     AND psp.profile_id = ps.profile_id
     AND psp.histno = ps.spcode_histno
     AND dn.dn_id = csc.dn_id
     AND csc.cs_deactiv_date IS NULL
     AND (csc.cs_request = (SELECT MAX (cs_request)
                              FROM CONTR_SERVICES_CAP
                             WHERE dn_id = dn.dn_id) OR csc.cs_request IS NULL
         )
     AND csc2.co_id = csc.co_id
     AND csc2.sncode = csc.sncode
     AND dn2.dn_id = csc2.dn_id
     AND psp.co_id = ps.co_id
     AND tm.tmcode = co.tmcode
     AND sp.spcode = psp.spcode
     AND sn.sncode = ps.sncode
     AND co.co_id = csc.co_id
     AND cc.customer_id = co.customer_id
     AND cc.ccseq = 1
     AND cu.customer_id = co.customer_id
     AND ub.customer_id(+) = co.customer_id
     AND icc.customer_id(+) = co.customer_id
ORDER BY 1;

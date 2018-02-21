/* Formatted on 2010/10/17 17:53 (Formatter Plus v4.8.7) */
SELECT DISTINCT eg.egcode, eg.des,
                egm.usgglcode ofpk_base_rev, egm.usgglcode_disc ofpk_base_dis, egm.usgglcode_mincom ofpk_base_min,
                egm2.usgglcode ofpk_intc_rev, egm2.usgglcode_disc ofpk_intc_dis, egm2.usgglcode_mincom ofpk_intc_min,
                egm3.usgglcode pk_base_rev, egm3.usgglcode_disc pk_base_dis, egm3.usgglcode_mincom pk_base_min,
                egm4.usgglcode pk_intc_rev, egm4.usgglcode_disc pk_intc_dis, egm4.usgglcode_mincom pk_intc_min
           FROM MPULKTMM tmm,
                RATEPLAN tm,
                MPUSPTAB sp,
                MPUEGTAB eg,
                MPULKEGM egm,
                MPULKEGM egm2,
                MPULKEGM egm3,
                MPULKEGM egm4,
                MPUZNTAB zn
          WHERE tm.tmcode = tmm.tmcode
            AND sp.spcode = tmm.spcode
            AND eg.egcode = tmm.egcode
            AND egm.egcode = tmm.egcode
            AND egm2.egcode = egm.egcode
            AND egm2.vscode = egm.vscode
            AND egm2.vsdate = egm.vsdate
            AND egm2.gvcode = egm.gvcode
            AND egm2.gvvscode = egm.gvvscode
            AND egm2.zncode = egm.zncode
            AND egm2.twcode = egm.twcode
            AND egm2.twvscode = egm.twvscode
            AND egm2.chargeable_quantity_udmcode =
                                               egm.chargeable_quantity_udmcode
            AND egm3.egcode = egm.egcode
            AND egm3.vscode = egm.vscode
            AND egm3.vsdate = egm.vsdate
            AND egm3.gvcode = egm.gvcode
            AND egm3.gvvscode = egm.gvvscode
            AND egm3.zncode = egm.zncode
            AND egm3.twcode = egm.twcode
            AND egm3.twvscode = egm.twvscode
            AND egm3.chargeable_quantity_udmcode =
                                               egm.chargeable_quantity_udmcode
            AND egm4.egcode = egm.egcode
            AND egm4.vscode = egm.vscode
            AND egm4.vsdate = egm.vsdate
            AND egm4.gvcode = egm.gvcode
            AND egm4.gvvscode = egm.gvvscode
            AND egm4.zncode = egm.zncode
            AND egm4.twcode = egm.twcode
            AND egm4.twvscode = egm.twvscode
            AND egm4.chargeable_quantity_udmcode =
                                               egm.chargeable_quantity_udmcode
            AND zn.zncode = egm.zncode
            AND tmm.sncode = 54
            AND egm.chargeable_quantity_udmcode = 38
            AND egm.ttcode = 1 AND egm.rate_type_id = 1
            AND egm2.ttcode = 1 AND egm2.rate_type_id = 2
            AND egm3.ttcode = 2 AND egm3.rate_type_id = 1
            AND egm4.ttcode = 2 AND egm4.rate_type_id = 2
            AND zn.des LIKE '%Premium SMS 5%'
            AND tmm.tmcode NOT IN (SELECT DISTINCT tmcode
                                              FROM RATEPLAN_AVAILABILITY_PERIOD)
            AND tmm.vscode = (SELECT MAX (vscode)
                                FROM RATEPLAN_VERSION
                               WHERE tmcode = tmm.tmcode)
            AND egm.vscode = (SELECT MAX (vscode)
                                FROM MPUEGVSD
                               WHERE egcode = egm.egcode)
       ORDER BY 1;

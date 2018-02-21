/* DECODE (dn.dn_id, dn2.dn_id, dn.dn_id, dn2.dn_id) dn_id, */

  SELECT DECODE (dn.dn_id, dn2.dn_id, dn.dn_num, 'NEW: ' || dn2.dn_num) dial,
         cu.custcode, cu.lbc_date bc, ixd.due_date due, cu.customer_id,
         cu.csactivated act_date, cu.cstype t, cu.cscurbalance bal,
         ub.unbilled_amount unb_amt, ba.csbillmedium bm, co.co_id,
         co.co_activated co_act_date, co.ch_status s, tm.tmcode,
         tm.des rate_plan, sp.spcode, sp.des service_package, sn.sncode,
         sn.des service, ri.ricode ri, ri.des rat_pack, cc.ccline1, cc.ccline2,
         cc.ccline3, cc.ccline4, cc.ccline5, cc.ccline6, fut.branch_code b,
         fued.*, icc.combo01, icc.combo19, icc.combo20, ico.combo01
    FROM directory_number dn, contr_services_cap csc, contr_services_cap csc2,
         directory_number dn2, contract_all co, customer_all cu,
         ccontact_all cc, mpuubtab ub, billing_account ba, lbc_date_hist ldh,
         mpulkixd ixd, rateplan tm, mpulktmm tmm, mpuritab ri, fup_tariff fut,
         fup_element_definition fued, profile_service ps,
         pr_serv_spcode_hist psp, mpusptab sp, mpusntab sn, info_cust_combo icc,
         info_contr_combo ico
   WHERE     dn.dn_num IN ('1276958064')
         AND csc.dn_id = dn.dn_id
         AND (   csc.cs_request = (SELECT MAX (cs_request)
                                     FROM contr_services_cap
                                    WHERE dn_id = dn.dn_id)
              OR csc.cs_request IS NULL)
         AND csc2.co_id = csc.co_id
         AND csc2.sncode = csc.sncode
         AND csc2.cs_deactiv_date IS NULL
         AND dn2.dn_id = csc2.dn_id
         AND ps.co_id = csc.co_id
         AND ps.sncode = csc.sncode
         AND psp.co_id = ps.co_id
         AND psp.sncode = ps.sncode
         AND psp.profile_id = ps.profile_id
         AND psp.histno = ps.spcode_histno
         AND tm.tmcode = co.tmcode
         AND tmm.tmcode = co.tmcode
         AND tmm.spcode = psp.spcode
         AND tmm.sncode = ps.sncode
         AND ri.ricode = tmm.ricode
         AND sp.spcode = psp.spcode
         AND sn.sncode = ps.sncode
         AND co.co_id = csc.co_id
         AND cc.customer_id = co.customer_id
         AND fut.tmcode(+) = co.tmcode
         AND fued.fu_pack_id(+) = fut.fu_pack_id
         AND fued.work_state(+) = 'P'
         AND cc.ccseq = 1
         AND cu.customer_id = co.customer_id
         AND ub.customer_id(+) = co.customer_id
         AND ba.customer_id(+) = co.customer_id
         AND ba.primary_flag(+) = 'X'
         AND ldh.customer_id(+) = cu.customer_id
         AND ldh.lbc_date(+) = cu.lbc_date
         AND ixd.billseqno(+) = ldh.billseqno
         AND icc.customer_id(+) = co.customer_id
         AND ico.co_id(+) = co.co_id
         AND NVL (fut.valid_to(+), TRUNC (SYSDATE)) >= TRUNC (SYSDATE)
         AND tmm.vscode = (SELECT MAX (vscode)
                             FROM rateplan_version
                            WHERE tmcode = tmm.tmcode AND vsdate < SYSDATE)
         AND (   fued.fup_version =
                    (SELECT MAX (fup_version)
                       FROM fup_version
                      WHERE     fu_pack_id = fued.fu_pack_id
                            AND valid_from < SYSDATE)
              OR fued.fup_version IS NULL)
         AND (   fued.version =
                    (SELECT MAX (version)
                       FROM fup_element_definition
                      WHERE     fu_pack_id = fued.fu_pack_id
                            AND fup_version = fued.fup_version
                            AND fup_seq = fued.fup_seq
                            AND valid_from < SYSDATE)
              OR fued.version IS NULL)
ORDER BY fued.fu_pack_id, fued.fup_seq;

  SELECT fu.fu_pack_id fu, fu.long_name fu_pack,
         DECODE (fued.free_units_uom, 1, fued.free_units_volume / 60, fued.free_units_volume) vol,
         DECODE (um.shdes, 'Sec', 'Min', um.shdes) uom, zn.zncode zn,
         zn.des tariff_zone, zp.des dest, zp.digits                 --, fusc.*
    FROM fup_element_definition fued, fu_pack fu, mpsumtab um,
         fup_select_criteria fusc, mpuzntab zn, mpuzptab zp
   WHERE     fu.fu_pack_id = fued.fu_pack_id
         AND fusc.fu_pack_id = fued.fu_pack_id
         AND fusc.fup_version = fued.fup_version
         AND fusc.fup_seq = fued.fup_seq
         AND fusc.version = fued.version
         AND um.umcode = fued.free_units_uom
         AND zn.zncode(+) = fusc.tariff_zone_code
         AND zp.zpcode(+) = fusc.destination_code
         AND fued.fu_pack_id IN (1098)
         AND fued.fup_version =
                (SELECT MAX (fup_version)
                   FROM fup_version
                  WHERE fu_pack_id = fued.fu_pack_id AND valid_from < SYSDATE)
         AND fued.version =
                (SELECT MAX (version)
                   FROM fup_element_definition
                  WHERE     fu_pack_id = fued.fu_pack_id
                        AND fup_version = fued.fup_version
                        AND fup_seq = fued.fup_seq
                        AND valid_from < SYSDATE)
ORDER BY fued.fu_pack_id, fued.fup_seq, zn.des;
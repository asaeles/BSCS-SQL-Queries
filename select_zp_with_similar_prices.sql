/* Formatted on 7/16/2012 2:16:54 PM (QP5 v5.185.11230.41888) */
  SELECT zpcode, zpdes, eng, ara, digits, SUM (sncode), COUNT (1)
    FROM (  SELECT DISTINCT zpcode, digits, tmm.sncode, zpdes, n1.translation eng,
                            n2.translation ara
              FROM mpulktmm tmm, mputmtab tm, mpusptab sp, mpusntab sn,
                   mpulktmb tmb, udc_usage_type_table uutt, mpulkrim rim,
                   mpurivsd riv, mpuuptab UP, mpuritab ri, mpugvtab gv,
                   mpuzntab zn, mpulktwm twm, mputwtab tw, mputttab tt,
                   udc_rate_type_table urtt, rate_pack_element rpe,
                   udc_chargeable_quantity_view ucqv,
                   rate_pack_parameter_value rppv,
                   conversion_module_parameter cmp, mpulkgvm gvm, nls_dict n1,
                   nls_dict n2
             WHERE     tm.tmcode = tmm.tmcode
                   AND tm.vscode = tmm.vscode
                   AND sp.spcode = tmm.spcode
                   AND sn.sncode = tmm.sncode
                   AND tmb.tmcode = tmm.tmcode
                   AND tmb.vscode = tmm.vscode
                   AND tmb.spcode = tmm.spcode
                   AND tmb.sncode = tmm.sncode
                   AND uutt.usage_type_id = tmm.usage_type_id
                   AND rim.ricode = tmm.ricode
                   AND riv.ricode = rim.ricode
                   AND riv.vscode = rim.vscode
                   AND UP.upcode = riv.upcode
                   AND ri.ricode = rim.ricode
                   AND gv.gvcode = rim.gvcode
                   AND zn.zncode = rim.zncode
                   AND twm.twcode = rim.twcode
                   AND twm.vscode = rim.twvscode
                   AND twm.ttcode = rim.ttcode
                   AND tw.twcode = twm.twcode
                   AND tt.ttcode = twm.ttcode
                   AND urtt.rate_type_id = rim.rate_type_id
                   AND rpe.rate_pack_entry_id = rim.rate_pack_entry_id
                   AND ucqv.chargeable_quantity_udmcode =
                          rpe.chargeable_quantity_udmcode
                   AND rppv.rate_pack_element_id = rpe.rate_pack_element_id
                   AND cmp.conversion_module_id = rpe.conversion_module_id
                   AND cmp.parameter_seqnum = rppv.parameter_seqnum
                   AND gvm.gvcode = rim.gvcode
                   AND gvm.vscode = rim.gvvscode
                   AND gvm.zncode = rim.zncode
                   AND n1.key_value(+) = TO_CHAR (zpcode)
                   AND n2.key_value(+) = TO_CHAR (zpcode)
                   AND rpe.conversion_module_id = 1
                   AND rppv.parameter_seqnum = 4
                   AND n1.lng_id(+) = 1
                   AND n1.base_tab(+) = 'MPUZPTAB'
                   AND n1.tran_col(+) = 'DES'
                   AND n2.lng_id(+) = 2
                   AND n2.base_tab(+) = 'MPUZPTAB'
                   AND n2.tran_col(+) = 'DES'
                   AND tmm.vscode = (SELECT MAX (vscode)
                                       FROM mpulktmm tmm2
                                      WHERE tmm.tmcode = tmm2.tmcode)
                   AND rim.vscode = (SELECT MAX (vscode)
                                       FROM mpulkrim rim2
                                      WHERE rim.ricode = rim2.ricode)
                   AND rppv.parameter_rownum IN
                          (SELECT parameter_rownum
                             FROM rate_pack_parameter_value
                            WHERE     rate_pack_element_id =
                                         rppv.rate_pack_element_id
                                  AND parameter_seqnum = 3
                                  AND parameter_value_float = 999)
                   AND (urtt.rate_type_id = 1 OR rppv.parameter_value_float <> 0)
                   AND tmm.tmcode = 80
                   AND (   (rppv.parameter_value_float = 300 AND tmm.sncode = 54)
                        OR tmm.sncode IN (1))
          ORDER BY digits)
  HAVING COUNT (1) = 1 AND SUM (sncode) = 54
GROUP BY zpcode, zpdes, eng, ara, digits
ORDER BY 1;
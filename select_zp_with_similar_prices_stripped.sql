/* Formatted on 7/16/2012 2:20:59 PM (QP5 v5.185.11230.41888) */
  SELECT zpcode, zpdes, eng, ara, digits, SUM (sncode) sn_comb,
         COUNT (1) sn_num
    FROM (  SELECT DISTINCT zpcode, digits, tmm.sncode, zpdes, n1.translation eng,
                            n2.translation ara
              FROM mpulktmm tmm, mpulkrim rim, rate_pack_element rpe,
                   rate_pack_parameter_value rppv, mpulkgvm gvm, nls_dict n1,
                   nls_dict n2
             WHERE     rim.ricode = tmm.ricode
                   AND rpe.rate_pack_entry_id = rim.rate_pack_entry_id
                   AND rppv.rate_pack_element_id = rpe.rate_pack_element_id
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
                   AND (rim.rate_type_id = 1 OR rppv.parameter_value_float <> 0)
                   AND tmm.tmcode = 80
                   AND (   (rppv.parameter_value_float = 300 AND tmm.sncode = 54)
                        OR tmm.sncode IN (1))
          ORDER BY digits)
  HAVING COUNT (1) = 1 AND SUM (sncode) = 54
GROUP BY zpcode, zpdes, eng, ara, digits
ORDER BY 1;
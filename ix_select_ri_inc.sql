/* Formatted on 6/3/2012 6:10:48 PM (QP5 v5.185.11230.41888) */
  SELECT /*+ FIRST_ROWS ORDERED */
        DISTINCT tmm.sncode,
                 sn.des service,
                 ri2.ricode,
                 ri.des rate_pack,
                 gvm.gvcode,
                 ri2.gvvscode cur_vscode,
                 gvm.vscode,
                 zn.*
    FROM mpulktmm tmm,
         mpusntab sn,
         mpulkri2 ri2,
         mpuritab ri,
         mpulkgvm gvm,
         mpuzntab zn
   WHERE     sn.sncode = tmm.sncode
         AND ri2.ricode = tmm.ricode
         AND ri.ricode = ri2.ricode
         AND gvm.gvcode = ri2.gvcode
         AND zn.zncode = gvm.zncode
         AND tmm.vscode = (SELECT MAX (vscode)
                             FROM rateplan_version
                            WHERE tmcode = tmm.tmcode)
         AND tmm.tmcode NOT IN (SELECT tmcode
                                  FROM rateplan_availability_period
                                 WHERE tmcode <> 71)
         AND gvm.vscode = (SELECT MAX (vscode)
                             FROM mpugvvsd
                            WHERE gvcode = gvm.gvcode)
         AND NOT EXISTS
                    (SELECT 1
                       FROM mpulkri2
                      WHERE     ricode = ri2.ricode
                            AND gvcode = gvm.gvcode
                            AND zncode = gvm.zncode)
         AND ri2.ricode IN
                (15,
                 17,
                 19,
                 31,
                 32,
                 33,
                 34,
                 35,
                 36,
                 37,
                 38,
                 41,
                 42,
                 46,
                 47,
                 53,
                 55,
                 58,
                 60,
                 61,
                 64,
                 66,
                 105,
                 118,
                 119,
                 412,
                 413)
ORDER BY sncode, ricode;

      /*  SELECT *
    FROM (SELECT 'RIM-RI2' src, mmw.*
            FROM (SELECT rim.ricode,
                         rim.gvcode,
                         --rim.gvvscode,
                         rim.zncode,
                         rim.twcode,
                         rim.twvscode,
                         rim.ttcode,
                         rim.rec_version,
                         rim.rate_type_id,
                         rim.perform_rating_ind,
                         rim.external_charge_scalefactor,
                         rpe.chargeable_quantity_udmcode,
                         rpe.conversion_module_id,
                         rpe.price_logical_quantity_code,
                         rpe.rate_pack_imc_scalefactor,
                         rpe.pricing_type,
                         rppv.parameter_seqnum,
                         rppv.parameter_rownum,
                         rppv.parameter_value_float
                    FROM mpulkrim rim,
                         rate_pack_element rpe,
                         rate_pack_parameter_value rppv
                   WHERE     rpe.rate_pack_entry_id = rim.rate_pack_entry_id
                         AND rppv.rate_pack_element_id =
                                rpe.rate_pack_element_id
                         AND rim.vscode = (SELECT MAX (vscode)
                                             FROM mpurivsd
                                            WHERE ricode = rim.ricode)
                  MINUS
                  SELECT ri2.ricode,
                         ri2.gvcode,
                         --ri2.gvvscode,
                         ri2.zncode,
                         ri2.twcode,
                         ri2.twvscode,
                         ri2.ttcode,
                         ri2.rec_version,
                         ri2.rate_type_id,
                         ri2.perform_rating_ind,
                         ri2.external_charge_scalefactor,
                         rpe.chargeable_quantity_udmcode,
                         rpe.conversion_module_id,
                         rpe.price_logical_quantity_code,
                         rpe.rate_pack_imc_scalefactor,
                         rpe.pricing_type,
                         rppv.parameter_seqnum,
                         rppv.parameter_rownum,
                         rppv.parameter_value_float
                    FROM mpulkri2 ri2,
                         rate_pack_element_work rpe,
                         rate_pack_parameter_value_work rppv
                   WHERE     rpe.rate_pack_entry_id = ri2.rate_pack_entry_id
                         AND rppv.rate_pack_element_id =
                                rpe.rate_pack_element_id) mmw
          UNION
          SELECT 'RI2-RIM' src, wmm.*
            FROM (SELECT ri2.ricode,
                         ri2.gvcode,
                         --ri2.gvvscode,
                         ri2.zncode,
                         ri2.twcode,
                         ri2.twvscode,
                         ri2.ttcode,
                         ri2.rec_version,
                         ri2.rate_type_id,
                         ri2.perform_rating_ind,
                         ri2.external_charge_scalefactor,
                         rpe.chargeable_quantity_udmcode,
                         rpe.conversion_module_id,
                         rpe.price_logical_quantity_code,
                         rpe.rate_pack_imc_scalefactor,
                         rpe.pricing_type,
                         rppv.parameter_seqnum,
                         rppv.parameter_rownum,
                         rppv.parameter_value_float
                    FROM mpulkri2 ri2,
                         rate_pack_element_work rpe,
                         rate_pack_parameter_value_work rppv
                   WHERE     rpe.rate_pack_entry_id = ri2.rate_pack_entry_id
                         AND rppv.rate_pack_element_id =
                                rpe.rate_pack_element_id
                  MINUS
                  SELECT rim.ricode,
                         rim.gvcode,
                         --rim.gvvscode,
                         rim.zncode,
                         rim.twcode,
                         rim.twvscode,
                         rim.ttcode,
                         rim.rec_version,
                         rim.rate_type_id,
                         rim.perform_rating_ind,
                         rim.external_charge_scalefactor,
                         rpe.chargeable_quantity_udmcode,
                         rpe.conversion_module_id,
                         rpe.price_logical_quantity_code,
                         rpe.rate_pack_imc_scalefactor,
                         rpe.pricing_type,
                         rppv.parameter_seqnum,
                         rppv.parameter_rownum,
                         rppv.parameter_value_float
                    FROM mpulkrim rim,
                         rate_pack_element rpe,
                         rate_pack_parameter_value rppv
                   WHERE     rpe.rate_pack_entry_id = rim.rate_pack_entry_id
                         AND rppv.rate_pack_element_id =
                                rpe.rate_pack_element_id
                         AND rim.vscode = (SELECT MAX (vscode)
                                             FROM mpurivsd
                                            WHERE ricode = rim.ricode)) wmm)
   WHERE ricode IN
            (15,
             17,
             19,
             31,
             32,
             33,
             34,
             35,
             36,
             37,
             38,
             41,
             42,
             46,
             47,
             53,
             55,
             58,
             60,
             61,
             64,
             66,
             105,
             118,
             119,
             412,
             413)
ORDER BY ricode,
         gvcode,
         zncode,
         twcode,
         twvscode,
         ttcode,
         rate_type_id,
         parameter_seqnum,
         parameter_rownum,
         parameter_value_float;*/
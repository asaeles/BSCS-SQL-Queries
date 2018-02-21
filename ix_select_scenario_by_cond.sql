  SELECT sce.priority, ucc.complex_cond_id cc, ucc.short_des complex_cond,
         bs.business_scenario_id bs, bs.business_scenario_des business_scenario,
         ue.uds_element_code ue, ue.uds_element_des uds_element,
         dd.data_value dv, dd.description data_value_desc, usc.*, urv.*, uc.*,
         ucc.*, sce.*, bs.*
    FROM udc_simple_cond usc, uds_element ue, data_domain dd,
         udc_reference_value urv, udc_chain uc, udc_complex_cond ucc,
         system_scenario_element sce, business_scenario bs
   WHERE     ue.uds_element_code = usc.uds_element_code
         AND dd.data_class_id = ue.data_class_id
         AND urv.simple_cond_id = usc.simple_cond_id
         AND (   urv.ref_integer = dd.data_value
              OR urv.ref_float = dd.data_value
              OR urv.ref_string = dd.data_value)
         AND uc.chain_id = usc.chain_id
         AND ucc.complex_cond_id = uc.complex_cond_id
         AND sce.complex_cond_id = ucc.complex_cond_id
         AND bs.business_scenario_id = sce.business_scenario_id
         AND usc.uds_element_code = 70
         AND urv.ref_string = 'V'
         AND uc.version != 0
         AND sce.version = (SELECT MAX (version)
                              FROM system_scenario_version
                             WHERE system_scenario_id = sce.system_scenario_id)
ORDER BY sce.priority;
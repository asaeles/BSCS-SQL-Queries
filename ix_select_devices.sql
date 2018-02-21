SELECT csc.co_id,
       dn.hlcode dn_hlcode,
       cd.hlcode cd_hlcode,
       p.hlcode p_hlcode,
       dn.dn_id,
       p.port_id,
       sm.sm_id,
       p.port_num imsi,
       sm.sm_serialnum sim_serial
  FROM directory_number dn,
       contr_services_cap csc,
       contr_devices cd,
       port p,
       storage_medium sm
 WHERE     csc.dn_id = dn.dn_id
       AND cd.co_id = csc.co_id
       AND p.port_id = cd.port_id
       AND sm.sm_id = p.sm_id
       AND dn.dn_num = '1223190345'
       AND csc.cs_deactiv_date IS NULL;
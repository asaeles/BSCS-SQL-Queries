SELECT SM.SM_SERIALNUM || ';' || DN.DN_NUM res
  FROM (SELECT /*+ FIRST_ROWS ORDERED */
              sm.sm_serialnum, ROWNUM rn
          FROM port p, storage_medium sm
         WHERE     p.hlcode = 58
               AND sm.sm_id = p.sm_id
               AND p.port_assign_date IS NULL
               AND sm.sm_status = 'r'
               AND ROWNUM < 100) sm,
       (SELECT dn.dn_num, ROWNUM rn
          FROM directory_number dn
         WHERE     dn.hlcode = 58
               AND dn.dn_status = 'r'
               AND dn.dn_assign_date IS NULL
               AND ROWNUM < 100) dn
 WHERE dn.rn = sm.rn;

SELECT *
  FROM uds_item_view uiv, uds_element_view uev, sys.all_tab_cols tc
 WHERE     uev.uds_element_code = uiv.uds_element_code
       AND tc.column_name(+) = uiv.column_name
       AND tc.owner(+) = 'SYSADM'
       AND tc.table_name(+) = 'UDR_LT';
--       AND uiv.column_name LIKE '%CUG%';

SELECT * FROM call_detail_info;
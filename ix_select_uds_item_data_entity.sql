  SELECT *
    FROM uds_item_view   uiv,
         call_detail_info cdi,
         uds_element     u,
         data_class      dc,
         data_entity     de
   WHERE     cdi.uds_member_code(+) = uiv.uds_member_code
         AND cdi.uds_element_code(+) = uiv.uds_element_code
         AND u.uds_element_code = uiv.uds_element_code
         AND dc.data_class_id = u.data_class_id
         AND de.data_class_id(+) = dc.data_class_id
ORDER BY uiv.uds_member_code, uiv.uds_element_code;

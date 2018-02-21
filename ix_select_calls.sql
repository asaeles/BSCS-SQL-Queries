  SELECT s_p_number_address,
         start_time_timestamp + start_time_offset / 86400 call_time,
         o_p_number_address dial, duration_volume dur, messages_volume sms,
         data_volume data, rounded_volume ROUND, s_p_equipment_number imei,
         s_p_location_address cell_id, mnp_rn_address mnp, tz_dn_address tz
    FROM udr_lt
   WHERE     cust_info_customer_id = 103068720
         AND cust_info_contract_id = 105827173
         AND start_time_timestamp + start_time_offset / 86400 > '01-MAR-2015'
ORDER BY start_time_timestamp;

  SELECT *
    FROM udr_lt
   WHERE     cust_info_customer_id = 103068720
         AND cust_info_contract_id = 105827173
         AND start_time_timestamp + start_time_offset / 86400 > '01-MAR-2015'
ORDER BY start_time_timestamp;
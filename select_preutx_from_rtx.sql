/* Formatted on 2009/11/10 15:45 (Formatter Plus v4.8.7) */
SELECT start_time_timestamp, start_time_offset OFF, data_volume DATA,
       duration_volume dur, messages_volume mess, rounded_volume_umcode typ,
       s_p_equipment_class_mark cl_mk, s_p_number_address s_p_msisdn,
       s_p_port_address s_p_imsi, s_p_equipment_number s_p_imei,
       s_p_location_address s_p_cgi, normed_net_elem_address s_p_msc_id,
       o_p_number_address o_p_address, service_logic_code svl_code
  FROM udr_lt_505
 WHERE cust_info_customer_id = 8815229;

-- AND rounded_volume_umcode = 1;

SELECT *
  FROM udr_lt_505
 WHERE cust_info_customer_id = 11026;

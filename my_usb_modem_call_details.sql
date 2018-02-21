/* Formatted on 2010/06/15 00:06 (Formatter Plus v4.8.7) */
SELECT * FROM ( 
SELECT   517, start_time_timestamp, entry_date_timestamp + entry_date_offset / 3600 / 24 ent,
         u.start_time_timestamp + start_time_offset / 3600 / 24 st,
         data_volume c3, data_volume_umcode c4, downlink_volume_umcode c5,
         downlink_volume_volume c6, duration_volume c7, messages_volume c20,
         rated_clicks_volume c21, rated_flat_amount c22,
         rated_flat_amount_currency c23, rated_flat_amount_gross_ind c24,
         rated_flat_amount_orig_amount c25, rated_flat_amount_tax c27,
         rated_volume c28, rated_volume_umcode c29, rounded_volume c30,
         rounded_volume_umcode c31, uplink_volume_volume c37,
         xfile_charge_amount c39, zero_rated_volume_umcode c42,
         zero_rated_volume_volume c43, zero_rounded_volume_umcode c44,
         zero_rounded_volume_volume c45, remark
    FROM udr_lt_517@arcrtx u
   WHERE u.cust_info_customer_id = 34062797
     AND (u.start_time_timestamp + start_time_offset / 3600 / 24) >=
                                          TO_DATE ('14/02/2010', 'dd/mm/yyyy')
     AND (u.start_time_timestamp + start_time_offset / 3600 / 24) <
                                          TO_DATE ('16/03/2010', 'dd/mm/yyyy')
										  UNION ALL
SELECT   518, start_time_timestamp, entry_date_timestamp + entry_date_offset / 3600 / 24 ent,
         u.start_time_timestamp + start_time_offset / 3600 / 24 st,
         data_volume c3, data_volume_umcode c4, downlink_volume_umcode c5,
         downlink_volume_volume c6, duration_volume c7, messages_volume c20,
         rated_clicks_volume c21, rated_flat_amount c22,
         rated_flat_amount_currency c23, rated_flat_amount_gross_ind c24,
         rated_flat_amount_orig_amount c25, rated_flat_amount_tax c27,
         rated_volume c28, rated_volume_umcode c29, rounded_volume c30,
         rounded_volume_umcode c31, uplink_volume_volume c37,
         xfile_charge_amount c39, zero_rated_volume_umcode c42,
         zero_rated_volume_volume c43, zero_rounded_volume_umcode c44,
         zero_rounded_volume_volume c45, remark
    FROM udr_lt_518@arcrtx u
   WHERE u.cust_info_customer_id = 34062797
     AND (u.start_time_timestamp + start_time_offset / 3600 / 24) >=
                                          TO_DATE ('14/02/2010', 'dd/mm/yyyy')
     AND (u.start_time_timestamp + start_time_offset / 3600 / 24) <
                                          TO_DATE ('16/03/2010', 'dd/mm/yyyy')
										  UNION ALL
SELECT   519, start_time_timestamp, entry_date_timestamp + entry_date_offset / 3600 / 24 ent,
         u.start_time_timestamp + start_time_offset / 3600 / 24 st,
         data_volume c3, data_volume_umcode c4, downlink_volume_umcode c5,
         downlink_volume_volume c6, duration_volume c7, messages_volume c20,
         rated_clicks_volume c21, rated_flat_amount c22,
         rated_flat_amount_currency c23, rated_flat_amount_gross_ind c24,
         rated_flat_amount_orig_amount c25, rated_flat_amount_tax c27,
         rated_volume c28, rated_volume_umcode c29, rounded_volume c30,
         rounded_volume_umcode c31, uplink_volume_volume c37,
         xfile_charge_amount c39, zero_rated_volume_umcode c42,
         zero_rated_volume_volume c43, zero_rounded_volume_umcode c44,
         zero_rounded_volume_volume c45, remark
    FROM udr_lt_519@arcrtx u
   WHERE u.cust_info_customer_id = 34062797
     AND (u.start_time_timestamp + start_time_offset / 3600 / 24) >=
                                          TO_DATE ('14/02/2010', 'dd/mm/yyyy')
     AND (u.start_time_timestamp + start_time_offset / 3600 / 24) <
                                          TO_DATE ('16/03/2010', 'dd/mm/yyyy')
										  UNION ALL
SELECT   520, start_time_timestamp, entry_date_timestamp + entry_date_offset / 3600 / 24 ent,
         u.start_time_timestamp + start_time_offset / 3600 / 24 st,
         data_volume c3, data_volume_umcode c4, downlink_volume_umcode c5,
         downlink_volume_volume c6, duration_volume c7, messages_volume c20,
         rated_clicks_volume c21, rated_flat_amount c22,
         rated_flat_amount_currency c23, rated_flat_amount_gross_ind c24,
         rated_flat_amount_orig_amount c25, rated_flat_amount_tax c27,
         rated_volume c28, rated_volume_umcode c29, rounded_volume c30,
         rounded_volume_umcode c31, uplink_volume_volume c37,
         xfile_charge_amount c39, zero_rated_volume_umcode c42,
         zero_rated_volume_volume c43, zero_rounded_volume_umcode c44,
         zero_rounded_volume_volume c45, remark
    FROM udr_lt_520@arcrtx u
   WHERE u.cust_info_customer_id = 34062797
     AND (u.start_time_timestamp + start_time_offset / 3600 / 24) >=
                                          TO_DATE ('14/02/2010', 'dd/mm/yyyy')
     AND (u.start_time_timestamp + start_time_offset / 3600 / 24) <
                                          TO_DATE ('16/03/2010', 'dd/mm/yyyy')
										  UNION ALL
SELECT   521, start_time_timestamp, entry_date_timestamp + entry_date_offset / 3600 / 24 ent,
         u.start_time_timestamp + start_time_offset / 3600 / 24 st,
         data_volume c3, data_volume_umcode c4, downlink_volume_umcode c5,
         downlink_volume_volume c6, duration_volume c7, messages_volume c20,
         rated_clicks_volume c21, rated_flat_amount c22,
         rated_flat_amount_currency c23, rated_flat_amount_gross_ind c24,
         rated_flat_amount_orig_amount c25, rated_flat_amount_tax c27,
         rated_volume c28, rated_volume_umcode c29, rounded_volume c30,
         rounded_volume_umcode c31, uplink_volume_volume c37,
         xfile_charge_amount c39, zero_rated_volume_umcode c42,
         zero_rated_volume_volume c43, zero_rounded_volume_umcode c44,
         zero_rounded_volume_volume c45, remark
    FROM udr_lt_521@arcrtx u
   WHERE u.cust_info_customer_id = 34062797
     AND (u.start_time_timestamp + start_time_offset / 3600 / 24) >=
                                          TO_DATE ('14/02/2010', 'dd/mm/yyyy')
     AND (u.start_time_timestamp + start_time_offset / 3600 / 24) <
                                          TO_DATE ('16/03/2010', 'dd/mm/yyyy')
										 )
ORDER BY start_time_timestamp                                           --DESC

SELECT   666, start_time_timestamp, entry_date_timestamp + entry_date_offset / 3600 / 24 ent,
         u.start_time_timestamp + start_time_offset / 3600 / 24 st,
         data_volume c3, data_volume_umcode c4, downlink_volume_umcode c5,
         downlink_volume_volume c6, duration_volume c7, messages_volume c20,
         rated_clicks_volume c21, rated_flat_amount c22,
         rated_flat_amount_currency c23, rated_flat_amount_gross_ind c24,
         rated_flat_amount_orig_amount c25, rated_flat_amount_tax c27,
         rated_volume c28, rated_volume_umcode c29, rounded_volume c30,
         rounded_volume_umcode c31, uplink_volume_volume c37,
         xfile_charge_amount c39, zero_rated_volume_umcode c42,
         zero_rated_volume_volume c43, zero_rounded_volume_umcode c44,
         zero_rounded_volume_volume c45, remark
    FROM UDR_LT u
   WHERE u.cust_info_customer_id = 34062797
     AND (u.start_time_timestamp + start_time_offset / 3600 / 24) >=
                                          TO_DATE ('14/02/2010', 'dd/mm/yyyy')
     AND (u.start_time_timestamp + start_time_offset / 3600 / 24) <
                                          TO_DATE ('16/03/2010', 'dd/mm/yyyy')

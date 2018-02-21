/* Formatted on 2010/05/26 17:37 (Formatter Plus v4.8.7) */
SELECT   DECODE (cust_info_customer_id,
                 8978058, 'Ahmad',
                 20569646, 'Niveen'
                ) NAME,
         TO_CHAR(r.start_time_timestamp, 'DAY') DoW, r.start_time_timestamp,
         DECODE (rounded_volume_umcode,
                 3, TO_CHAR (rounded_volume) || ' SMS',
                 1, TO_CHAR (rounded_volume / 60) || ' Min'
                ) v8,
         r.cust_info_customer_id customer_id, r.cust_info_contract_id co_id,
         SUBSTR (r.o_p_number_address, 3) dial, rated_volume
    FROM UDR_LT r
   WHERE cust_info_customer_id IN (8978058, 20569646)
     AND r.o_p_number_address IN ('20123600673', '20123652809')
ORDER BY 3 DESC

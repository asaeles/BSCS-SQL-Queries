/* Formatted on 6/10/2012 2:11:34 PM (QP5 v5.185.11230.41888) */
SELECT u.start_time_timestamp + u.start_time_offset / 86400,
       u.o_p_number_address, u.s_p_number_address
  FROM udr_lt PARTITION (udr_lt_w22) u
 WHERE     u.entry_date_timestamp + u.entry_date_offset / 86400 >
              '01-06-2012'
       AND u.o_p_number_address = '201227476466';
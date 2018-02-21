/* Formatted on 2012/02/15 23:35 (Formatter Plus v4.8.8) */
SELECT /*+ FIRST_ROWS */
       ca.custcode "Customer Code", dn.dn_num "Dial",
       u.start_time_timestamp + u.start_time_offset / 86400 "Date Time",
       NVL (bg.cfginfo2, NVL (d.translation, sn.des)) "Service",
       u.o_p_normed_num_address "Dialed Number",
       NVL (dzp.translation, zp.des) "Destination",
       NVL (dtt.translation, tt.des) "Peak Off Peak", 'dum' dum,
       u.duration_volume duv, u.duration_umcode duu, u.messages_volume msv,
       u.messages_umcode msu, u.data_volume dav, u.data_volume_umcode dau,
       u.downlink_volume_volume dlvv, u.downlink_volume_umcode dlvu,
       u.uplink_volume_volume upv, u.uplink_volume_umcode upu,
       u.event_volume ev, u.event_umcode eu, u.rated_clicks_volume rcv,
       u.rated_clicks_umcode rcu, u.rated_volume rv, u.rated_volume_umcode ru,
       u.rounded_volume rov, u.rounded_volume_umcode rou,
       u.rated_flat_amount - NVL (b.free_charge_amount, 0) "Charge"
  FROM customer_all ca,
       contract_all co,
       contr_services_cap csc,
       directory_number dn,
       udr_lt@bscs_to_rtx_link u,
       udr_lt@bscs_to_rtx_link b,
       mpusntab sn,
       nls_dict d,
       bghconfig bg,
       mpuzptab zp,
       nls_dict dzp,
       mputttab tt,
       nls_dict dtt
 WHERE co.customer_id = ca.customer_id
   AND csc.co_id = co.co_id
   AND dn.dn_id = csc.dn_id
   AND u.cust_info_customer_id = co.customer_id
   AND u.cust_info_contract_id = co.co_id
   AND b.cust_info_customer_id(+) = u.cust_info_customer_id
   AND b.cust_info_contract_id(+) = u.cust_info_contract_id
   AND b.uds_stream_id(+) = u.uds_stream_id
   AND b.uds_record_id(+) = u.uds_record_id
   AND b.uds_base_part_id(+) = u.uds_base_part_id
   AND b.uds_charge_part_id(+) = u.uds_charge_part_id
   AND b.entry_date_timestamp(+) = u.entry_date_timestamp
   AND sn.sncode = u.tariff_info_sncode
   AND d.key_value(+) = sn.sncode
   AND bg.cfginfo1(+) = sn.shdes
   AND zp.zpcode = u.tariff_info_zpcode
   AND dzp.key_value(+) = zp.zpcode
   AND tt.ttcode = u.tariff_detail_ttcode
   AND dtt.key_value(+) = tt.ttcode
   AND ca.custcode LIKE '4.5437.00.00.100528%'
   --AND ca.paymntresp IS NULL
   AND csc.cs_deactiv_date IS NULL
   AND csc.main_dirnum = 'X'
   AND (u.entry_date_timestamp + u.entry_date_offset / 86400) >= '22-12-2011'
   AND (u.entry_date_timestamp + u.entry_date_offset / 86400) >= '22-01-2012'
   AND u.uds_free_unit_part_id = 0
   AND b.uds_free_unit_part_id(+) = 1
   AND d.lng_id(+) = 1
   AND d.base_tab(+) = 'MPUSNTAB'
   AND bg.cfgcode(+) = 'SERVICES'
   AND dzp.lng_id(+) = 1
   AND dzp.base_tab(+) = 'MPUZPTAB'
   AND dtt.lng_id(+) = 1
   AND dtt.base_tab(+) = 'MPUTTTAB'

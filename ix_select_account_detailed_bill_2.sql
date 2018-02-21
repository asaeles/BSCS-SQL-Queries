SELECT   /*+ FIRST_ROWS */
         ca.custcode "Customer Code", dn.dn_num "Dial",
         u.start_time_timestamp + u.start_time_offset / 86400 "Date Time",
         u.entry_date_timestamp + u.entry_date_offset / 86400 "Entry Date",
         NVL (bg.sndes, NVL (d.translation, sn.des)) "Service",
         u.o_p_number_address "Dialed Number",
         NVL (dzp.translation, zp.des) "Destination",
         NVL (dtt.translation, tt.des) "Peak/Off Peak",
         DECODE (bg.cfginfo6,
                 's', TO_CHAR (  TO_DATE ('00', 'SS')
                               + u.duration_volume / 3600 / 24,
                               'HH24:MI:SS'
                              ),
                 'SMS-T', u.messages_volume || ' ' || bg.umdes,
                 'SMS-O', u.messages_volume || ' ' || bg.umdes,
                 'KB', ROUND (u.data_volume / 1024) || ' ' || bg.umdes,
                 'Event', NVL (u.event_volume, 1) || ' ' || bg.umdes,
                 'Action', NVL (u.event_volume, 1) || ' ' || bg.umdes,
                 'VAS', NVL (u.event_volume, 1) || ' ' || bg.umdes,
                 u.duration_volume || ' ' || bg.umdes
                ) "Duration/Volume",
         TO_NUMBER (DECODE (bg.cfginfo6,
                 's', u.rounded_volume/60,
                 'SMS-T', u.rounded_volume,
                 'SMS-O', u.rounded_volume,
                 'KB', u.data_volume,
                 'Event', NVL (u.event_volume, 1),
                 'Action', NVL (u.event_volume, 1),
                 'VAS', NVL (u.event_volume, 1),
                 u.rounded_volume
                )) "Rounded Duration/Volume",
         TRIM (TO_CHAR (ROUND (  u.rated_flat_amount
                               - NVL (b.free_charge_amount, 0),
                               2
                              ),
                        '99999990.00'
                       )
              ) "Charge LE"
--         u.tariff_info_sncode, u.duration_volume duv, u.duration_umcode duu,
--         u.messages_volume msv, u.messages_umcode msu, u.data_volume dav,
--         u.data_volume_umcode dau, u.downlink_volume_volume dlvv,
--         u.downlink_volume_umcode dlvu, u.uplink_volume_volume upv,
--         u.uplink_volume_umcode upu, u.event_volume ev, u.event_umcode eu,
--         u.rated_clicks_volume rcv, u.rated_clicks_umcode rcu,
--         u.rated_volume rv, u.rated_volume_umcode ru, u.rounded_volume rov,
--         u.rounded_volume_umcode rou
    FROM (SELECT ca.*, cc.cclanguage lng_id
            FROM customer_all ca, ccontact_all cc
           WHERE cc.customer_id(+) = ca.customer_id AND cc.ccseq(+) = 1) ca,
         contract_all co,
         contr_services_cap csc,
         directory_number dn,
         udr_lt@bscs_to_rtx_link u,
         udr_lt@bscs_to_rtx_link b,
         (SELECT sn.*, l.lng_id
            FROM mpusntab sn, LANGUAGE l) sn,
         nls_dict d,
         (SELECT bg.*, DECODE (l.lng_id, 1, bg.cfginfo4, 2, bg.cfginfo5) sndes,
                 DECODE (l.lng_id, 1, bg.cfginfo6, 2, bg.cfginfo7) umdes,
                 l.lng_id
            FROM bghconfig bg, LANGUAGE l
           WHERE bg.cfgcode = 'SERVICES') bg,
         (SELECT zp.*, l.lng_id
            FROM mpuzptab zp, LANGUAGE l) zp,
         nls_dict dzp,
         (SELECT tt.*, l.lng_id
            FROM mputttab tt, LANGUAGE l) tt,
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
     AND sn.lng_id = ca.lng_id
     AND d.key_value(+) = sn.sncode
     AND d.lng_id(+) = sn.lng_id
     AND bg.cfginfo1(+) = sn.shdes
     AND bg.lng_id(+) = sn.lng_id
     AND zp.zpcode = u.tariff_info_zpcode
     AND zp.lng_id = ca.lng_id
     AND dzp.key_value(+) = zp.zpcode
     AND dzp.lng_id(+) = zp.lng_id
     AND tt.ttcode = u.tariff_detail_ttcode
     AND tt.lng_id = ca.lng_id
     AND dtt.key_value(+) = tt.ttcode
     AND dtt.lng_id(+) = tt.lng_id
     AND ca.custcode LIKE '4.5437.00.00.100528'
     --AND ca.paymntresp IS NULL
     AND csc.cs_deactiv_date IS NULL
     AND csc.main_dirnum = 'X'
     AND (u.entry_date_timestamp + u.entry_date_offset / 86400) >= TO_DATE('20-DEC-2016 14:00', 'dd-mon-rrrr hh24:mi')
     --AND (u.entry_date_timestamp + u.entry_date_offset / 86400) < '01-APR-2014'
     --AND u.uds_free_unit_part_id = 0
     AND b.uds_free_unit_part_id(+) = 1
     AND d.base_tab(+) = 'MPUSNTAB'
     AND d.tran_col(+) = 'DES'
     AND dzp.base_tab(+) = 'MPUZPTAB'
     AND dzp.tran_col(+) = 'DES'
     AND dtt.base_tab(+) = 'MPUTTTAB'
     AND dtt.tran_col(+) = 'DES'
ORDER BY ca.custcode,
         dn.dn_num,
         u.start_time_timestamp + u.start_time_offset / 86400;
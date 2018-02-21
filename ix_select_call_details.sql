/* Formatted on 1/31/2013 5:52:38 PM (QP5 v5.185.11230.41888) */
  SELECT MONTH, TYPE, SUM (volume)
    FROM (SELECT *
            FROM (  SELECT TRUNC (
                                a.entry_date_timestamp
                              + (a.entry_date_offset / 3600 / 24),
                              'MON')
                              MONTH,
                             a.start_time_timestamp
                           + (a.start_time_offset / 3600 / 24)
						   TIME,
                           DECODE (a.rated_volume_umcode,
                                   1, 'CALL',
                                   3, 'SMS',
                                   NULL, 'DATA')
                              TYPE,
                           DECODE (
                              a.rated_volume_umcode,
                              1, TRUNC (a.rounded_volume / 60, 1),
                              3, a.rounded_volume,
                              NULL, DECODE (a.tariff_info_sncode,
                                            156, 0,
                                            TRUNC (a.data_volume / 1024, 2)))
                              volume,
                           TRUNC (NVL (b.free_rounded_volume_volume, 0) / 60, 1)
                              free,
                           DECODE (
                              a.rated_volume_umcode,
                              1, 'Mins',
                              3, 'Mess',
                              NULL, DECODE (a.tariff_info_sncode,
                                            156, 'KB',
                                            'KB'))
                              units,
                           DECODE (a.rated_volume_umcode,
                                   NULL, a.o_p_normed_num_address,
                                   SUBSTR (a.o_p_normed_num_address, 2))
                              dest,
                           a.rated_flat_amount - NVL (b.free_charge_amount, 0)
                              egp,
                           a.remark,
                           a.duration_volume dv,
                           a.messages_volume mv,
                           a.data_volume dv2,
                           a.rated_volume rav,
                           a.rounded_volume rov,
                           a.xfile_charge_amount xfch,
                           a.o_p_number_address op,
                           a.o_p_normed_num_address opn,
                           a.downlink_volume_volume dlv,
                           a.tariff_info_rpcode rp,
                           a.tariff_info_rpversion rpv,
                           a.tariff_info_sncode sn,
                           a.tariff_info_spcode sp,
                           a.tariff_info_tmcode tm,
                           a.tariff_info_tmversion tmv,
                           a.tariff_info_twcode tw,
                           a.tariff_info_usage_ind usgi,
                           a.tariff_info_zncode zn,
                           a.tariff_info_zpcode zp,
                           b.free_charge_amount,
                           b.free_charge_currency,
                           b.free_charge_gross_ind,
                           b.free_charge_tax,
                           b.free_clicks_umcode,
                           b.free_clicks_volume,
                           b.free_rated_volume_umcode,
                           b.free_rated_volume_volume,
                           b.free_rounded_volume_umcode,
                           b.free_rounded_volume_volume,
                           b.free_units_info_account_key,
                           b.free_units_info_account_origin,
                           b.free_units_info_acc_hist_id,
                           b.free_units_info_chg_red_quota,
                           b.free_units_info_discount_rate,
                           b.free_units_info_fup_seq,
                           b.free_units_info_fu_pack_id,
                           b.free_units_info_part_creator,
                           b.free_units_info_previous_seqno,
                           b.free_units_info_seqno,
                           b.free_units_info_version
                      FROM UDR_LT a, UDR_LT b
                     WHERE     b.cust_info_customer_id(+) =
                                  a.cust_info_customer_id
                           AND b.cust_info_contract_id(+) =
                                  a.cust_info_contract_id
                           AND b.uds_stream_id(+) = a.uds_stream_id
                           AND b.uds_record_id(+) = a.uds_record_id
                           AND b.uds_base_part_id(+) = a.uds_base_part_id
                           AND b.uds_charge_part_id(+) = a.uds_charge_part_id
                           AND b.entry_date_timestamp(+) = a.entry_date_timestamp
                           AND a.uds_free_unit_part_id = 0
                           AND b.uds_free_unit_part_id(+) = 1
                           AND a.cust_info_customer_id = 18107145
                           AND   a.entry_date_timestamp
                               + a.entry_date_offset / 86400 >= '01-APR-2013'
                           AND   a.entry_date_timestamp
                               + a.entry_date_offset / 86400 < '01-MAY-2013'
			ORDER BY a.start_time_timestamp DESC)
           WHERE     egp <> 0
                 AND dest NOT LIKE '012%'
                 AND dest NOT LIKE '018%'
                 AND dest NOT LIKE '0150%')
GROUP BY MONTH, TYPE
ORDER BY 1 DESC, 2;

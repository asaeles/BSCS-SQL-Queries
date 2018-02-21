SELECT u.cust_info_customer_id customer_id, u.cust_info_contract_id co_id,
       u.tariff_info_tmcode tm, tm.des rate_plan, u.tariff_info_rpcode ri,
       u.tariff_info_rpversion riv, ri.des rate_pack, u.start_time_timestamp,
       u.o_p_number_address, u.o_p_normed_num_address, u.rated_volume rav,
       u.rated_volume_umcode ravum, u.rounded_volume rov,
       u.rounded_volume_umcode rovum, u.rated_flat_amount egp
  FROM udr_lt u, rateplan@rtx_to_bscs_link tm, mpuritab@rtx_to_bscs_link ri
 WHERE     tm.tmcode = u.tariff_info_tmcode
       AND ri.ricode = u.tariff_info_rpcode
       AND u.tariff_info_zncode = 1
       AND u.uds_free_unit_part_id = 0
       AND (u.cust_info_customer_id, u.cust_info_contract_id) =
              (SELECT co.customer_id,
                      co.co_id
                 FROM contract_all@rtx_to_bscs_link co
                WHERE co.tmcode = 100 AND co.ch_status = 'a' AND ROWNUM < 2)
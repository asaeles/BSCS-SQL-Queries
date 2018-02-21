/* Formatted on 2009/11/16 13:38 (Formatter Plus v4.8.7) */
SELECT   u.rounded_volume_umcode t, u.rounded_volume v,
         u.rated_flat_amount egp, u.o_p_normed_num_address nrmd,
         u.tariff_info_tmcode tm, u.tariff_info_spcode sp,
         u.tariff_info_gvcode gv, u.tariff_info_zncode zn,
         u.tariff_info_zpcode zp, u.start_time_charge_timestamp TIME,
         u.uds_charge_part_id ID, u.*
    FROM udr_lt_504 u
   WHERE cust_info_customer_id = 43697604 AND o_p_number_address = '201000'
ORDER BY u.start_time_charge_timestamp;


SELECT *
  FROM mpuzntab@bscsdb
 WHERE zncode = 66;

SELECT *
  FROM mpdpttab@bscsdb
 WHERE ddigits = '00201000';

SELECT *
  FROM mputmtab@bscsdb
 WHERE tmcode = 31;

SELECT *
  FROM mpulktmm@bscsdb
 WHERE tmcode = 31 AND spcode = 59 AND sncode = 54;

SELECT *
  FROM mpulkrim@bscsdb
 WHERE ricode = 27 AND vscode = 31 AND zncode = 1429;

SELECT   *
    FROM mpulkgvm@bscsdb
   WHERE digits LIKE '+20_1000'
ORDER BY 1, 2;

SELECT *
  FROM mpusptab@bscsdb
 WHERE spcode = 59;

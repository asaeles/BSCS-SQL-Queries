--DN not found, can be added
SELECT *
  FROM directory_number
 WHERE dn_num = '1299999999';

--Number starts with 99 after the NDC 12
--Check it in the MPDHMTAB with the usual HL 58
SELECT *
  FROM mpdhmtab
 WHERE snhlrid = '99' AND hlcode = 58;

--The HMCODE is 681 but the LB and RB are incorrect
--Only 5 digitis should be 8
UPDATE mpdhmtab
   SET msisdnlb = '00000000', msisdnrb = '99999999'
 WHERE hlcode = 58 AND hmcode = 681;

--Now make sure the HM 681 is defined in the logical
SELECT *
  FROM net_logical_hlr_destination
 WHERE hmcode = 681;

--HM 681 not defined, first get the network destination for
--Mobinil (PL 68) telephony (NP 1) --> 210
SELECT *
  FROM network_destination_table
 WHERE npcode = 1 AND plcode = 68;

--Get any insert statement for the same network destination 210
SELECT *
  FROM net_logical_hlr_destination
 WHERE network_destination_id = 210;

--Insert similar for missing HM 681
INSERT INTO net_logical_hlr_destination (network_destination_id, hmcode, sn_len_max
                                         , sn_len_min)
     VALUES (210, 681, 6,
             6);

--Done
COMMIT;
SELECT /*+ INDEX(CV IDX_NET_ORIGIN_ORIGINAL)
           INDEX(CV IDX_NN_ORIGIN_ORIGINAL)
           INDEX(CV IDX_ORIGIN_ORIGINAL) */
      CV.*
  FROM alcatel.cms_int_view CV
 WHERE origin = (SELECT TO_CHAR (MAX (batch_number)) FROM alcatel.batch_hdr);

SELECT COUNT (1)
  FROM alcatel.cms_int_network
 WHERE status = 99;

UPDATE mdsrrtab
   SET status = 15
 WHERE status IN (1, 11);

SELECT COUNT (1)
  FROM mdsrrtab
 WHERE status IN (15);
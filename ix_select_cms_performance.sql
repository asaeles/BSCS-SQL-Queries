SELECT c1.insertion_date start_time, c2.status_update_date end_time, c2.original_id total,
       ROUND (c2.original_id / ( (c2.status_update_date - c1.insertion_date) * 24 * 3600), 2) cps,
       ROUND (1000000 / (c2.original_id / ( (c2.status_update_date - c1.insertion_date) * 24 * 3600)) / 3600, 2) eta_hrs_1m
  FROM alcatel.cms_int_history c1, alcatel.cms_int_history c2
 WHERE     c1.origin = '86999' AND c2.origin = '86999'
       AND c1.original_id = (SELECT MIN (original_id) FROM alcatel.cms_int_history WHERE origin = '86999')
       AND c2.original_id = (SELECT MAX (original_id) FROM alcatel.cms_int_history WHERE origin = '86999');

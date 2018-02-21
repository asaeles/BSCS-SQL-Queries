  SELECT *
	 FROM mmi
	WHERE action_code = 'NLAPT'
ORDER BY 1 DESC, 2 DESC;

  SELECT (status_update_date - insertion_date) * 24 delta, cih.*
	 FROM alcatel.cms_int_history cih
	WHERE origin = '298933' AND original_id IN (3139)
ORDER BY original_id, status_update_date;

SELECT (ts - insert_date) * 24 delta, rr.*
  FROM alcatel.cms_int_gmd ci, gmd_request_history rr
 WHERE rr.request = gmd_id AND cms_int_id = 1422539098;
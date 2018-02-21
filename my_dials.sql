  SELECT cu.customer_id,
			cu.custcode,
			co.co_id,
			co.co_code,
			tm.des rate_plan,
			dn.dn_num
	 FROM customer_all cu,
			contract_all co,
			rateplan tm,
			contr_services_cap csc,
			directory_number dn
	WHERE 	 co.customer_id = cu.customer_id
			AND tm.tmcode = co.tmcode
			AND csc.co_id = co.co_id
			AND dn.dn_id = csc.dn_id
			AND csc.cs_deactiv_date IS NULL
			AND cu.customer_id IN (34062797,
										  23339736,
										  139221774,
										  138080829,
										  170008444,
										  119585440,
										  18107145)
ORDER BY co.co_activated;
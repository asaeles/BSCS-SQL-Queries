DROP TABLE temp_ash;

CREATE TABLE temp_ash
AS
	  SELECT /*+ PARALLEL(CSM) */
			  csm.tmcode,
				csm.spcode,
				csm.sncode,
				DECODE (
					SUBSTR (
						cu.custcode, 1, 1
					),
					'1', 'P',
					'C'
				)
					typ,
				MAX (co.co_activated) last_activation,
				COUNT (1) cnt
		 FROM contr_serv_max csm, contr_services_cap csc, contract_all co,
				customer_all cu
		WHERE 	 csc.co_id = csm.co_id
				AND csc.sncode = csm.sncode
				AND co.co_id = csm.co_id
				AND cu.customer_id = co.customer_id
				AND SUBSTR (
						 csm.cs_stat_chng, -1
					 ) IN ('a', 's')
				AND csm.tmcode NOT IN (20)
				AND csc.main_dirnum = 'X'
				AND csc.cs_activ_date IS NOT NULL
				AND csc.cs_deactiv_date IS NULL
	GROUP BY csm.tmcode,
				csm.spcode,
				csm.sncode,
				DECODE (
					SUBSTR (
						cu.custcode, 1, 1
					),
					'1', 'P',
					'C'
				);

CREATE TABLE tmcode_type
AS
	  SELECT DISTINCT tmcode, typ, last_activation,
							perc deviation, cnt
		 FROM (SELECT t1.tmcode, CASE WHEN t1.cnt > t2.cnt THEN t1.typ ELSE t2.typ END typ, CASE WHEN t1.last_activation > t2.last_activation THEN t1.last_activation ELSE t2.last_activation END last_activation,
						  CASE WHEN t1.cnt > t2.cnt THEN ROUND (t2.cnt / (t1.cnt + t2.cnt) * 100) ELSE ROUND (t1.cnt / (t1.cnt + t2.cnt) * 100) END perc, t1.cnt + t2.cnt cnt
					FROM temp_ash t1, temp_ash t2
				  WHERE t2.tmcode = t1.tmcode AND t1.typ != t2.typ
				 UNION
				 SELECT t1.tmcode, t1.typ, t1.last_activation,
						  0, t1.cnt
					FROM temp_ash t1
				  WHERE NOT EXISTS
							  (SELECT *
								  FROM temp_ash
								 WHERE tmcode = t1.tmcode AND typ != t1.typ))
	ORDER BY 3 DESC;

  SELECT tmt.tmcode tm, tmt.last_activation, tmt.cnt COUNT,
			tm.des, tm.shdes, tmt.typ TYPE,
			tmt.deviation
	 FROM tmcode_type tmt, rateplan tm
	WHERE tm.tmcode = tmt.tmcode AND tmt.typ = 'C' AND tmt.cnt > 1000
ORDER BY TRUNC (
				tmt.last_activation, 'YYYY'
			),
			tmt.cnt,
			tmt.deviation,
			des;
CREATE TABLE temp_ash

AS
	  SELECT /*+ PARALLEL(CS) */
			  cs.tmcode,
				DECODE (SUBSTR (cu.custcode, 1, 1), '1', 'P', 'C') typ,
				COUNT (1) cnt
		 FROM contr_serv_max cs, contract_all co, customer_all cu
		WHERE 	 co.co_id = cs.co_id
				AND cu.customer_id = co.customer_id
				AND cs.cs_stat_chng LIKE '%a'
				AND sncode = 1
				AND cs.tmcode NOT IN (20, 29, 57)
	GROUP BY cs.tmcode, DECODE (SUBSTR (cu.custcode, 1, 1), '1', 'P', 'C');

CREATE TABLE tmcode_type
AS
	SELECT DISTINCT tmcode, typ, perc, cnt
	FROM (SELECT t1.tmcode,
		  CASE WHEN t1.cnt > t2.cnt THEN t1.typ ELSE t2.typ END typ,
		  CASE
			WHEN t1.cnt > t2.cnt THEN
			 ROUND (t2.cnt / (t1.cnt + t2.cnt) * 100)
			ELSE
			 ROUND (t1.cnt / (t1.cnt + t2.cnt) * 100)
		  END
			perc, t1.cnt + t2.cnt cnt
	  FROM temp_ash t1, temp_ash t2
		WHERE t2.tmcode = t1.tmcode AND t1.typ != t2.typ
	  UNION
	  SELECT t1.tmcode, t1.typ, 0, t1.cnt
	  FROM temp_ash t1
		WHERE NOT EXISTS
			(SELECT *
			 FROM temp_ash
			WHERE tmcode = t1.tmcode AND typ != t1.typ))
 ORDER BY 3 DESC;

  SELECT tmt.tmcode tm,
			tmt.typ TYPE,
			tmt.cnt COUNT,
			tmt.perc,
			tm.des,
			tm.shdes
	 FROM tmcode_type tmt, rateplan tm
	WHERE tm.tmcode = tmt.tmcode
ORDER BY tmt.perc, des;
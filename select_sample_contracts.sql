  SELECT *
	 FROM rateplan
	WHERE tmcode <=
				(SELECT MAX (tmcode)
					FROM rateplan_version
				  WHERE		status = 'W'
						  AND vsdate <
									(SELECT bill_period_end_date
										FROM mpulkixd
									  WHERE billseqno =
												  (SELECT MAX (billseqno)
													  FROM mpulkixd
													 WHERE	  bill_simulation_ind = 'N'
															 AND billing_mode = 'BC')))
ORDER BY 1 DESC;

SELECT *
  FROM contract_all
 WHERE	  tmcode = 187
		 AND ch_status = 'a'
		 AND co_activated <
				  (SELECT bill_period_end_date
					  FROM mpulkixd
					 WHERE billseqno =
								 (SELECT MAX (billseqno)
									 FROM mpulkixd
									WHERE 	 bill_simulation_ind = 'N'
											AND billing_mode = 'BC'));

 --19985
 --112533801

SELECT *
  FROM customer_all
 WHERE customer_id = 13258;

DROP TABLE temp_custs;

CREATE TABLE temp_custs
AS
	SELECT /*+ PARALLEL(CU) */
			customer_id
	  FROM customer_all cu
	 WHERE cu.custcode LIKE '5.71881%' AND cslevel = '40';

SELECT /*+ PARALLEL(CU) */
		COUNT (1)
  FROM temp_custs cu, contract_all co
 WHERE co.customer_id = cu.customer_id AND co.ch_status IN ('a', 's');

SELECT *
  FROM customer_all
 WHERE custcode = '5.71881';

DELETE FROM bc_act_view_custs;

INSERT INTO bc_act_view_custs
	SELECT cu2.customer_id
	  FROM customer_all cu, customer_all cu2
	 WHERE	  cu2.custcode LIKE cu.custcode || '%'
			 AND cu.customer_id IN (19985, 112533801);

COMMIT;

SELECT	 'nohup bch -c '
		 || cu.customer_id
		 || ' -Msim -S'
		 || TO_CHAR (ADD_MONTHS (cu.lbc_date, 1), 'rrrr-mm-dd')
		 || ':00:00:00 &'
			 bch
  FROM customer_all cu
 WHERE customer_id IN (19985, 112533801);
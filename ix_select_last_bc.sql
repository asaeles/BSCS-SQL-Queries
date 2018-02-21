/* Formatted on 2011/03/30 12:34 (Formatter Plus v4.8.7) */
SELECT *
  FROM (SELECT   bd.billcycle bc,
                 DECODE (SIGN (SYSDATE - bch_run_date),
                         1, bch_run_date,
                         ADD_MONTHS (bch_run_date, -1)
                        ) last_bc_date
            FROM BILLCYCLE_DEFINITION bd
           WHERE bd.last_run_date = (SELECT MAX (last_run_date)
                                       FROM BILLCYCLE_DEFINITION)
              OR bd.bch_run_date =
                    (SELECT MAX (bch_run_date)
                       FROM BILLCYCLE_DEFINITION
                      WHERE bch_run_date < SYSDATE
                        AND bch_run_date > ADD_MONTHS (SYSDATE, -1))
        ORDER BY bch_run_date ASC)
 WHERE ROWNUM < 2;

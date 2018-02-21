/* Formatted on 2010/01/12 18:20 (Formatter Plus v4.8.7) */
SELECT   *
    FROM billcycle_definition
   WHERE billcycle IN ('01', '02', '03', '04')
ORDER BY bch_run_date;

--Fix BCH Run Date
UPDATE billcycle_definition
   SET bch_run_date =
          TO_DATE (   DECODE (billcycle,
                              '01', '15',
                              '02', '22',
                              '03', '01',
                              '04', '08'
                             )
                   || TO_CHAR (SYSDATE, 'mmrrrr'),
                   'ddmmrrrr'
                  )
 WHERE billcycle IN ('01', '02', '03', '04');

--Fix Last Run Date
UPDATE billcycle_definition
   SET last_run_date = ADD_MONTHS (bch_run_date, -1)
 WHERE billcycle IN ('01', '02', '03', '04');

--Shift
UPDATE billcycle_definition
   SET bch_run_date = ADD_MONTHS (bch_run_date, 1),
       last_run_date = ADD_MONTHS (last_run_date, 1)
 WHERE billcycle IN ('01', '02', '03', '04')
   AND last_run_date = (SELECT MIN (last_run_date)
                          FROM billcycle_definition
                         WHERE billcycle IN ('01', '02', '03', '04'));

--Reverse Shift
UPDATE billcycle_definition
   SET bch_run_date = ADD_MONTHS (bch_run_date, -1),
       last_run_date = ADD_MONTHS (last_run_date, -1)
 WHERE billcycle IN ('01', '02', '03', '04')
   AND last_run_date = (SELECT MAX (last_run_date)
                          FROM billcycle_definition
                         WHERE billcycle IN ('01', '02', '03', '04'));

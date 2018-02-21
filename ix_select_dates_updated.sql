SELECT    'SELECT '''
       || table_name
       || '.'
       || column_name
       || ''', '
       || column_name
       || ', COUNT(1) FROM '
       || table_name
       || ' WHERE '
       || column_name
       || ' >= ''29-MAY-2014'' GROUP BY '
       || column_name
       || ';'
          select_statement,
       tc.*
  FROM all_tab_columns tc
 WHERE     owner = 'SYSADM'
       AND (table_name LIKE 'MPU%' OR table_name LIKE 'RATE%')
       AND column_name LIKE '%DATE%'
       AND table_name NOT LIKE 'MPURHTAB%'
       AND table_name NOT LIKE 'RATEPLAN_HIST%'
       AND table_name NOT IN ('MPUTMTAB', 'MPULKIXD');
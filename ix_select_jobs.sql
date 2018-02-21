SELECT    TRIM (TO_CHAR (MOD ( (next_date - SYSDATE) * 24, 1), '00'))
       || ':'
       || TRIM (TO_CHAR (MOD ( (next_date - SYSDATE) * 24 * 60, 24), '00'))
       || ':'
       || TRIM (TO_CHAR (MOD ( (next_date - SYSDATE) * 24 * 3600, 60), '00'))
          time_left, j.*
  FROM dba_jobs j
 WHERE job IN (3, 5);
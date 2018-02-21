/* Formatted on 2011/06/01 16:52 (Formatter Plus v4.8.7) */
SELECT    'UPDATE BILLCYCLE_DEFINITION SET bch_run_date = TO_DATE ('''
       || TO_CHAR (bch_run_date, 'MM/DD/YYYY HH24:MI:SS')
       || ''', ''MM/DD/YYYY HH24:MI:SS''), last_run_date = TO_DATE ('''
       || TO_CHAR (last_run_date, 'MM/DD/YYYY HH24:MI:SS')
       || ''', ''MM/DD/YYYY HH24:MI:SS''), valid_from = TO_DATE ('''
       || TO_CHAR (valid_from, 'MM/DD/YYYY HH24:MI:SS')
       || ''', ''MM/DD/YYYY HH24:MI:SS''), last_mod_date = TO_DATE ('''
       || TO_CHAR (last_mod_date, 'MM/DD/YYYY HH24:MI:SS')
       || ''', ''MM/DD/YYYY HH24:MI:SS'') WHERE billcycle = '''
       || billcycle
       || ''';' upd
  FROM BILLCYCLE_DEFINITION;

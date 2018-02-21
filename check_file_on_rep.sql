/* Formatted on 2011/07/27 21:43 (Formatter Plus v4.8.7) */
DECLARE
   f_check   UTL_FILE.FILE_TYPE;
   v_line    VARCHAR2 (3000);
BEGIN
   f_check := UTL_FILE.FOPEN ('/tmp', 'SMS_BULK_Format2', 'r');

   FOR x IN 1 .. 20577
   LOOP
      UTL_FILE.GET_LINE (f_check, v_line);
   END LOOP;

   DBMS_OUTPUT.PUT_LINE (v_line);
END;

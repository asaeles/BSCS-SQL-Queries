/* Formatted on 2011/10/02 21:18 (Formatter Plus v4.8.7) */
DECLARE
   f_input   UTL_FILE.FILE_TYPE;
   v_line    VARCHAR2 (1000);
BEGIN
   f_input := UTL_FILE.FOPEN ('/tmp', 'distribute.log', 'r');

   LOOP
      UTL_FILE.GET_LINE (f_input, v_line);
      DBMS_OUTPUT.PUT_LINE (v_line);
   END LOOP;
EXCEPTION
   WHEN NO_DATA_FOUND
   THEN
      NULL;
END;

SET SERVEROUTPUT ON;
WHENEVER SQLERROR EXIT 1 ROLLBACK;
WHENEVER OSERROR EXIT 2 ROLLBACK;

DECLARE
   v_password   mass_user.password%TYPE;
   v_unlock     VARCHAR2 (200);
BEGIN
   DBMS_OUTPUT.put_line (
      'MASS_USER;PASS;USER_PROFILE;MASS_PROFILE;BATCH_USER');

   FOR v_user IN (SELECT * FROM mass_user)
   LOOP
      v_unlock := v_user.username || ';';
      v_password := v_user.password;

      FOR x IN 1 .. LENGTH (v_password)
      LOOP
         SELECT v_unlock || CHR (ASCII (SUBSTR (v_password, x, 1)) - 3 * x)
           INTO v_unlock
           FROM DUAL;
      END LOOP;

      v_unlock := v_unlock || ';' || v_user.profile;

      SELECT v_unlock || ';' || value_desc
        INTO v_unlock
        FROM mobinil.mobinil_utls_config
       WHERE script_name = 'MASS' AND VALUE = v_user.profile;

      SELECT v_unlock || ';' || username
        INTO v_unlock
        FROM alcatel.batch_process_config
       WHERE process_name = 'MASS_TOOL' AND username = v_user.profile;

      DBMS_OUTPUT.put_line (v_unlock);
   END LOOP;
END;
/

EXIT;


DECLARE
   v_out   VARCHAR2 (16);

   FUNCTION num_to_hexa (in_number IN NUMBER, in_bytes IN NUMBER)
      RETURN VARCHAR2
   AS
      v_remainder   NUMBER;
      v_left        NUMBER        := in_number;
      v_hexa        VARCHAR2 (16);
   BEGIN
      LOOP
         SELECT MOD (v_left, 16)
           INTO v_remainder
           FROM DUAL;

         IF v_remainder > 0
         THEN
            SELECT    DECODE (TO_CHAR (v_remainder),
                              '10', 'A',
                              '11', 'B',
                              '12', 'C',
                              '13', 'D',
                              '14', 'E',
                              '15', 'F',
                              TO_CHAR (v_remainder)
                             )
                   || v_hexa
              INTO v_hexa
              FROM DUAL;

            v_left := FLOOR (v_left / 16);
         ELSE
            EXIT;
         END IF;
      END LOOP;

      RETURN RPAD (v_hexa, in_bytes * 2, 'F');
   END;

   FUNCTION num_to_bcd (in_number IN NUMBER, in_bytes IN NUMBER)
      RETURN VARCHAR2
   AS
      v_number   VARCHAR2 (32) := TO_CHAR (in_number);
      v_bcd      VARCHAR2 (16);
      v_flag     VARCHAR2 (1)  := '1';
   BEGIN
      FOR x IN REVERSE 1 .. LENGTH (v_number)
      LOOP
         IF v_flag = '1'
         THEN
            v_flag := '2';
         ELSE
            v_flag := '1';
            EXIT;
         END IF;

         IF x > 1
         THEN
            v_bcd :=
                  v_bcd
               || CHR (  TO_NUMBER (SUBSTR (v_number, x, 1))
                       * TO_NUMBER (SUBSTR (v_number, x - 1, 1))
                      );
         ELSE
            v_bcd := v_bcd || CHR (TO_NUMBER (SUBSTR (v_number, x, 1)));
         END IF;
      END LOOP;

      RETURN v_bcd;
   END;
BEGIN
   v_out := num_to_hexa (3547982135, 8);
   DBMS_OUTPUT.put_line (v_out);
   v_out := num_to_bcd (3547982135, 8);
   DBMS_OUTPUT.put_line (v_out);
END;

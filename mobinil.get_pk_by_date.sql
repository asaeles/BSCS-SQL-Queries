CREATE OR REPLACE FUNCTION mobinil.get_pk_by_date(
    i_table_name  VARCHAR2,
    i_pk_name     VARCHAR2,
    i_date_name   VARCHAR2,
    i_target_date DATE)
  RETURN INTEGER
AS
  v_pk_max     INTEGER;
  v_pk_1       INTEGER;
  v_pk_2       INTEGER;
  v_date_max   DATE;
  v_date_1     DATE;
  v_date_2     DATE;
  v_ratio      INTEGER;
  v_step       INTEGER;
  v_iterations INTEGER;
BEGIN
  EXECUTE IMMEDIATE 'SELECT MAX(' || i_pk_name || ') FROM ' || i_table_name INTO v_pk_max;
  EXECUTE immediate 'SELECT ' || i_date_name || ' FROM ' || i_table_name || ' WHERE ' || i_pk_name || ' = ' || v_pk_max INTO v_date_max;
  IF (i_target_date > v_date_max) THEN
    RETURN NULL;
  END IF;
--First loop ends after first flip
v_pk_1        := v_pk_max;
v_date_1      := v_date_max;
v_step        := -100;
v_iterations  := 0;
WHILE ((v_step < 0 OR v_step > 1) AND v_iterations < 30)
LOOP
  v_pk_2          := v_pk_1 + v_step;
  v_date_2        := NULL;
  WHILE (v_date_2 IS NULL)
  LOOP
    BEGIN
      EXECUTE immediate 'SELECT ' || i_date_name || ' FROM ' || i_table_name || ' WHERE ' || i_pk_name || ' = ' || v_pk_2 INTO v_date_2;
    EXCEPTION
    WHEN no_data_found THEN
      v_date_2 := NULL;
      v_pk_2   := v_pk_2 + 1;
    END;
  END LOOP;
  IF ((v_date_2 != v_date_1) AND ROUND( (v_pk_2 - v_pk_1) / (v_date_2 - v_date_1)) < v_ratio OR v_iterations < 5) THEN
    v_ratio     := ROUND( (v_pk_2               - v_pk_1) / (v_date_2 - v_date_1));
  END IF;
  v_step    := (i_target_date - v_date_2) * v_ratio;
  IF (v_step = 0) THEN
    v_step  := -1;
  END IF;
  v_pk_1       := v_pk_2;
  v_date_1     := v_date_2;
  v_iterations := v_iterations + 1;
  dbms_output.put_line('v_pk_1: ' || v_pk_1 || ', v_date_1: ' || v_date_1 || ', v_ratio: ' || v_ratio || ', v_step: ' || v_step);
END LOOP;
RETURN v_pk_1;
END;
/

ALTER FUNCTION mobinil.get_pk_by_date COMPILE DEBUG;

EXIT;

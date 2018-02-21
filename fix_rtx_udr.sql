SET SERVEROUTPUT ON
SET FEEDBACK OFF

DECLARE
   v_count NUMBER;
   v_prt_err BOOLEAN;
BEGIN
	v_prt_err := FALSE;
   BEGIN
      SELECT COUNT(1) INTO v_count
      FROM sysadm.udr_lt WHERE ROWNUM < 2;
      dbms_output.put_line('UDR_LT seems OK, no fix needed');
   EXCEPTION
   WHEN OTHERS THEN 
      IF  (SQLCODE = -376) THEN
         v_prt_err := TRUE;
      END IF;
   END;
   IF v_prt_err THEN
      FOR prt IN (
         SELECT * FROM sys.all_tab_partitions
         WHERE TABLE_OWNER = 'SYSADM'
         AND TABLE_NAME = 'UDR_LT'
         ORDER BY partition_position
      ) LOOP
         BEGIN
            EXECUTE IMMEDIATE 'SELECT COUNT(1) FROM sysadm.udr_lt PARTITION (' ||
            prt.partition_name || ') WHERE ROWNUM < 2' INTO v_count;
            dbms_output.put_line(prt.partition_name || ': OK');
         EXCEPTION WHEN OTHERS THEN
            IF  (SQLCODE = -376) THEN
               EXECUTE IMMEDIATE 'CREATE TABLE asaeles AS SELECT * FROM sysadm.udr_lt WHERE ROWNUM < 1';
               EXECUTE IMMEDIATE 'ALTER TABLE udr_lt EXCHANGE PARTITION ' ||
               prt.partition_name || ' WITH TABLE asaeles';
               EXECUTE IMMEDIATE 'ALTER TABLE udr_lt DROP PARTITION ' ||
               prt.partition_name;
               EXECUTE IMMEDIATE 'DROP TABLE asaeles';
               dbms_output.put_line(prt.partition_name || ': DELETED');
            ELSE
               dbms_output.put_line(prt.partition_name || ': HUH! --> ' || SQLCODE);
            END IF;
         END;
      END LOOP;
      EXECUTE IMMEDIATE 'ALTER TABLE udr_lt ADD PARTITION udr_lt_rest
      VALUES LESS THAN (TO_DATE('' 2020-01-01 00:00:00'', ''SYYYY-MM-DD HH24:MI:SS'', ''NLS_CALENDAR=GREGORIAN''))
      PCTFREE 0 PCTUSED 40 INITRANS 40 MAXTRANS 255
      STORAGE (INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
      PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1 BUFFER_POOL DEFAULT)
      TABLESPACE udr_lt_heap_ts_01 NOCOMPRESS';
      dbms_output.put_line('UDR_LT_REST: CREATED');
   END IF;
END;
/

EXIT;

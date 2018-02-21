BEGIN
   EXECUTE IMMEDIATE 'DROP TABLE temp_tm_stats';
EXCEPTION
   WHEN OTHERS
   THEN
      NULL;
END;

CREATE TABLE temp_tm_stats
(
   tm             INTEGER,
   rate_plan      VARCHAR2 (100),
   sp             INTEGER,
   service_pack   VARCHAR2 (100),
   sn             INTEGER,
   service        VARCHAR2 (100),
   pc             VARCHAR2 (1)
);

DECLARE
v_stat varchar2(100);

   v_pc             VARCHAR2 (1);
   v_sn             INTEGER;
   v_service        VARCHAR2 (100);
   v_sp             INTEGER;
   v_service_pack   VARCHAR2 (100);
BEGIN
   FOR tm IN (SELECT * FROM rateplan)
   LOOP
      FOR co
         IN (SELECT co_id, customer_id
               FROM contract_all co
              WHERE tmcode = tm.tmcode AND ch_status = 'a' AND ROWNUM < 100)
      LOOP
      begin
      
         SELECT DECODE (SUBSTR (custcode, 1, 1), '1', 'P', 'C')
           INTO v_pc
           FROM customer_all
          WHERE customer_id = co.customer_id;

         SELECT csc.sncode, sn.des
           INTO v_sn, v_service
           FROM contr_services_cap csc, mpusntab sn
          WHERE     sn.sncode = csc.sncode
                AND csc.co_id = co.co_id
                AND csc.main_dirnum = 'X'
                AND cs_activ_date IS NOT NULL
                AND csc.cs_deactiv_date IS NULL;

         SELECT psp.spcode, sp.des
           INTO v_sp, v_service_pack
           FROM profile_service ps, pr_serv_spcode_hist psp, mpusptab sp
          WHERE     psp.co_id = ps.co_id
                AND psp.sncode = ps.sncode
                AND psp.profile_id = ps.profile_id
                AND psp.histno = ps.spcode_histno
                AND sp.spcode = psp.spcode
                AND ps.co_id = co.co_id
                AND ps.sncode = v_sn;

         INSERT INTO temp_tm_stats
              VALUES (tm.tmcode,
                      tm.des,
                      v_sp,
                      v_service_pack,
                      v_sn,
                      v_service,
                      v_pc);

         COMMIT;
      END LOOP;
   END LOOP;
END;
/

EXIT;
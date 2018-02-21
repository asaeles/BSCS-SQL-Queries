/* Formatted on 2010/11/25 10:33 (Formatter Plus v4.8.7) */
DECLARE
   fileout         UTL_FILE.FILE_TYPE;
   fileerrout      UTL_FILE.FILE_TYPE;
   v_spcode        NUMBER;
   v_from_lines    NUMBER;
   v_to_lines      NUMBER;
   v_price         NUMBER;
   v_seqno         NUMBER;
   v_auto_sp       NUMBER;
   v_auto_co_id    NUMBER;
   v_co_id_susp    NUMBER;
   v_deact_seqno   NUMBER;
   v_expr_date     DATE;
   v_curr_spcode   NUMBER;
   v_date          VARCHAR (50);
   v_date1         VARCHAR (50);
   v_spcode_stat   NUMBER;
--log_file          utl_file.file_type;
--error_file        utl_file.file_type;
   output_dir      VARCHAR2 (200);
   log_dir         VARCHAR2 (200);
   tmp_dir         VARCHAR2 (200);
---------bill cycle
   rc              NUMBER;
   bill            BILLCYCLE_ASSIGNMENT_HISTORY.billcycle%TYPE;
   v_from_date     DATE;
   v_to_date       DATE;
   v_script_cat    alcatel.MOBINIL_REGISTRY.script_name%TYPE;
   z_co_id         CONTRACT_ALL.co_id%TYPE;
   z_seqno         NUMBER;
   seqno           NUMBER;
   v_script_name   alcatel.MOBINIL_REGISTRY.script_name%TYPE;
   v_lockin_sdes   VARCHAR (50);
   v_lockin_sdes   VARCHAR (50);

-------deact seqno
   CURSOR deact_seqno
   IS
      SELECT a.co_id, a.seqno
        FROM alcatel.LOCK_IN_RENEWAL a
       WHERE a.seqno = (SELECT MAX (b.seqno)
                          FROM alcatel.LOCK_IN_RENEWAL b
                         WHERE a.co_id = b.co_id) AND a.status IS NULL;

---------------
   CURSOR c_sp_count
   IS
      SELECT   COUNT (1) sp_count, ap.co_id, deact_seqno.seqno
          FROM PROFILE_SERVICE ap,
               PR_SERV_STATUS_HIST pssht,
               PR_SERV_SPCODE_HIST pssp,
               (SELECT --+ parallel(a,22) leading(a b)
                       a.co_id, a.seqno
                  FROM alcatel.LOCK_IN_RENEWAL a
                 WHERE a.seqno = (SELECT --+ parallel(b,22) use_hash(b)
                                         MAX (b.seqno)
                                    FROM alcatel.LOCK_IN_RENEWAL b
                                   WHERE a.co_id = b.co_id)
                   AND a.status IS NULL) deact_seqno
         WHERE ap.co_id = deact_seqno.co_id
           AND ap.sncode = 1
           AND ap.co_id = pssht.co_id
           AND ap.sncode = pssht.sncode
           AND ap.status_histno = pssht.histno
           AND pssht.status = 'A'
           AND pssp.co_id = ap.co_id
           AND ap.spcode_histno = pssp.histno
           AND ap.sncode = pssp.sncode
           AND pssp.spcode NOT IN (SELECT DISTINCT cfginfo2 sp
                                              FROM alcatel.LOCKIN_CONFIG
                                             WHERE cfgcode = 'MATRIX')
      GROUP BY ap.co_id, deact_seqno.seqno;

   r_sp_count      c_sp_count%ROWTYPE;

-----The activated and migrated contracts to lock_in
   CURSOR lock_in_cust
   IS
      SELECT --+parallel(ASP,8) parallel(ASH,8)
             c.custcode, b.customer_id, cb.billcycle, ap.co_id, amp.tmcode,
             asp.spcode, ash.valid_from_date activated_date,
             ash.valid_from_date cycle_date,
             DECODE (SIGN (ash.valid_from_date - ash.valid_from_date),
                     1, ADD_MONTHS (ash.valid_from_date, 1),
                     ash.valid_from_date
                    ) valid_from_date,
             ADD_MONTHS
                      (DECODE (SIGN (ash.valid_from_date - ash.valid_from_date),
                               1, ADD_MONTHS (ash.valid_from_date, 1),
                               ash.valid_from_date
                              ),
                       m.period
                      ) expiry_date,
             m.period period, SYSDATE entry_date
        FROM BILLCYCLE_ASSIGNMENT_HISTORY cb,
             CUSTOMER_ALL c,
             PROFILE_SERVICE ap,
             MPULKTMB amp,
             PR_SERV_SPCODE_HIST asp,
             PR_SERV_STATUS_HIST ash,
             CONTRACT_ALL b,
             (SELECT DISTINCT cfginfo2 sp, cfginfo6 period
                         FROM alcatel.LOCKIN_CONFIG
                        WHERE cfgcode = 'MATRIX') m
       WHERE ap.sncode = 1
         AND c.customer_id = b.customer_id
         AND cb.customer_id = c.customer_id
         AND b.co_id = ap.co_id
         AND ap.co_id = ash.co_id
         AND ap.sncode = ash.sncode
         AND b.tmcode = amp.tmcode
         AND amp.vscode = (SELECT MAX (vscode)
                             FROM MPULKTMB mm
                            WHERE amp.tmcode = mm.tmcode)
         AND ap.status_histno = ash.histno
         AND ash.status = 'A'
         AND asp.histno = ap.spcode_histno
         AND ap.co_id = asp.co_id
         AND ap.sncode = asp.sncode
         AND m.sp = asp.spcode
         AND amp.tmcode = b.tmcode
         AND amp.vscode = (SELECT MAX (vscode)
                             FROM MPULKTMB
                            WHERE tmcode = amp.tmcode)
         AND cb.billcycle = bill
         AND cb.seqno = (SELECT MAX (bcah.seqno)
                           FROM BILLCYCLE_ASSIGNMENT_HISTORY bcah
                          WHERE bcah.customer_id = cb.customer_id)
         AND asp.spcode IN (SELECT DISTINCT cfginfo2 sp
                                       FROM alcatel.LOCKIN_CONFIG
                                      WHERE cfgcode = 'MATRIX')
         AND NOT EXISTS (
                SELECT 1
                  FROM PROFILE_SERVICE cpp
                 WHERE cpp.co_id = ap.co_id
                   AND cpp.sncode = 68
                   AND cpp.status_histno = ap.status_histno)
         AND ash.valid_from_date >= v_from_date
         AND ash.valid_from_date < v_to_date
      UNION ALL
      SELECT ca.custcode, ca.customer_id, ca.billcycle, ca.co_id, ca.tmcode,
             ca.spcode, cs.valid_from_date activated_date,
             cs.valid_from_date cycle_date,
             DECODE (SIGN (cs.valid_from_date - cs.valid_from_date),
                     1, ADD_MONTHS (cs.valid_from_date, 1),
                     cs.valid_from_date
                    ) valid_from_date,
             ADD_MONTHS
                       (DECODE (SIGN (cs.valid_from_date - cs.valid_from_date),
                                1, ADD_MONTHS (cs.valid_from_date, 1),
                                cs.valid_from_date
                               ),
                        ca.period
                       ) expiry_date,
             ca.period, SYSDATE entry_date
        FROM PR_SERV_STATUS_HIST cs,
             (SELECT c.custcode, b.customer_id, cb.billcycle, ap.co_id,
                     amp.tmcode, asp.spcode, m.period period
                FROM CUSTOMER_ALL c,
                     BILLCYCLE_ASSIGNMENT_HISTORY cb,
                     PR_SERV_STATUS_HIST psshis,
                     PROFILE_SERVICE ap,
                     CONTRACT_ALL b,
                     PR_SERV_SPCODE_HIST asp,
                     MPULKTMB amp,
                     (SELECT DISTINCT cfginfo2 sp, cfginfo6 period
                                 FROM alcatel.LOCKIN_CONFIG
                                WHERE cfgcode = 'MATRIX') m
               WHERE ap.sncode = 1
                 AND c.customer_id = b.customer_id
                 AND cb.customer_id = c.customer_id
                 AND b.co_id = ap.co_id
                 AND cb.billcycle = bill
                 AND cb.seqno = (SELECT MAX (bcah.seqno)
                                   FROM BILLCYCLE_ASSIGNMENT_HISTORY bcah
                                  WHERE bcah.customer_id = cb.customer_id)
                 AND psshis.status = 'A'
                 AND ap.co_id = psshis.co_id
                 AND ap.status_histno = psshis.histno
                 AND ap.sncode = psshis.sncode
                 AND m.sp = asp.spcode
                 AND asp.co_id = ap.co_id
                 AND amp.tmcode = b.tmcode
                 AND amp.vscode = (SELECT MAX (vscode)
                                     FROM MPULKTMB
                                    WHERE tmcode = amp.tmcode)
                 AND asp.histno = ap.spcode_histno
                 AND asp.sncode = ap.sncode
                 AND asp.spcode IN (SELECT DISTINCT cfginfo2 sp
                                               FROM alcatel.LOCKIN_CONFIG
                                              WHERE cfgcode = 'MATRIX')
                 AND EXISTS (
                        SELECT 1
                          FROM PROFILE_SERVICE cp1
                         WHERE cp1.co_id = ap.co_id
                           AND cp1.sncode = 68
                           AND cp1.sncode = ap.sncode
                           AND cp1.status_histno = ap.status_histno)) ca
       WHERE ca.co_id = cs.co_id
         AND sncode = 68
         AND status = 'D'
         AND valid_from_date >= v_from_date
         AND valid_from_date < v_to_date;

-------Auto Renewal
------Auto Renewal
   CURSOR auto_renewal
   IS
      SELECT a.custcode, a.customer_id, a.billcycle, a.co_id, a.tmcode,
             a.spcode, a.activated_date, a.expiry_date AS cycle_date,
             a.expiry_date AS valid_from_date,
             ADD_MONTHS (a.expiry_date, a.period) AS expiry_date, a.period,
             a.seqno + 1 AS seqno
        FROM alcatel.LOCK_IN_RENEWAL a
       WHERE a.seqno = (SELECT MAX (b.seqno)
                          FROM alcatel.LOCK_IN_RENEWAL b
                         WHERE a.co_id = b.co_id)
         AND TRUNC (expiry_date) = v_to_date;

------Auto Renewal SUSP
   CURSOR auto_renewal_susp
   IS
      SELECT a.custcode, a.customer_id, a.billcycle, a.co_id, a.tmcode,
             a.spcode, a.activated_date, a.expiry_date AS cycle_date,
             a.expiry_date AS valid_from_date,
             ADD_MONTHS (a.expiry_date, a.period) AS expiry_date, a.period,
             a.seqno + 1 AS seqno
        FROM alcatel.LOCK_IN_RENEWAL a
       WHERE a.seqno = (SELECT MAX (b.seqno)
                          FROM alcatel.LOCK_IN_RENEWAL b
                         WHERE a.co_id = b.co_id)
         AND a.co_id = v_co_id_susp;

------ loop on the configuration table
   CURSOR lock_in_sps
   IS
      SELECT DISTINCT cfginfo2 spcode, cfginfo4 price, cfginfo3 from_lines,
                      cfginfo7 to_lines
                 FROM alcatel.LOCKIN_CONFIG
                WHERE cfgcode = 'MATRIX'
             ORDER BY 1, 3, 4;

----------get the count or the lock _in contratc per each main account
   CURSOR lock_in_cnt
   IS
      SELECT   spcode, SUBSTR (custcode, 1, SUBSTR (custcode, 1, 1) + 2) code,
               COUNT (co_id) cnt
          FROM alcatel.LOCK_IN_RENEWAL a
         WHERE a.seqno = (SELECT MAX (b.seqno)
                            FROM alcatel.LOCK_IN_RENEWAL b
                           WHERE a.co_id = b.co_id)
           AND a.spcode = v_spcode
      GROUP BY a.spcode, SUBSTR (a.custcode, 1, SUBSTR (a.custcode, 1, 1) + 2)
        HAVING COUNT (a.co_id) BETWEEN v_from_lines AND v_to_lines;

---------get the lock in  inserted rows and update the contr_services table
   CURSOR access_fees_update
   IS
      SELECT a.co_id, a.access_fees, a.seqno
        FROM alcatel.LOCK_IN_RENEWAL a
       WHERE a.seqno = (SELECT MAX (b.seqno)
                          FROM alcatel.LOCK_IN_RENEWAL b
                         WHERE a.co_id = b.co_id)
         AND TRUNC (entry_date) = TRUNC (SYSDATE);
-----
-----**************************************************************BEGIN**************************************************************
BEGIN
   SELECT cfvalue
     INTO tmp_dir
     FROM MPSCFTAB
    WHERE cfcode = 17;

   v_spcode := 0;
   v_from_lines := 0;
   v_to_lines := 0;
   v_seqno := 0;
----
   v_date := TO_CHAR (SYSDATE, 'yyyymmddhhmmssss');
   v_date1 := TO_CHAR (SYSDATE, 'yyyymmddhhmmssss');
   output_dir := tmp_dir || 'ALU_WORK/ANNUAL_BUSINESS';
   log_dir := tmp_dir || 'ALU_LOG/ANNUAL_BUSINESS';
   fileout :=
           UTL_FILE.FOPEN (log_dir, 'LOCKINFileOut_' || v_date || '.log', 'w');
   fileerrout :=
        UTL_FILE.FOPEN (log_dir, 'LOCKINFileErrOut_' || v_date || '.err', 'w');
-------fetch all the new activation and migration to the lock in
   UTL_FILE.PUT_LINE (fileout, 'Starting Time' || '  ' || v_date);
   UTL_FILE.PUT_LINE (fileout,
                      'used codes in the log file and the log table ..'
                     );
   UTL_FILE.PUT_LINE (fileout, '#################################');
   UTL_FILE.PUT_LINE (fileout, 'Deact Seqno ----> DA');
   UTL_FILE.PUT_LINE (fileout, 'No Data Found ----> ND');
   UTL_FILE.PUT_LINE (fileout, 'New Activation  ----> NA');
   UTL_FILE.PUT_LINE (fileout, 'Migration to another Lock  ----> ML');
   UTL_FILE.PUT_LINE (fileout, 'Reactivated on the same lock  ----> RL');
   UTL_FILE.PUT_LINE (fileout, 'Auto Renewal  ----> AR');
   UTL_FILE.PUT_LINE (fileout, '-----------------------------');
   UTL_FILE.PUT_LINE (fileout, 'Starting lock_in_cust loop');
----
----
   v_script_cat := 'lock_in_script';
   v_script_name := v_script_cat;
   rc :=
      mobinil.kernelutils.start_all (v_script_name, '6.1.1', output_dir, TRUE);
   v_from_date := mobinil.kernelutils.get_bc_start_date;
   v_to_date := mobinil.kernelutils.get_bc_end_date;
   bill := mobinil.kernelutils.get_bc_bill;

------
------
----- Deact loop
----- Add exception handler
   FOR r_sp_count IN c_sp_count
   LOOP
      v_spcode_stat := r_sp_count.sp_count;
      z_co_id := r_sp_count.co_id;
      z_seqno := r_sp_count.seqno;

      IF (v_spcode_stat = 1)
      THEN
         UPDATE alcatel.LOCK_IN_RENEWAL
            SET status = 'd'
          WHERE co_id = z_co_id AND seqno = z_seqno;

         UTL_FILE.PUT_LINE (fileout, z_co_id || ' ' || 'DA');

         INSERT INTO alcatel.LOCKIN
              VALUES (z_co_id, 'DA', 'log', 'Deact Seqno', SYSDATE);
      END IF;
   END LOOP;                                        ----- end deact_seqno loop

   FOR k IN lock_in_cust
   LOOP
      BEGIN
         UTL_FILE.PUT_LINE (fileout, 'Processing co_id --->  ' || k.co_id);
-----
         v_curr_spcode := 0;
         v_deact_seqno := 0;

-------
         SELECT NVL (MAX (lr.seqno), 0) + 1
           INTO v_seqno
           FROM alcatel.LOCK_IN_RENEWAL lr
          WHERE lr.co_id = k.co_id;

         SELECT COUNT (1)
           INTO v_deact_seqno
           FROM alcatel.LOCK_IN_RENEWAL lr
          WHERE lr.co_id = k.co_id
            AND status = 'd'
            AND lr.seqno = (SELECT MAX (b.seqno)
                              FROM alcatel.LOCK_IN_RENEWAL b
                             WHERE lr.co_id = b.co_id);

-----
         IF (v_seqno = 1 OR v_deact_seqno = 1)
         THEN          ---No data found for the contract  in the lock-in table
--------
            INSERT INTO alcatel.LOCK_IN_RENEWAL
                        (custcode, customer_id, billcycle, co_id,
                         tmcode, spcode, activated_date, cycle_date,
                         valid_from_date, expiry_date, access_fees, period,
                         entry_date, seqno, curr_cnt, renewal_prcessed,
                         first_sms_prcessed, sec_sms_prcessed, tickler_col
                        )
                 VALUES (k.custcode, k.customer_id, k.billcycle, k.co_id,
                         k.tmcode, k.spcode, k.activated_date, k.cycle_date,
                         k.valid_from_date, k.expiry_date, NULL, k.period,
                         k.entry_date, v_seqno, NULL, 'P',
                         NULL, NULL, 'A'
                        );

            COMMIT;
            UTL_FILE.PUT_LINE (fileout, k.co_id || ' ' || 'NA');

            INSERT INTO alcatel.LOCKIN
                 VALUES (k.co_id, 'NA', 'log', 'New Activation', SYSDATE);
         ----looog  as new lock in activated
         ELSE                                                      --- not new
            SELECT DISTINCT spcode
                       INTO v_curr_spcode
                       FROM alcatel.LOCK_IN_RENEWAL lr
                      WHERE lr.co_id = k.co_id
                        AND lr.seqno = (SELECT MAX (b.seqno)
                                          FROM alcatel.LOCK_IN_RENEWAL b
                                         WHERE lr.co_id = b.co_id);

---
            SELECT DISTINCT a.expiry_date
                       INTO v_expr_date
                       FROM alcatel.LOCK_IN_RENEWAL a
                      WHERE a.co_id = k.co_id
                        AND a.seqno = (SELECT MAX (b.seqno)
                                         FROM alcatel.LOCK_IN_RENEWAL b
                                        WHERE a.co_id = b.co_id);

-----
            IF (k.activated_date <= v_expr_date)
            THEN
               IF (k.spcode <> v_curr_spcode)
               THEN
                  INSERT INTO alcatel.LOCK_IN_RENEWAL
                              (custcode, customer_id, billcycle,
                               co_id, tmcode, spcode,
                               activated_date, cycle_date,
                               valid_from_date, expiry_date, access_fees,
                               period, entry_date, seqno, curr_cnt,
                               renewal_prcessed, first_sms_prcessed,
                               sec_sms_prcessed, tickler_col
                              )
                       VALUES (k.custcode, k.customer_id, k.billcycle,
                               k.co_id, k.tmcode, k.spcode,
                               k.activated_date, k.cycle_date,
                               k.valid_from_date, k.expiry_date, NULL,
                               k.period, k.entry_date, v_seqno, NULL,
                               'P', NULL,
                               NULL, 'R'
                              );

                  COMMIT;
                  UTL_FILE.PUT_LINE (fileout, k.co_id || ' ' || 'ML');

                  INSERT INTO alcatel.LOCKIN
                       VALUES (k.co_id, 'ML', 'log',
                               'Migrated to another lock', SYSDATE);
               ----looog  as  migrated  to another lock in with in the  old lock in duration
               ELSE
                  UTL_FILE.PUT_LINE (fileout, k.co_id || ' ' || 'RL');

                  INSERT INTO alcatel.LOCKIN
                       VALUES (k.co_id, 'RL', 'log',
                               'Reactivated on the same lock', SYSDATE);
               ----looog  as  reactivated on the  same lock in duration.
               END IF;
            ELSE
--- k.ACTIVATED_DATE > v_expr_date
---- take his activation date or the expiry date (waiting for the business to answer)
               BEGIN
                  v_co_id_susp := k.co_id;

                  FOR s IN auto_renewal_susp
                  LOOP
                     INSERT INTO alcatel.LOCK_IN_RENEWAL
                                 (custcode, customer_id, billcycle,
                                  co_id, tmcode, spcode,
                                  activated_date, cycle_date,
                                  valid_from_date, expiry_date, access_fees,
                                  period, entry_date, seqno, curr_cnt,
                                  renewal_prcessed, first_sms_prcessed,
                                  sec_sms_prcessed, tickler_col
                                 )
                          VALUES (s.custcode, s.customer_id, s.billcycle,
                                  s.co_id, s.tmcode, s.spcode,
                                  s.activated_date, s.cycle_date,
                                  s.valid_from_date, s.expiry_date, NULL,
                                  s.period, SYSDATE, s.seqno, NULL,
                                  'P', NULL,
                                  NULL, 'R'
                                 );

                     COMMIT;
                  END LOOP;                                --auto_renewal_susp

                  INSERT INTO alcatel.LOCKIN
                       VALUES (k.co_id, 'RA', 'log',
                               'Reactive on the expiry date', SYSDATE);

                  UTL_FILE.PUT_LINE (fileout,
                                        'k.ACTIVATED_DATE '
                                     || k.activated_date
                                     || ' > v_expr_date '
                                     || v_expr_date
                                     || 'for co_id'
                                     || k.co_id
                                    );
               EXCEPTION
                  WHEN OTHERS
                  THEN
                     BEGIN
                        UTL_FILE.PUT_LINE (fileerrout,
                                              k.co_id
                                           || '  auto_renewal_susp '
                                           || SQLERRM
                                          );

                        INSERT INTO alcatel.LOCKIN
                             VALUES (k.co_id, 'AR', 'Err',
                                     'Error auto_renewal_suspt loop ',
                                     SYSDATE);
                     END;
               END;
            END IF;
         END IF;
      EXCEPTION
         WHEN OTHERS
         THEN
            BEGIN
               UTL_FILE.PUT_LINE (fileerrout,
                                  k.co_id || '  lock_in_cust  ' || SQLERRM
                                 );

               INSERT INTO alcatel.LOCKIN
                    VALUES (k.co_id, 'ND', 'Err', 'Error lock_in_cust loop ',
                            SYSDATE);
            END;
      END;
   END LOOP;                                         --- end lock_in_cust loop

   UTL_FILE.PUT_LINE (fileout, 'End lock_in_cust loop');
   UTL_FILE.PUT_LINE (fileout, 'Starting auto_renewal loop');

----auto renewal contracts
   FOR m IN auto_renewal
   LOOP
      BEGIN
         SELECT spcode
           INTO v_auto_sp
           FROM PR_SERV_SPCODE_HIST apssh,
                PR_SERV_STATUS_HIST pserv,
                PROFILE_SERVICE ps
          WHERE ps.co_id = m.co_id
            AND ps.co_id = apssh.co_id
            AND ps.spcode_histno = apssh.histno
            AND ps.sncode = apssh.sncode
            AND ps.sncode = 1
            AND pserv.status = 'A'
            AND ps.status_histno = pserv.histno
            AND ps.co_id = pserv.co_id
            AND ps.sncode = pserv.sncode
            AND NOT EXISTS (
                   SELECT 1
                     FROM PROFILE_SERVICE cp, PR_SERV_STATUS_HIST prhist
                    WHERE cp.co_id = ps.co_id
                      AND cp.sncode = 68
                      AND cp.status_histno = prhist.histno
                      AND prhist.status = 'A'
                      AND cp.co_id = prhist.co_id
                      AND cp.sncode = prhist.sncode);

-------
         v_auto_co_id := m.co_id;

         IF (v_auto_sp = m.spcode)
         THEN
            UTL_FILE.PUT_LINE (fileout,
                               'Proccessing Contract ----> ' || m.co_id
                              );

            BEGIN
               INSERT INTO alcatel.LOCK_IN_RENEWAL
                           (custcode, customer_id, billcycle, co_id,
                            tmcode, spcode, activated_date,
                            cycle_date, valid_from_date, expiry_date,
                            access_fees, period, entry_date, seqno,
                            curr_cnt, renewal_prcessed, first_sms_prcessed,
                            sec_sms_prcessed, tickler_col
                           )
                    VALUES (m.custcode, m.customer_id, m.billcycle, m.co_id,
                            m.tmcode, m.spcode, m.activated_date,
                            m.cycle_date, m.valid_from_date, m.expiry_date,
                            NULL, m.period, SYSDATE, m.seqno,
                            NULL, 'P', NULL,
                            NULL, 'R'
                           );

               COMMIT;
               UTL_FILE.PUT_LINE (fileout, m.co_id || ' ' || 'AR');

               INSERT INTO alcatel.LOCKIN
                    VALUES (m.co_id, 'AR', 'log', 'Auto Renewal', SYSDATE);
            --------looog  as auto  renewal
            EXCEPTION
               WHEN OTHERS
               THEN
                  BEGIN
                     UTL_FILE.PUT_LINE (fileerrout,
                                        m.co_id || '  auto_renewal  '
                                        || SQLERRM
                                       );

                     INSERT INTO alcatel.LOCKIN
                          VALUES (m.co_id, 'AR', 'Err',
                                  'Error auto_renewal loop ', SYSDATE);
                  END;
            END;
         END IF;
      EXCEPTION
         WHEN OTHERS
         THEN
            BEGIN
               UTL_FILE.PUT_LINE (fileerrout,
                                     m.co_id
                                  || ' '
                                  || 'auto renewal  loop  '
                                  || SQLERRM
                                 );

               INSERT INTO alcatel.LOCKIN
                    VALUES (m.co_id, 'AR', 'Err', 'Error auto renewal loop ',
                            SYSDATE);
            END;
      END;
   END LOOP;                                     ---- end   auto_renewal  loop

   UTL_FILE.PUT_LINE (fileout, 'End auto renewal loop');
-----
----update the access fees  and count
   UTL_FILE.PUT_LINE (fileout, 'Starting lock_in_sps loop');

   FOR i IN lock_in_sps
   LOOP
      BEGIN
         v_spcode := TO_NUMBER (i.spcode);
         v_from_lines := TO_NUMBER (i.from_lines);
         v_to_lines := TO_NUMBER (i.to_lines);
         v_price := i.price;
         UTL_FILE.PUT_LINE (fileout, 'Starting lock_in_cnt loop' || v_spcode);

         FOR j IN lock_in_cnt
         LOOP
            BEGIN
               UPDATE alcatel.LOCK_IN_RENEWAL b
                  SET b.access_fees = v_price,
                      b.curr_cnt = j.cnt
                WHERE SUBSTR (b.custcode, 1, SUBSTR (b.custcode, 1, 1) + 2) =
                                                                        j.code
                  AND b.seqno = (SELECT MAX (a.seqno)
                                   FROM alcatel.LOCK_IN_RENEWAL a
                                  WHERE a.co_id = b.co_id)
                  AND renewal_prcessed = 'P'
                  AND b.spcode = v_spcode;

               COMMIT;
---
               UTL_FILE.PUT_LINE (fileout,
                                  'Updated lock_in_renewal' || j.code);
            EXCEPTION
               WHEN OTHERS
               THEN
                  BEGIN
                     UTL_FILE.PUT_LINE (fileerrout,
                                        'lock_in_cnt loop' || '  ' || SQLERRM
                                       );
                  --  insert into alcatel.lockin values(k.co_id,'AR','Err','Error lock_in_cnt loop ',sysdate);
                  END;
            END;
         END LOOP;                                     ---lock_in_cnt end loop

         UTL_FILE.PUT_LINE (fileout, 'End lock_in_cnt loop');
         COMMIT;
      EXCEPTION
         WHEN OTHERS
         THEN
            UTL_FILE.PUT_LINE (fileerrout,
                               'lock_in_sps loop' || '  ' || SQLERRM
                              );
      END;
   END LOOP;                                          --- lock_in_sps end loop

   UTL_FILE.PUT_LINE (fileout, 'End lock_in_sps loop');
   UTL_FILE.PUT_LINE (fileout, '');
   UTL_FILE.PUT_LINE (fileout, '###########################################');
   UTL_FILE.PUT_LINE (fileout, 'END OF PROGRAMM');
   UTL_FILE.FCLOSE (fileout);
   UTL_FILE.FCLOSE (fileerrout);
   rc := mobinil.kernelutils.end_all;
END;
/

EXIT;

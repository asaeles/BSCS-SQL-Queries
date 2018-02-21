ALTER SESSION SET nls_date_format = 'DD/MM/YYYY';
SET SERVEROUTPUT ON SIZE 999999
WHENEVER SQLERROR EXIT 1 ROLLBACK;
WHENEVER OSERROR EXIT 2 ROLLBACK;

DECLARE
   v_vsdate     DATE := '&&1';
   v_sv_des     VARCHAR2 (60) := 'Gameloft';
   v_sn_des     VARCHAR2 (150) := 'Gameloft';
   v_sn_shdes   VARCHAR2 (5) := 'SNGLF';
   v_srvcode    VARCHAR2 (2) := 'GL';
   v_svlcode    VARCHAR2 (16) := 'GSMT**B*****S' || v_srvcode || '*';
   v_spcode     INTEGER := 156;
   v_acc_sub_glcode VARCHAR2 (30) := '10090160';

   poonsvcode   INTEGER;
   poonsncode   INTEGER;
   v_sncode     INTEGER;
   v_ricode     INTEGER;
   v_upcode     INTEGER;

   CURSOR ratpln
   IS
      SELECT DISTINCT tmcode, vscode
        FROM rateplan_version rv
       WHERE     tmcode = 74
             AND vscode = (SELECT MAX (vscode)
                             FROM rateplan_version
                            WHERE tmcode = rv.tmcode);
BEGIN
   -- Basic Service Configuration
   nextfree.getvalue ('MAX_SVCODE', poonsvcode);

   INSERT INTO sysadm.mpssvtab (svcode,
                                sccode,
                                srvcode,
                                srvind,
                                des,
                                entry_date,
                                modify_date,
                                modify_user,
                                parameter_change_ind,
                                service_change_ind,
                                rec_version,
                                vpn_owner_contract_ind,
                                vpn_user_contract_ind,
                                regular_contract_ind,
                                main_contract_ind,
                                al_contract_ind,
                                profile_flag,
                                exchange_format_id,
                                import_export_flag)
        VALUES (poonsvcode,
                1,
                v_srvcode,
                3,
                v_sv_des,
                v_vsdate,
                v_vsdate,
                'SYSADM',
                'N',
                'N',
                0,
                0,
                0,
                1,
                1,
                0,
                'Y',
                0,
                0);

   INSERT INTO sysadm.mpdoptab (sccode,
                                srvcode,
                                srvind,
                                action,
                                entry_date,
                                modify_date,
                                modify_user,
                                rec_version)
        VALUES (1,
                v_srvcode,
                3,
                1,
                v_vsdate,
                v_vsdate,
                'SYSADM',
                0);

   INSERT INTO sysadm.mpdoptab (sccode,
                                srvcode,
                                srvind,
                                action,
                                entry_date,
                                modify_date,
                                modify_user,
                                rec_version)
        VALUES (1,
                v_srvcode,
                3,
                32,
                v_vsdate,
                v_vsdate,
                'SYSADM',
                0);

   -- Service Configuration
   nextfree.getvalue ('MAX_SNCODE', poonsncode);

   INSERT INTO mpusntab (sncode,
                         des,
                         shdes,
                         snind,
                         rec_version,
                         pde_implicit_ind,
                         print_balance_ind,
                         import_export_flag)
        VALUES (poonsncode,
                v_sn_des,
                v_sn_shdes,
                'Y',
                0,
                'N',
                'N',
                0);

   INSERT INTO mpulknxc (sncode,
                         sccode,
                         snind,
                         rec_version)
        VALUES (poonsncode,
                1,
                'E',
                0);

   INSERT INTO mpulknxv (sncode,
                         s1code,
                         s2code,
                         sscode,
                         svlcode,
                         snmml,
                         associate_dn,
                         quantity_ind,
                         rating_ind,
                         associate_cug,
                         rec_version,
                         balance_type)
        VALUES (poonsncode,
                0,
                0,
                poonsvcode,
                v_svlcode,
                'Y',
                'N',
                'N',
                'Y',
                'N',
                0,
                0);

   INSERT
     INTO srv_chargeable_quantity (sncode, chargeable_quantity_udmcode, chargeable_quantity_def)
   VALUES (poonsncode, 6, NULL);

   INSERT
     INTO srv_chargeable_quantity (sncode, chargeable_quantity_udmcode, chargeable_quantity_def)
   VALUES (poonsncode, 98, 'X');

   INSERT INTO srv_usage_type (sncode, usage_type_id, usage_type_mode)
        VALUES (poonsncode, 4, 'M');

   INSERT INTO srv_usage_type (sncode, usage_type_id, usage_type_mode)
        VALUES (poonsncode, 2, 'O');

   -- Add service to Rated CDRs service package
   INSERT INTO mpulkpxn (spcode, sncode, rec_version)
        VALUES (v_spcode, poonsncode, 1);

   -- Rate plan
   v_sncode := poonsncode;

  SELECT ricode, upcode
     INTO v_ricode, v_upcode
     FROM mpurivsd ri
    WHERE     ricode IN (SELECT ricode
                           FROM mpuritab
                          WHERE des = 'RI: Gameloft')
          AND vscode = (SELECT MAX (vscode)
                          FROM mpurivsd
                         WHERE ricode = ri.ricode);

   -- Rate Plan : Work version
   FOR rpw IN ratpln
   LOOP
      UPDATE rateplan_version
         SET vsdate = v_vsdate, apdate = v_vsdate
       WHERE tmcode = rpw.tmcode AND vscode = 0;

      INSERT INTO mpulktm1 (tmcode,
                            vscode,
                            vsdate,
                            status,
                            spcode,
                            sncode,
                            subscript,
                            accessfee,
                            srvind,
                            proind,
                            advind,
                            susind,
                            accglcode,
                            subglcode,
                            usgglcode,
                            accserv_catcode,
                            accserv_code,
                            accserv_type,
                            usgserv_catcode,
                            usgserv_code,
                            usgserv_type,
                            subserv_catcode,
                            subserv_code,
                            subserv_type,
                            interval_type,
                            interval,
                            subglcode_disc,
                            accglcode_disc,
                            usgglcode_disc,
                            subglcode_mincom,
                            accglcode_mincom,
                            usgglcode_mincom,
                            prm_print_ind,
                            printsubscrind,
                            printaccessind,
                            rec_version,
                            def_payment_cond_usg,
                            access_restricted_ind)
           VALUES (rpw.tmcode,
                   0,
                   v_vsdate,
                   'W',
                   v_spcode,
                   v_sncode,
                   0,
                   0,
                   'P',
                   'N',
                   'P',
                   'N',
                   v_acc_sub_glcode,
                   v_acc_sub_glcode,
                   v_acc_sub_glcode,
                   'Cat 15%',
                   'Code 15%',
                   'ALL',
                   'Cat 15%',
                   'Code 15%',
                   'ALL',
                   'Cat 15%',
                   'Code 15%',
                   'ALL',
                   'M',
                   1,
                   '75100000',
                   '75100000',
                   '75100000',
                   v_acc_sub_glcode,
                   v_acc_sub_glcode,
                   v_acc_sub_glcode,
                   'N',
                   'N',
                   'N',
                   1,
                   1,
                   'N');

      INSERT INTO mpulktm2 (tmcode,
                            vscode,
                            vsdate,
                            status,
                            spcode,
                            sncode,
                            svlcode,
                            rateind,
                            upcode,
                            ricode,
                            rec_version,
                            usage_type_id)
           VALUES (rpw.tmcode,
                   0,
                   v_vsdate,
                   'W',
                   v_spcode,
                   v_sncode,
                   v_svlcode,
                   'Y',
                   v_upcode,
                   v_ricode,
                   1,
                   4);
   END LOOP;

   -- Rate Plan : New Production version
   FOR rpp IN ratpln
   LOOP
      FOR rp IN (SELECT vscode + 1 vscode,
                        v_vsdate vsdate,
                        status,
                        tmrc,
                        v_vsdate apdate,
                        currency,
                        rec_version,
                        tmcode,
                        plcode,
                        import_export_flag,
                        int_sync
                   FROM rateplan_version
                  WHERE tmcode = rpp.tmcode AND vscode = rpp.vscode)
      LOOP
         INSERT INTO rateplan_version
              VALUES (rp.vscode,
                      rp.vsdate,
                      rp.status,
                      rp.tmrc,
                      rp.apdate,
                      rp.currency,
                      rp.rec_version,
                      rp.tmcode,
                      rp.plcode,
                      rp.import_export_flag,
                      rp.int_sync);
      END LOOP;

      FOR tmb IN (SELECT tmcode,
                         vscode + 1 vscode,
                         v_vsdate vsdate,
                         status,
                         spcode,
                         sncode,
                         subscript,
                         accessfee,
                         event,
                         echind,
                         amtind,
                         frqind,
                         srvind,
                         proind,
                         advind,
                         susind,
                         ltcode,
                         plcode,
                         billfreq,
                         freedays,
                         accglcode,
                         subglcode,
                         usgglcode,
                         accjcid,
                         usgjcid,
                         subjcid,
                         csind,
                         clcode,
                         bill_fmt,
                         accserv_catcode,
                         accserv_code,
                         accserv_type,
                         usgserv_catcode,
                         usgserv_code,
                         usgserv_type,
                         subserv_catcode,
                         subserv_code,
                         subserv_type,
                         deposit,
                         interval_type,
                         interval,
                         subglcode_disc,
                         accglcode_disc,
                         usgglcode_disc,
                         subglcode_mincom,
                         accglcode_mincom,
                         usgglcode_mincom,
                         subjcid_disc,
                         accjcid_disc,
                         usgjcid_disc,
                         subjcid_mincom,
                         accjcid_mincom,
                         usgjcid_mincom,
                         pv_combi_id,
                         prm_print_ind,
                         printsubscrind,
                         printaccessind,
                         rec_version,
                         non_expl_serv_prepaid_ind,
                         def_payment_cond_usg,
                         def_time_package_usg,
                         initial_credit,
                         payment_cond_changeable_usg,
                         bop_mode_id,
                         access_restricted_ind
                    FROM mpulktmb
                   WHERE tmcode = rpp.tmcode AND vscode = rpp.vscode)
      LOOP
         INSERT INTO mpulktmb
              VALUES (tmb.tmcode,
                      tmb.vscode,
                      tmb.vsdate,
                      tmb.status,
                      tmb.spcode,
                      tmb.sncode,
                      tmb.subscript,
                      tmb.accessfee,
                      tmb.event,
                      tmb.echind,
                      tmb.amtind,
                      tmb.frqind,
                      tmb.srvind,
                      tmb.proind,
                      tmb.advind,
                      tmb.susind,
                      tmb.ltcode,
                      tmb.plcode,
                      tmb.billfreq,
                      tmb.freedays,
                      tmb.accglcode,
                      tmb.subglcode,
                      tmb.usgglcode,
                      tmb.accjcid,
                      tmb.usgjcid,
                      tmb.subjcid,
                      tmb.csind,
                      tmb.clcode,
                      tmb.bill_fmt,
                      tmb.accserv_catcode,
                      tmb.accserv_code,
                      tmb.accserv_type,
                      tmb.usgserv_catcode,
                      tmb.usgserv_code,
                      tmb.usgserv_type,
                      tmb.subserv_catcode,
                      tmb.subserv_code,
                      tmb.subserv_type,
                      tmb.deposit,
                      tmb.interval_type,
                      tmb.interval,
                      tmb.subglcode_disc,
                      tmb.accglcode_disc,
                      tmb.usgglcode_disc,
                      tmb.subglcode_mincom,
                      tmb.accglcode_mincom,
                      tmb.usgglcode_mincom,
                      tmb.subjcid_disc,
                      tmb.accjcid_disc,
                      tmb.usgjcid_disc,
                      tmb.subjcid_mincom,
                      tmb.accjcid_mincom,
                      tmb.usgjcid_mincom,
                      tmb.pv_combi_id,
                      tmb.prm_print_ind,
                      tmb.printsubscrind,
                      tmb.printaccessind,
                      tmb.rec_version,
                      tmb.non_expl_serv_prepaid_ind,
                      tmb.def_payment_cond_usg,
                      tmb.def_time_package_usg,
                      tmb.initial_credit,
                      tmb.payment_cond_changeable_usg,
                      tmb.bop_mode_id,
                      tmb.access_restricted_ind);
      END LOOP;

      FOR tmm IN (SELECT tmcode,
                         vscode + 1 vscode,
                         v_vsdate vsdate,
                         status,
                         spcode,
                         sncode,
                         svlcode,
                         rateind,
                         upcode,
                         ricode,
                         egcode,
                         rec_version,
                         usage_type_id,
                         cp_pricelist_id,
                         fallback_srv_flag
                    FROM mpulktmm
                   WHERE tmcode = rpp.tmcode AND vscode = rpp.vscode)
      LOOP
         INSERT INTO mpulktmm
              VALUES (tmm.tmcode,
                      tmm.vscode,
                      tmm.vsdate,
                      tmm.status,
                      tmm.spcode,
                      tmm.sncode,
                      tmm.svlcode,
                      tmm.rateind,
                      tmm.upcode,
                      tmm.ricode,
                      tmm.egcode,
                      tmm.rec_version,
                      tmm.usage_type_id,
                      tmm.cp_pricelist_id,
                      tmm.fallback_srv_flag);
      END LOOP;

      FOR ts IN (SELECT tmcode,
                        spcode,
                        tmvscode + 1 tmvscode,
                        service_package_def
                   FROM tariff_service_package
                  WHERE tmcode = rpp.tmcode AND tmvscode = rpp.vscode)
      LOOP
         INSERT INTO tariff_service_package
              VALUES (ts.tmcode,
                      ts.spcode,
                      ts.tmvscode,
                      ts.service_package_def);
      END LOOP;

      INSERT INTO mpulktmb (tmcode,
                            vscode,
                            vsdate,
                            status,
                            spcode,
                            sncode,
                            subscript,
                            accessfee,
                            srvind,
                            proind,
                            advind,
                            susind,
                            accglcode,
                            subglcode,
                            usgglcode,
                            accserv_catcode,
                            accserv_code,
                            accserv_type,
                            usgserv_catcode,
                            usgserv_code,
                            usgserv_type,
                            subserv_catcode,
                            subserv_code,
                            subserv_type,
                            interval_type,
                            interval,
                            subglcode_disc,
                            accglcode_disc,
                            usgglcode_disc,
                            subglcode_mincom,
                            accglcode_mincom,
                            usgglcode_mincom,
                            prm_print_ind,
                            printsubscrind,
                            printaccessind,
                            rec_version,
                            def_payment_cond_usg,
                            access_restricted_ind)
           VALUES (rpp.tmcode,
                   rpp.vscode + 1,
                   v_vsdate,
                   'P',
                   v_spcode,
                   v_sncode,
                   0,
                   0,
                   'P',
                   'N',
                   'P',
                   'N',
                   v_acc_sub_glcode,
                   v_acc_sub_glcode,
                   v_acc_sub_glcode,
                   'Cat 15%',
                   'Code 15%',
                   'ALL',
                   'Cat 15%',
                   'Code 15%',
                   'ALL',
                   'Cat 15%',
                   'Code 15%',
                   'ALL',
                   'M',
                   1,
                   '75100000',
                   '75100000',
                   '75100000',
                   v_acc_sub_glcode,
                   v_acc_sub_glcode,
                   v_acc_sub_glcode,
                   'N',
                   'N',
                   'N',
                   1,
                   1,
                   'N');

      INSERT INTO mpulktmm (tmcode,
                            vscode,
                            vsdate,
                            status,
                            spcode,
                            sncode,
                            svlcode,
                            rateind,
                            upcode,
                            ricode,
                            rec_version,
                            usage_type_id)
           VALUES (rpp.tmcode,
                   rpp.vscode + 1,
                   v_vsdate,
                   'P',
                   v_spcode,
                   v_sncode,
                   v_svlcode,
                   'Y',
                   v_upcode,
                   v_ricode,
                   1,
                   4);
   END LOOP;

   COMMIT;
/*EXCEPTION
   WHEN OTHERS
   THEN
      ROLLBACK;
      DBMS_OUTPUT.put_line ('ERROR :' || SQLERRM);*/
END;
/

EXIT;
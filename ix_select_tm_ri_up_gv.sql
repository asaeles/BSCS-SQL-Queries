/* Formatted on 2011/12/18 08:25 (Formatter Plus v4.8.8) */
SELECT /*+ FIRST_ROWS */ DISTINCT
       --trm.tmcode tm, tm.des || ' - ' || tm.shdes rate_plan,
       --trm.spcode sp, sp.des || ' - ' || sp.shdes service_pack,
       --trm.sncode sn, sn.des || ' - ' || sn.shdes service,
       --utt.usage_type_id ut, utt.usage_type_des usage_type,
       trm.ricode ri, ri.des || ' - ' || ri.shdes rating_pack, sn.shdes serv,
       --trm.upcode UP, UP.des || ' - ' || UP.shdes usage_pack
       --trm.gvcode gv, gv.des || ' - ' || gv.shdes zone_pack
       --trm.twcode tw, tw.des || ' - ' || tw.shdes time_pack
       --trm.egcode eg, eg.des || ' - ' || eg.shdes extended_gl_pack
       --trm.seg || trm.srv || trm.zon gl,
       --eg.des || ';T1.5S0;' || trm.seg || trm.srv || trm.zon || ';' || trm.seg || trm.srv || trm.zon || ';75100000;Base Rating (Air);' || udm.uds_member_des inp
       --trm.zncode zn, zn.des tariff_zone,
       --trm.rate_type_id rt, rt.rate_type_des rate_type,
       --trm.chargeable_quantity_udmcode cq, udm.uds_member_des charg_quant,
       DECODE (trm.sncode,
               1, trm.pf * 1500,
               54, trm.pf * 0,
               NULL
              ) "T1.5S0"
  FROM (SELECT tmm.*, rim.gvcode, rim.twcode, rim.zncode,
               rim.rate_type_id, rim.chargeable_quantity_udmcode,
               DECODE (rim.ricode,
                       49, 0,
                       51, 0,
                       52, 0,
                       113, 0,
                       114, 0,
                       116, 0,
                       120, 0,
                       135, 0,
                       160, 0,
                       163, 0,
                       196, 0,
                       208, 0,
                       211, 0,
                       348, 0,
                       27, 0.5,
                       56, 0.5,
                       109, 0.5,
                       363, 0.5,
                       364, 0.5,
                       365, 0.5,
                       366, 0.5,
					   1
					   ) pf,
               /*DECODE (tmm.tmcode,
                       20, 0,
                       29, 0,
                       57, 0,
                       19, 0.5,
                       30, 0.5,
                       32, 0.5,
                       33, 0.5,
                       34, 0.5,
                       31, DECODE (tmm.spcode,
                                   65, 0,
                                   67, 0,
                                   68, 0,
                                   69, 0,
                                   116, 0,
                                   0.5
                                  ),
                       DECODE (rim.ricode,
                               51, 0,
                               1
                              )
                      ) pf,*/
               DECODE
                  (tmm.spcode,
                   150, '50',
                   151, '50',
                   152, '50',
                   52, '90',
                   158, '90',
                   159, '90',
                   DECODE
                      (INSTR (LOWER (sp.des), 'demo'),
                       0, DECODE
                          (tmm.tmcode,
                           42, '20',
                           45, '20',
                           59, '20',
                           116, '20',
                           118, '20',
                           125, '20',
                           166, '20',
                           29, '30',
                           57, '40',
                           151, '40',
                           DECODE
                              (INSTR (LOWER (tm.des), 'internal'),
                               0, DECODE
                                  (INSTR (LOWER (tm.des),
                                          'employees'),
                                   0, DECODE
                                      (INSTR (LOWER (tm.des), 'corp'),
                                       0, DECODE
                                              (INSTR (LOWER (tm.des),
                                                      'buck'
                                                     ),
                                               0, '10',
                                               '20'
                                              ),
                                       '20'
                                      ),
                                   '70'
                                  ),
                               '70'
                              )
                          ),
                       '80'
                      )
                  ) seg,
               DECODE (tmm.sncode, 1, '010', 54, '020') srv,
               '007' zon
          FROM (SELECT *
                  FROM MPULKTMM tmm
                UNION
                SELECT *
                  FROM MPULKTM2 tm2) tmm,
               (SELECT DISTINCT ricode, gvcode, twcode, zncode,
                                rate_type_id,
                                rpe.chargeable_quantity_udmcode
                           FROM MPULKRIM rimi, RATE_PACK_ELEMENT rpe
                          WHERE rpe.rate_pack_entry_id =
                                              rimi.rate_pack_entry_id
                            AND rimi.vscode =
                                        (SELECT MAX (vscode)
                                           FROM MPURIVSD
                                          WHERE ricode = rimi.ricode)) rim,
                        RATEPLAN tm,
                        MPUSPTAB sp
                  WHERE rim.ricode(+) = tmm.ricode
                    AND tm.tmcode = tmm.tmcode
                    AND sp.spcode = tmm.spcode) trm,
       RATEPLAN tm,
       MPUSPTAB sp,
       MPUSNTAB sn,
       UDC_USAGE_TYPE_TABLE utt,
       MPUEGTAB eg,
       MPURITAB ri,
       MPUUPTAB UP,
       MPUGVTAB gv,
       MPUZNTAB zn,
       MPUTWTAB tw,
       UDC_RATE_TYPE_TABLE rt,
       EGL_PACK_CHARGE_QUANTITY ecq,
       UDS_MEMBER udm
 WHERE tm.tmcode = trm.tmcode
   AND sp.spcode = trm.spcode
   AND sn.sncode = trm.sncode
   AND utt.usage_type_id = trm.usage_type_id
   AND eg.egcode(+) = trm.egcode
   AND ri.ricode(+) = trm.ricode
   AND UP.upcode(+) = trm.upcode
   AND gv.gvcode(+) = trm.gvcode
   AND zn.zncode(+) = trm.zncode
   AND tw.twcode(+) = trm.twcode
   AND rt.rate_type_id(+) = trm.rate_type_id
   AND udm.uds_member_code(+) = trm.chargeable_quantity_udmcode
   AND ecq.egcode(+) = trm.egcode
   AND ecq.chargeable_quantity_udmcode(+) = trm.chargeable_quantity_udmcode
   AND trm.vscode = (SELECT MAX (vscode)
                       FROM RATEPLAN_VERSION
                      WHERE tmcode = trm.tmcode)
   AND trm.tmcode NOT IN (SELECT tmcode
                            FROM RATEPLAN_AVAILABILITY_PERIOD
                           WHERE available_to < TRUNC (SYSDATE)
						     AND tmcode NOT IN (77))
   AND trm.tmcode NOT IN (14, 20, 21)
   --Special Number, Pre Paid, Global Dummy Rateplan
   AND trm.tmcode NOT IN (22, 55, 56, 74)
   --Roaming, CUG Rate Plan, IOT-MIG: Global Roaming, Rated CDRs
   AND trm.vscode <> 0
   AND trm.sncode IN (1, 54)
   --AND trm.pf <> 1
   --AND trm.ricode IN (187, 51)
   --AND trm.rate_type_id <> 1
   --AND trm.twcode = 1
   --AND trm.egcode IS NOT NULL
ORDER BY 2;

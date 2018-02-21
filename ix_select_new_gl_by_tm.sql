/* Formatted on 2011/12/17 09:25 (Formatter Plus v4.8.7) */
SELECT DISTINCT    'INSERT INTO GLACCOUNT_ALL VALUES ('''
                || gl
                || ''', '''
                || REPLACE (gldesc, '&', ''' || ''&'' || ''')
                || ''', ''4'', ''A'', ''MOB'', SYSDATE, SYSDATE, ''X'', ''N'', 0);'
                                                                          ins
           FROM (
SELECT DISTINCT eg.*,
                      /*des || ';C0.5S0.15;' || seg || srv || zon  || ';' || seg || srv || zon || ';75100000;Base Rating (Air);' || cq inp*/
                      seg || srv || zon gl,
                   DECODE (seg,
                           '10', 'Personal',
                           '20', 'Corporate',
                           '30', 'Call' || '&' || 'Control',
                           '40', 'CorporateC' || '&' || 'C',
                           '50', 'AnnualBusiness',
                           '70', 'Internal',
                           '80', 'Demo',
                           '90', 'VIP'
                          )
                || '_'
                || DECODE (sn, 1, 'Voice', 54, 'SMS')
                || '_Election' gldesc
           FROM (
SELECT          /*+ FIRST_ROWS */
       DISTINCT tmm.tmcode tm, tm.des rate_plan, tmm.sncode sn,
                sn.des service, tmm.spcode sp, sp.des service_pack
                --tmm.egcode eg, eg.des,
                --tmm.zncode zn, zn.des tariff_zone,
                --tmm.rate_type_id rt, rt.rate_type_des rate_type,
                --tmm.CHARGEABLE_QUANTITY_UDMCODE cq,
                --udm.uds_member_des cq
                /*, sn.SHDES srv, 0 "T0S0",
                DECODE (tmm.sncode,
                        1, tmm.pf * 1500,
                        54, tmm.pf * 0,
                        NULL
                       ) "T1.5S0",
                DECODE (tmm.sncode,
                        1, tmm.pf * 500,
                        54, tmm.pf * 150,
                        NULL
                       ) "T0.5S0.15"*/
                ,
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
                            DECODE (INSTR (tm.des, 'Internal'),
                                    0, DECODE
                                            (INSTR (tm.des, 'Employees'),
                                             0, DECODE
                                                     (INSTR (tm.des, 'Corp'),
                                                      0, DECODE
                                                              (INSTR (tm.des,
                                                                      'Buck'
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
                DECODE (tmm.sncode, 1, '010', 54, '020') srv, '201' zon
           FROM (SELECT tmm.*, rim.gvcode, rim.twcode, rim.zncode,
                        rim.rate_type_id, rim.chargeable_quantity_udmcode,
                        DECODE (tmm.tmcode,
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
                                1
                               ) pf
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
                                                   WHERE ricode = rimi.ricode)) rim
                  WHERE rim.ricode(+) = tmm.ricode) tmm,
                RATEPLAN tm,
                MPUSPTAB sp,
                MPUSNTAB sn,
                UDC_USAGE_TYPE_TABLE utt,
                MPUEGTAB eg,
                MPURITAB ri,
                MPUUPTAB UP,
                MPUGVTAB gv,
                MPUTWTAB tw,
                MPUZNTAB zn,
                UDC_RATE_TYPE_TABLE rt,
                EGL_PACK_CHARGE_QUANTITY ecq,
                UDS_MEMBER udm
          WHERE tm.tmcode = tmm.tmcode
            AND sp.spcode = tmm.spcode
            AND sn.sncode = tmm.sncode
            AND utt.usage_type_id = tmm.usage_type_id
            AND eg.egcode(+) = tmm.egcode
            AND ri.ricode(+) = tmm.ricode
            AND UP.upcode(+) = tmm.upcode
            AND gv.gvcode(+) = tmm.gvcode
            AND tw.twcode(+) = tmm.twcode
            AND zn.zncode(+) = tmm.zncode
            AND rt.rate_type_id(+) = tmm.rate_type_id
            AND ecq.egcode(+) = tmm.egcode
            AND ecq.chargeable_quantity_udmcode(+) =
                                               tmm.chargeable_quantity_udmcode
            AND udm.uds_member_code(+) = ecq.chargeable_quantity_udmcode
            AND tmm.vscode = (SELECT MAX (vscode)
                                FROM RATEPLAN_VERSION
                               WHERE tmcode = tmm.tmcode)
            AND tmm.tmcode NOT IN (SELECT tmcode
                                     FROM RATEPLAN_AVAILABILITY_PERIOD
                                    WHERE tmcode NOT IN (71))
            AND tmm.tmcode NOT IN (20, 21)
            AND tmm.tmcode NOT IN (22, 55, 56, 74)
            AND tmm.vscode <> 0
            AND tmm.sncode IN (1, 54)
            --AND LOWER (tw.des) NOT LIKE '%intern%'
            --AND tmm.tmcode IN (100, 101, 102, 103)
            --AND tw.twcode NOT IN (7)
            --AND rim.RATE_TYPE_ID <> 1
            AND tmm.egcode IS NOT NULL
) eg   ORDER BY seg, 2, 3, 6
)      ORDER BY 1;

SELECT DISTINCT ricode, gvcode, twcode, rimi.zncode, rate_type_id,
                rpe.chargeable_quantity_udmcode, zn.des
           FROM MPULKRIM rimi, RATE_PACK_ELEMENT rpe, MPUZNTAB zn
          WHERE rpe.rate_pack_entry_id = rimi.rate_pack_entry_id
            AND zn.zncode = rimi.zncode
            AND rimi.rate_type_id <> 1
            AND rimi.vscode = (SELECT MAX (vscode)
                                 FROM MPURIVSD
                                WHERE ricode = rimi.ricode);

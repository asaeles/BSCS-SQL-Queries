/* Formatted on 5/21/2012 11:44:48 AM (QP5 v5.185.11230.41888) */
  SELECT /*+ FIRST_ROWS */
        DISTINCT
         tmb.tmcode tm,
         tm.des || ' - ' || tm.shdes rate_plan,
         /*tmb.spcode sp,
         sp.des || ' - ' || sp.shdes service_pack,*/
         DECODE (
            tmb.spcode,
            /*150, '50',
            151, '50',
            152, '50',
            52, '90',*/
            158, '90',
            159, '90',
            DECODE (
               INSTR (LOWER (sp.des), 'demo'),
               0, DECODE (
                     tmb.tmcode,
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
                     DECODE (
                        INSTR (LOWER (tm.des), 'internal'),
                        0, DECODE (
                              INSTR (LOWER (tm.des), 'employees'),
                              0, DECODE (
                                    INSTR (LOWER (tm.des), 'corp'),
                                    0, DECODE (
                                          INSTR (LOWER (tm.des), 'busin'),
                                          0, DECODE (
                                                INSTR (LOWER (tm.des), 'buck'),
                                                0, '10',
                                                '20'),
                                          '20'),
                                    '20'),
                              '70'),
                        '70')),
               '80')) || '210170'
            glcode
    FROM mpulktmb tmb,
         rateplan tm,
         mpusptab sp,
         mpusntab sn
   WHERE     tm.tmcode = tmb.tmcode
         AND sp.spcode = tmb.spcode
         AND sn.sncode = tmb.sncode
         AND tmb.vscode = (SELECT MAX (vscode)
                             FROM rateplan_version
                            WHERE tmcode = tmb.tmcode)
         AND tmb.tmcode NOT IN
                (SELECT tmcode
                   FROM rateplan_availability_period
                  WHERE available_to < TRUNC (SYSDATE) AND tmcode NOT IN (77))
         AND tmb.tmcode NOT IN (14, 20, 21)
         --Special Number, Pre Paid, Global Dummy Rateplan
         AND tmb.tmcode NOT IN (22, 55, 56, 74)
         --Roaming, CUG Rate Plan, IOT-MIG: Global Roaming, Rated CDRs
         AND tmb.sncode IN (1)
         ORDER BY 2, 3;
         
         

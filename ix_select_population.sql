  SELECT /*+ PARALLEL(CO 8) */
        co.tmcode tm,
         psp.spcode sp,
         ps.sncode sn,
         DECODE (NVL (psh.status, 'D'), 'A', 'sd', co.ch_status) st,
         DECODE (SUBSTR (cu.custcode, 1, 1), '1', 'P', 'C') pc,
         cu.prgcode prg,
         COUNT (1) COUNT
    FROM contract_all co,
         contr_services_cap csc,
         profile_service ps,
         pr_serv_spcode_hist psp,
         profile_service ps2,
         pr_serv_status_hist psh,
         customer_all cu
   WHERE     csc.co_id(+) = co.co_id
         AND ps.co_id = co.co_id
         AND ps.sncode = nvl(csc.sncode, ps.sncode)
         AND psp.co_id = ps.co_id
         AND psp.sncode = ps.sncode
         AND psp.profile_id = ps.profile_id
         AND psp.histno = ps.spcode_histno
         AND ps2.co_id(+) = co.co_id
         AND psh.co_id(+) = ps2.co_id
         AND psh.sncode(+) = ps2.sncode
         AND psh.profile_id(+) = ps2.profile_id
         AND psh.histno(+) = ps2.status_histno
         AND cu.customer_id = co.customer_id
         AND co.ch_status IN ('a', 's')
         AND co.tmcode != 20
         AND csc.main_dirnum(+) = 'X'
         AND csc.cs_deactiv_date IS NULL
         AND ps.profile_id = 0
         AND ps2.sncode(+) = 68
         AND ps2.profile_id(+) = 0
GROUP BY co.tmcode,
         psp.spcode,
         ps.sncode,
         DECODE (NVL (psh.status, 'D'), 'A', 'sd', co.ch_status),
         DECODE (SUBSTR (cu.custcode, 1, 1), '1', 'P', 'C'),
         cu.prgcode
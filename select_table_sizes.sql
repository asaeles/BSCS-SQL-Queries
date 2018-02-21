/* Formatted on 2009/11/09 16:17 (Formatter Plus v4.8.7) */
SELECT   segment_type, segment_name, ROUND (SUM (blocks / 1024), 0) "MB"
    FROM dba_segments
   WHERE owner = UPPER ('SYSADM')
GROUP BY segment_type, segment_name
ORDER BY 3 DESC;


SELECT   owner, segment_type, segment_name,
         ROUND (SUM (blocks / 1024), 0) "MB"
    FROM dba_segments
   WHERE owner NOT IN
            ('SYSADM',
             'SYS',
             'ARENTO',
             'AUDIT',
             'BILLSUP',
             'BSUPPORT',
             'CANDC',
             'CONSULT1',
             'CONSULT2',
             'DWHFINA',
             'IR_TES',
             'IVR',
             'MNPBSCSREP',
             'RECOV',
             'IMSI_LOADER',
             'MOBINIL',
             'SHADOW',
             'TAPSOL',
             'AHAMIN',
             'AKHATTAB',
             'ALCATELDB',
             'BULKVASUSER',
             'LHS1',
             'MIGTEMP',
             'MIGV5V6',
             'SPLEX',
             'OPS$AHSAYED',
             'OPS$ASIBRAHIM',
             'OPS$BSCSV6',
             'OPS$FNESSIM',
             'OPS$HELSHERBINY',
             'OPS$HMAHROUS',
             'OPS$HWAHAB',
             'OPS$MNASER',
             'OPS$NSSALAHELDIN',
             'OPS$ORACLE',
             'OPS$SABBAS',
             'OPS$USER',
             'TOPT',
             'SYSTEM',
             'PERFSTAT'
            )
GROUP BY owner, segment_type, segment_name
ORDER BY 4 DESC;

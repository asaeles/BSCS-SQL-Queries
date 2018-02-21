--Fields: Market, Network Indicator, Rating Indicator, Type,
--        Network Subtype, Free-Units Subtype, Cost-Control Indicator
  SELECT nxv.sncode,
         sn.des service,
         sc.scslprefix mkt,
         sn.snind net,
         nxv.rating_ind rated,
            DECODE (nxv.srv_type, NULL, '(', nxv.srv_type || ': ')
         || DECODE (nxv.srv_type,
                    'V', 'VAS',
                    'C', 'CUG',
                    'G', 'GPRS',
                    'P', 'VPN',
                    NULL, 'other)')
            TYPE,
            NVL (nxc.snind, 'NULL')
         || ': '
         || DECODE (nxc.snind,
                    'U', 'Usage',
                    'E', 'Event',
                    'V', 'Network VAS',
                    'A', 'Absolute Event Charge',
                    'R', 'Relative Event Charge',
                    NULL, 'Operator VAS')
            net_subtype,
            DECODE (nxv.srv_subtype, NULL, '(', nxv.srv_subtype || ': ')
         || DECODE (nxv.srv_subtype,
                    'A', 'Agreement Basic Service',
                    'C', 'COFU',
                    'P', 'POFU',
                    'L', 'POFUL',
                    'T', 'Billed Line Taxation',
                    'B', 'BOP Service',
                    'M', 'Discounting Service',
                    NULL, 'other)')
            fu_subtype,
         DECODE (nxv.cc_package_id, NULL, 'N', 'Y') coc
    FROM mpulknxv nxv, mpusntab sn, mpulknxc nxc, mpdsctab sc
   WHERE     sn.sncode = nxv.sncode
         AND nxc.sncode = nxv.sncode
         AND sc.sccode = nxc.sccode
         AND sc.rate_network_services <> 'N'
--AND nxv.sncode = 123
ORDER BY 1;

-------------------------------Market Parameters-------------------------------

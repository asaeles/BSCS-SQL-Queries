---------------------------------Services Types---------------------------------
--Fields: Market, Network Indicator, Rating Indicator, Type,
--        Network Subtype, Free-Units Subtype, Cost-Control Indicator

  SELECT nxv.sncode,
         nxv.svlcode gsm_pi,
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
         DECODE (nxv.cc_package_id, NULL, 'N', 'Y') coc,
            DECODE (ss.svcode, 0, '', ss.des || ', ')
         || DECODE (s1.svcode, 0, '', s1.des || ', ')
         || DECODE (s2.svcode, 0, '', s2.des)
            basic_services,
         ccp.name
    FROM mpusntab sn,
         mpulknxv nxv,
         coc_costcontrol_packages ccp,
         mpssvtab s1,
         mpssvtab s2,
         mpssvtab ss,
         mpulknxc nxc,
         mpdsctab sc
   WHERE     nxv.sncode(+) = sn.sncode
         AND ccp.cc_package_id(+) = nxv.cc_package_id
         AND s1.svcode(+) = nxv.s1code
         AND s2.svcode(+) = nxv.s2code
         AND ss.svcode(+) = nxv.sscode
         AND nxc.sncode(+) = sn.sncode
         AND sc.sccode(+) = nxc.sccode
--AND sc.rate_network_services <> 'N'
--AND nxv.sncode = 123
ORDER BY 1;

-------------------------------Market Parameters-------------------------------
--Fields: SN Code, Service Description, Parameter Description, Parameter Type,
--        Parameter Order (Number), Parameter ID, Parameter Value Order
--        (Sequence), Parameter Value Description, Parameter Value Value

  SELECT nxv.sncode sn,
         sn.des service,
         mp.prm_des paramter,
         dt.description || ' ' || pt.description TYPE,
         spm.prm_no no,
         mp.parameter_id id,
         mpd.prm_value_seqno sq,
         mpd.prm_value_des description,
         NVL (
            mpd.prm_value_string,
            NVL (TO_CHAR (mpd.prm_value_number),
                 TO_CHAR (mpd.prm_value_date, 'dd/mm/rrrr')))
            VALUE
    FROM mpulknxv nxv,
         mpusntab sn,
         service_parameter spm,
         mkt_parameter mp,
         parameter_area pa,
         parameter_type pt,
         data_type dt,
         mkt_parameter_domain mpd
   WHERE     sn.sncode = nxv.sncode
         AND spm.svcode = nxv.sscode
         AND mp.sccode = spm.sccode
         AND mp.parameter_id = spm.parameter_id
         AND pa.parameter_area_id = mp.parameter_area_id
         AND pt.parameter_type_id = pa.parameter_type_id
         AND dt.data_type_id = pa.data_type_id
         AND mpd.sccode(+) = mp.sccode
         AND mpd.parameter_id(+) = mp.parameter_id
ORDER BY nxv.sncode, spm.prm_no, mpd.prm_value_seqno;

-----------------------------Combination Parameters-----------------------------
--Fields: TM Code, Rate Plan, SP Code, Service Package, SN Code, Service,
--        Parameter Description, Parameter Type, Parameter Order (Number),
--        Parameter ID, Combination Parameter Order (Set ID),
--        Combination Parameter Description, Combination Parameter Value

  SELECT tmb.tmcode tm,
         tm.des rate_plan,
         tmb.spcode sp,
         sp.des service_pack,
         tmb.sncode sn,
         sn.des service,
         mp.prm_des paramter,
         dt.description || ' ' || pt.description TYPE,
         spm.prm_no no,
         mp.parameter_id id,
         pvb.set_id sq,
         pvb.des description,
         NVL (
            TO_CHAR (pvm.prm_value_number),
            NVL (pvm.prm_value_string,
                 TO_CHAR (pvm.prm_value_date, 'dd/mm/rrrr')))
            VALUE,
         pvb.subscript sub,
         pvb.accessfee acc
    FROM mpulktmb tmb,
         mpulknxv nxv,
         rateplan tm,
         mpusptab sp,
         mpusntab sn,
         mpssvtab sv,
         service_parameter spm,
         mkt_parameter mp,
         parameter_area pa,
         parameter_type pt,
         data_type dt,
         mpulkpvb pvb,
         mpulkpvm pvm
   WHERE     nxv.sncode = tmb.sncode
         AND tm.tmcode = tmb.tmcode
         AND sp.spcode = tmb.spcode
         AND sn.sncode = tmb.sncode
         AND sv.svcode = nxv.sscode
         AND spm.svcode = sv.svcode
         AND spm.sccode = sv.sccode
         AND mp.sccode = spm.sccode
         AND mp.parameter_id = spm.parameter_id
         AND pa.parameter_area_id = mp.parameter_area_id
         AND pt.parameter_type_id = pa.parameter_type_id
         AND dt.data_type_id = pa.data_type_id
         AND pvb.pv_combi_id = tmb.pv_combi_id
         AND pvb.vscode = tmb.vscode
         AND pvm.pv_combi_id = pvb.pv_combi_id
         AND pvm.vscode = pvb.vscode
         AND pvm.set_id = pvb.set_id
         AND pvm.sccode = spm.sccode
         AND pvm.parameter_id = spm.parameter_id
         AND tmb.vscode = (SELECT MAX (vscode)
                             FROM rateplan_version
                            WHERE tmcode = tmb.tmcode)
         AND tmb.tmcode NOT IN
                (SELECT tmcode
                   FROM rateplan_availability_period
                  WHERE available_to < TRUNC (SYSDATE) AND tmcode <> 77)
         AND tmb.tmcode NOT IN (SELECT DISTINCT scenario_tmcode
                                  FROM business_scenario_item
                                 WHERE scenario_tmcode IS NOT NULL)
ORDER BY tm.des,
         sp.des,
         sn.des,
         spm.prm_no,
         pvb.set_id;

---------------------------------APN Parameters---------------------------------
--Fields: SN Code, Service, Parameter Description, Parameter Type,
--        Parameter Order (Number), Parameter ID, APN

  SELECT nxv.sncode sn,
         sn.des service,
         mp.prm_des paramter,
         dt.description || ' ' || pt.description TYPE,
         spm.prm_no no,
         mp.parameter_id id,
         dn.dn_num VALUE
    FROM mpulknxv nxv,
         mpusntab sn,
         service_parameter spm,
         mkt_parameter mp,
         parameter_area pa,
         parameter_type pt,
         data_type dt,
         mpulksxa sxa,
         directory_number dn
   WHERE     sn.sncode = nxv.sncode
         AND spm.svcode = nxv.sscode
         AND mp.sccode = spm.sccode
         AND mp.parameter_id = spm.parameter_id
         AND pa.parameter_area_id = mp.parameter_area_id
         AND pt.parameter_type_id = pa.parameter_type_id
         AND dt.data_type_id = pa.data_type_id
         AND sxa.sncode = nxv.sncode
         AND dn.dn_id = sxa.dn_id
         AND mp.parameter_id = 39
         AND dn.dn_num != '*'
         --AND dn.dn_status IN ('f', 'r')
         AND dn.dirnum_npcode IN (SELECT npcode
                                    FROM mpdnptab
                                   WHERE npcode_class = 'A')
ORDER BY nxv.sncode, spm.prm_no, dn.dn_num;

------------------------All Parameters (Mkt, Combi, APN)------------------------

  SELECT spm.tm,
         spm.rate_plan,
         spm.sp,
         spm.service_pack,
         spm.sn,
         spm.service,
         spm.paramter,
         spm.TYPE,
         spm.no,
         spm.parameter_id id,
         DECODE (
            spm.parameter_id,
            39, vxa.dn_num,
            40, (SELECT long_name
                   FROM fu_pack
                  WHERE fu_pack_id = pvm.prm_value_number),
            NVL (
               mpd.prm_value_des,
               NVL (spm.pvb_des, NVL (pvm.prm_value_string, pvm.prm_value_des))))
            description,
         spm.sub,
         spm.acc,
         mpd.*,
         pvm.*,
         vxa.*
    FROM (SELECT tmb.tmcode tm,
                 tm.des rate_plan,
                 tmb.spcode sp,
                 sp.des service_pack,
                 tmb.sncode sn,
                 sn.des service,
                 sv.svcode,
                 mp.prm_des paramter,
                 mp.sccode,
                 dt.description || ' ' || pt.description TYPE,
                 spm.prm_no no,
                 mp.parameter_id,
                 pvb.pv_combi_id,
                 pvb.vscode,
                 pvb.set_id,
                 pvb.des pvb_des,
                 pvb.subscript sub,
                 pvb.accessfee acc
            FROM mpulktmb tmb,
                 rateplan tm,
                 mpusptab sp,
                 mpusntab sn,
                 mpulknxv nxv,
                 mpssvtab sv,
                 service_parameter spm,
                 mkt_parameter mp,
                 parameter_area pa,
                 parameter_type pt,
                 data_type dt,
                 mpulkpvb pvb
           WHERE     tm.tmcode = tmb.tmcode
                 AND sp.spcode = tmb.spcode
                 AND sn.sncode = tmb.sncode
                 AND nxv.sncode = tmb.sncode
                 AND sv.svcode = nxv.sscode
                 AND spm.svcode = sv.svcode
                 AND spm.sccode = sv.sccode
                 AND mp.sccode = spm.sccode
                 AND mp.parameter_id = spm.parameter_id
                 AND pa.parameter_area_id = mp.parameter_area_id
                 AND pt.parameter_type_id = pa.parameter_type_id
                 AND dt.data_type_id = pa.data_type_id
                 AND pvb.pv_combi_id(+) = tmb.pv_combi_id
                 AND pvb.vscode(+) = tmb.vscode
                 AND tmb.vscode = (SELECT MAX (vscode)
                                     FROM rateplan_version
                                    WHERE tmcode = tmb.tmcode)
                 AND tmb.tmcode NOT IN
                        (SELECT tmcode
                           FROM rateplan_availability_period
                          WHERE available_to < TRUNC (SYSDATE) AND tmcode <> 77)
                 AND tmb.tmcode NOT IN (SELECT DISTINCT scenario_tmcode
                                          FROM business_scenario_item
                                         WHERE scenario_tmcode IS NOT NULL)) spm,
         mkt_parameter_domain mpd,
         mpulkpvm pvm,
         (SELECT DISTINCT sxa.sncode,
                          nxv.sscode svcode,
                          spm.parameter_id,
                          dn.dn_num,
                          spm.sccode
            FROM mpulksxa sxa,
                 directory_number dn,
                 mpulknxv nxv,
                 service_parameter spm
           WHERE     dn.dn_id = sxa.dn_id
                 AND nxv.sncode = sxa.sncode
                 AND spm.svcode = nxv.sscode
                 AND spm.parameter_id IN (39)
                 AND dn.dn_num != '*'
                 AND dn.dirnum_npcode IN (SELECT npcode
                                            FROM mpdnptab
                                           WHERE npcode_class = 'A')) vxa
   WHERE     mpd.sccode(+) = spm.sccode
         AND mpd.parameter_id(+) = spm.parameter_id
         AND pvm.pv_combi_id(+) = spm.pv_combi_id
         AND pvm.vscode(+) = spm.vscode
         AND pvm.set_id(+) = spm.set_id
         AND pvm.sccode(+) = spm.sccode
         AND pvm.parameter_id(+) = spm.parameter_id
         AND vxa.svcode(+) = spm.svcode
         AND vxa.sccode(+) = spm.sccode
         AND vxa.parameter_id(+) = spm.parameter_id --replace with zero to exclude APNs
         AND NVL (mpd.prm_value_seqno,
                  NVL (pvm.set_id, NVL (mpd.prm_value_seqno, 0))) =
                NVL (pvm.set_id, NVL (mpd.prm_value_seqno, 0))
ORDER BY spm.rate_plan,
         spm.service_pack,
         spm.service,
         spm.no,
         mpd.prm_value_seqno,
         pvm.set_id;

-------------------------------XML Requests Query-------------------------------
-- This query can be used with any of the above parmaeters queries as a subqery
-- to get XML request fro both CMS and Soap for the parmater part only

SELECT p.*,
          '<parameter><id>'
       || p.id
       || '</id><no>'
       || p.no
       || '</no><value>'
       || p.VALUE
       || '</value><des>'
       || p.description
       || '</des></parameter>'
          cms_xml_req,
          '<chan:srvParameter><man:item><read:PARAMETER_ID>'
       || p.id
       || '</read:PARAMETER_ID><read:PRM_NO>'
       || p.no
       || '</read:PRM_NO><read:listValue><man:item><read:VALUE>'
       || p.VALUE
       || '</read:VALUE><read:VALUE_DES>'
       || p.description
       || '</read:VALUE_DES></man:item></read:listValue></man:item></chan:srvParameter>'
          soap_xml_req
  FROM (SELECT * FROM DUAL) p
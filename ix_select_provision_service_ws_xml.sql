/* Formatted on 29/12/2014 2:37:32 PM (QP5 v5.185.11230.41888) */
  SELECT /*+ FIRST_ROWS ORDERED */
        DISTINCT
         co.co_id,
         cs.sncode,
         tmb.spcode,
         pv.parameter_id,
         pv.prm_no,
         NVL (pv.PRM_VALUE_STRING, TO_CHAR (pv.PRM_VALUE_NUMBER)) VALUE,
         pv.PRM_DESCRIPTION VALUE_DES,
            '            <man:item>
               <prov:DIRNUM></prov:DIRNUM>
               <prov:NPCODE></prov:NPCODE>
               <prov:SNCODE>'
         || cs.sncode
         || '</prov:SNCODE>
               <prov:SPCODE>'
         || tmb.spcode
         || '</prov:SPCODE>
               <prov:serviceParameterList>'
            xml1,
            '                  <man:item>
                     <con:PARAMETER_ID>'
         || pv.parameter_id
         || '</con:PARAMETER_ID>
                     <con:PRM_NO>'
         || pv.prm_no
         || '</con:PRM_NO>
                     <con:VALUE>
                        <man:item>
                           <con:VALUE>'
         || NVL (pv.PRM_VALUE_STRING, TO_CHAR (pv.PRM_VALUE_NUMBER))
         || '</con:VALUE>
                           <con:VALUE_DES>'
         || pv.PRM_DESCRIPTION
         || '</con:VALUE_DES>
                        </man:item>
                     </con:VALUE>
                  </man:item>'
            xml2,
         '               </prov:serviceParameterList>
            </man:item>' xml3
    FROM contract_all co,
         CONTRACT_SERVICE cs,
         parameter_value pv,
         mpulktmb tmb
   WHERE     cs.co_id = co.co_id
         AND pv.co_id(+) = cs.co_id
         AND pv.sncode(+) = cs.sncode
         AND tmb.tmcode = co.tmcode
         AND tmb.sncode = cs.sncode
         AND co.co_id = 60902209
         AND tmb.vscode = (SELECT MAX (vscode)
                             FROM rateplan_version
                            WHERE tmcode = tmb.tmcode)
ORDER BY 1,
         3,
         2,
         5;
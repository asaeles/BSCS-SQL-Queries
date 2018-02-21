/* Formatted on 2012/01/24 15:33 (Formatter Plus v4.8.8) */
DECLARE
   v_tm         rateplan.tmcode%TYPE           := &1;
   v_vsd_char   VARCHAR2 (10)                  := '&2';
   v_vsd        rateplan_version.vsdate%TYPE;
   v_vs         rateplan_version.vscode%TYPE;
BEGIN
   v_vsd := TO_DATE (v_vsd_char, 'dd/mm/rrrr');

   SELECT MAX (vscode)
     INTO v_vs
     FROM rateplan_version
    WHERE tmcode = v_tm;

   UPDATE rateplan_version
      SET vsdate = v_vsd
    WHERE tmcode = v_tm AND vscode IN (0, v_vs);

   UPDATE mpulktm1
      SET vsdate = v_vsd
    WHERE tmcode = v_tm AND vscode IN (0, v_vs);

   UPDATE mpulktm2
      SET vsdate = v_vsd
    WHERE tmcode = v_tm AND vscode IN (0, v_vs);

   UPDATE mpulktmb
      SET vsdate = v_vsd
    WHERE tmcode = v_tm AND vscode IN (0, v_vs);

   UPDATE mpulktmm
      SET vsdate = v_vsd
    WHERE tmcode = v_tm AND vscode IN (0, v_vs);

   COMMIT;
END;
/

/*
SELECT   tc1.table_name, tc1.column_name, tc1.column_id, tc2.column_name,
         tc2.column_id
    FROM dba_tab_columns tc1, dba_tab_columns tc2
   WHERE tc2.owner = tc1.owner
     AND tc2.table_name = tc1.table_name
     AND tc1.owner = 'SYSADM'
     AND tc1.column_name = 'TMCODE'
     AND tc2.column_name = 'VSDATE'
     AND tc1.table_name NOT IN
            ('COMPOSITEPRODUCT',
             'CURR_MPULKTMB',
             'MPUPUTAB',
             'MPUTMTAB',
             'PRICINGELEMENT_VIEW',
             'PRICINGSCHEME_VIEW',
             'SIMPLEPRODUCT_VIEW'
            )
ORDER BY 1;
*/

EXIT;
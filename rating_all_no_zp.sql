/* Subscribtion & Access Fees & Per-minute rates */
SELECT  DISTINCT tmm.tmcode tm, tmm.vscode tmv, tm.des tariff_model,
		 rim.zncode zn, zn.des tariff_zone,
         tmm.sncode sn, sn.des service_name,
         tmm.spcode sp, sp.des service_package,
         rppv.parameter_value_float/1000 EGP
    FROM MPULKTMM tmm,                        --Link between TM&SP&SN&UT&RI&UP 
	                             --(TMCODE,VSCODE,SPCODE,SNCODE,USAGE_TYPE_ID)
         mputmtab tm,                       --Rate Plans Names (TMCODE,VSCODE)
         MPUSPTAB sp,                        --Service Packages Names (SPCODE)
         MPUSNTAB sn,                                --Services Names (SNCODE)
         MPULKTMB tmb,                        --Link between TM&SP&SN and fees
	                                           --(TMCODE,VSCODE,SPCODE,SNCODE)
         UDC_USAGE_TYPE_TABLE uutt,         --Usage Type Names (USAGE_TYPE_ID)
         MPULKRIM rim,      --Link between RI&GV&ZN&TW&TT (RATE_PACK_ENTRY_ID)
		--or (RICODE,VSCODE,GVCODE,ZNCODE,TWCODE,TWVSCODE,TTCODE,RATE_TYPE_ID)
         MPURIVSD riv,                   --Link between RI&UP (RICODE, VSCODE)
         MPUUPTAB up,                          --Usage Packages Names (UPCODE)
         MPURITAB ri,                         --Rating Packages Names (RICODE)
         MPUGVTAB gv,                           --Zone Packages Names (GVCODE)
         MPUZNTAB zn,                             --Tariff Zone Names (ZNCODE)
         MPULKTWM twm,      --Link between TW&TT&TD&TI and full data of TD&TI
		                         --(TWCODE,VSCODE,VSDATE,TTCODE,TICODE,TDCODE)
         MPUTWTAB tw,                           --Time Packages Names (TWCODE)
         MPUTTTAB tt,                             --Tariff Time Names (TTCODE)
         UDC_RATE_TYPE_TABLE urtt,            --Rate Type Names (RATE_TYPE_ID)
         RATE_PACK_ELEMENT rpe,     --Rate Pack Element (RATE_PACK_ELEMENT_ID)
		                 --or (RATE_PACK_ENTRY_ID,CHARGEABLE_QUANTITY_UDMCODE)
         udc_chargeable_quantity_view ucqv,
         RATE_PACK_PARAMETER_VALUE rppv,          --Rate Pack Parameter Value
		            --(RATE_PACK_ELEMENT_ID,PARAMETER_SEQNUM,PARAMETER_ROWNUM)
         CONVERSION_MODULE_PARAMETER cmp
   WHERE tm.tmcode = tmm.tmcode
     AND tm.vscode = tmm.vscode
     AND sp.spcode = tmm.spcode
     AND sn.sncode = tmm.sncode
     AND tmb.tmcode = tmm.tmcode
     AND tmb.vscode = tmm.vscode
     AND tmb.spcode = tmm.spcode
     AND tmb.sncode = tmm.sncode
     AND uutt.usage_type_id = tmm.usage_type_id
     AND rim.ricode = tmm.ricode
     AND riv.ricode = rim.ricode
     AND riv.vscode = rim.vscode
     AND up.upcode = riv.upcode
     AND ri.ricode = rim.ricode
     AND gv.gvcode = rim.gvcode
     AND zn.zncode = rim.zncode
     AND twm.twcode = rim.twcode
     AND twm.vscode = rim.twvscode
     AND twm.ttcode = rim.ttcode
     AND tw.twcode = twm.twcode
     AND tt.ttcode = twm.ttcode
     AND urtt.rate_type_id = rim.rate_type_id
     AND rpe.rate_pack_entry_id = rim.rate_pack_entry_id
     AND ucqv.chargeable_quantity_udmcode = rpe.chargeable_quantity_udmcode
     AND rppv.rate_pack_element_id = rpe.rate_pack_element_id
     AND cmp.conversion_module_id = rpe.conversion_module_id
     AND cmp.parameter_seqnum = rppv.parameter_seqnum
     AND tmm.vscode = (SELECT MAX (vscode)
                         FROM MPULKTMM tmm2
                        WHERE tmm.tmcode = tmm2.tmcode)
     AND rim.vscode = (SELECT MAX (vscode)
                         FROM MPULKRIM rim2
                        WHERE rim.ricode = rim2.ricode)
     AND rpe.conversion_module_id = 1
     AND rppv.parameter_seqnum = 4
     AND rppv.parameter_rownum IN (
            SELECT parameter_rownum
              FROM RATE_PACK_PARAMETER_VALUE
             WHERE rate_pack_element_id = rppv.rate_pack_element_id
               AND parameter_seqnum = 3
               AND parameter_value_float = 999)
     AND (urtt.rate_type_id = 1 OR rppv.parameter_value_float <> 0)
	 AND tmm.sncode IN (1, 54)
     AND tmm.TMCODE = 31
	 AND tmm.spcode IN (65, 66, 67, 68, 69)
	 AND rppv.parameter_value_float <> 0
	 --AND zn.des IN ('ACTEL', 'Thuraya', 'Premium SMS 5' )
	 /*GROUP BY tmm.tmcode, tmm.vscode, tm.des,
         tmm.spcode, sp.des*/
ORDER BY tmm.tmcode,
         tmm.sncode,
         tmm.spcode/*,
         zn.des,
         uutt.usage_type_des,
         rim.ricode,
         riv.upcode,
         rim.gvcode,
         rim.twcode,
         twm.ttcode,
         twm.tdcode,
         twm.ticode,
         urtt.rate_type_des,
         ucqv.chargeable_quantity_des
         /*rppv.parameter_rownum,
         rppv.parameter_seqnum*/


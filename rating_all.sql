/* Subscribtion _ Access Fees _ Per-minute rates */
SELECT  DISTINCT tmm.tmcode tm, tmm.vscode tmv, tm.des tariff_model,
         tmm.spcode sp, sp.des service_package,
         tmm.sncode sn, sn.des service_name,
         tmb.subscript sub_fee, tmb.accessfee acc_fee,
         tmm.usage_type_id ut, uutt.usage_type_des usage_type,
         rim.ricode ri, rim.vscode riv, ri.des rating_package,
		 riv.upcode up, riv.upvscode upv, up.des usage_package,
		 rim.gvcode gv, rim.gvvscode gvv, gv.des zone_package,
		 rim.zncode zn, zn.des tariff_zone,
		 rim.twcode tw, rim.twvscode twv, twm.vsdate twd, tw.des time_package,
		 twm.ttcode tt, tt.des tariff_time,
         twm.tdcode td, twm.tddes type_of_day,
		 twm.ticode ti, twm.tides time_interval,
		 urtt.rate_type_id rt, urtt.rate_type_des rate_type,
		 zocode, zpcode, DIGITS,
         rpe.chargeable_quantity_udmcode udm, ucqv.chargeable_quantity_des charg_quant,
		 /*rppv.parameter_rownum r, rppv.parameter_seqnum s,*/
         DECODE (rpe.conversion_module_id,
                 1, 'Staircase',
                 2, 'Linear',
                 3, 'Offset'
                ) conv_mod,
         cmp.parameter_des parameter, rppv.parameter_value_float/1000 EGP
    FROM mpulktmm tmm,                        --Link between TM_SP_SN_UT_RI_UP 
	                             --(TMCODE,VSCODE,SPCODE,SNCODE,USAGE_TYPE_ID)
         mputmtab tm,                       --Rate Plans Names (TMCODE,VSCODE)
         mpusptab sp,                        --Service Packages Names (SPCODE)
         mpusntab sn,                                --Services Names (SNCODE)
         mpulktmb tmb,                        --Link between TM_SP_SN and fees
	                                           --(TMCODE,VSCODE,SPCODE,SNCODE)
         udc_usage_type_table uutt,         --Usage Type Names (USAGE_TYPE_ID)
         mpulkrim rim,      --Link between RI_GV_ZN_TW_TT (RATE_PACK_ENTRY_ID)
		--or (RICODE,VSCODE,GVCODE,ZNCODE,TWCODE,TWVSCODE,TTCODE,RATE_TYPE_ID)
         mpurivsd riv,                   --Link between RI_UP (RICODE, VSCODE)
         mpuuptab up,                          --Usage Packages Names (UPCODE)
         mpuritab ri,                         --Rating Packages Names (RICODE)
         mpugvtab gv,                           --Zone Packages Names (GVCODE)
         mpuzntab zn,                             --Tariff Zone Names (ZNCODE)
         mpulktwm twm,      --Link between TW_TT_TD_TI and full data of TD_TI
		                         --(TWCODE,VSCODE,VSDATE,TTCODE,TICODE,TDCODE)
         mputwtab tw,                           --Time Packages Names (TWCODE)
         mputttab tt,                             --Tariff Time Names (TTCODE)
         udc_rate_type_table urtt,            --Rate Type Names (RATE_TYPE_ID)
         rate_pack_element rpe,     --Rate Pack Element (RATE_PACK_ELEMENT_ID)
		                 --or (RATE_PACK_ENTRY_ID,CHARGEABLE_QUANTITY_UDMCODE)
         udc_chargeable_quantity_view ucqv,
         rate_pack_parameter_value rppv,          --Rate Pack Parameter Value
		            --(RATE_PACK_ELEMENT_ID,PARAMETER_SEQNUM,PARAMETER_ROWNUM)
         conversion_module_parameter cmp,
		 mpulkgvm gvm
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
                         FROM mpulktmm tmm2
                        WHERE tmm.tmcode = tmm2.tmcode)
     AND rim.vscode = (SELECT MAX (vscode)
                         FROM mpulkrim rim2
                        WHERE rim.ricode = rim2.ricode)
     AND rpe.conversion_module_id = 1
     AND rppv.parameter_seqnum = 4
     AND rppv.parameter_rownum IN (
            SELECT parameter_rownum
              FROM rate_pack_parameter_value
             WHERE rate_pack_element_id = rppv.rate_pack_element_id
               AND parameter_seqnum = 3
               AND parameter_value_float = 999)
     AND (urtt.rate_type_id = 1 OR rppv.parameter_value_float <> 0)
	 AND gvm.gvcode=rim.gvcode
	 AND gvm.vscode=rim.gvvscode
	 AND gvm.zncode=rim.zncode
	 AND tmm.sncode in (1, 54)
     AND tmm.TMCODE = 80
     and zpcode = 610
ORDER BY tmm.tmcode,
         tmm.spcode,
         tmm.sncode,
         uutt.usage_type_des,
         rim.ricode,
         riv.upcode,
         rim.gvcode,
         rim.zncode,
         rim.twcode,
         twm.ttcode,
         twm.tdcode,
         twm.ticode,
         urtt.rate_type_des,
         ucqv.chargeable_quantity_des
         /*rppv.parameter_rownum,
         rppv.parameter_seqnum*/


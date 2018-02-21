  SELECT 'MPUBSTAB.DATE_NEXT', date_next, COUNT (1)
    FROM mpubstab
   WHERE date_next >= '29-MAY-2014'
GROUP BY date_next;

  SELECT 'MPUBSTAB.DATE_LAST', date_last, COUNT (1)
    FROM mpubstab
   WHERE date_last >= '29-MAY-2014'
GROUP BY date_last;

  SELECT 'MPUEGVSD.VSDATE', vsdate, COUNT (1)
    FROM mpuegvsd
   WHERE vsdate >= '29-MAY-2014'
GROUP BY vsdate;

  SELECT 'MPUEGVSD.APDATE', apdate, COUNT (1)
    FROM mpuegvsd
   WHERE apdate >= '29-MAY-2014'
GROUP BY apdate;

  SELECT 'MPUEGVSD.MODDATE', moddate, COUNT (1)
    FROM mpuegvsd
   WHERE moddate >= '29-MAY-2014'
GROUP BY moddate;

  SELECT 'MPUGMTAB.VSDATE', vsdate, COUNT (1)
    FROM mpugmtab
   WHERE vsdate >= '29-MAY-2014'
GROUP BY vsdate;

  SELECT 'MPUGVVSD.VSDATE', vsdate, COUNT (1)
    FROM mpugvvsd
   WHERE vsdate >= '29-MAY-2014'
GROUP BY vsdate;

  SELECT 'MPUGVVSD.APDATE', apdate, COUNT (1)
    FROM mpugvvsd
   WHERE apdate >= '29-MAY-2014'
GROUP BY apdate;

  SELECT 'MPUGVVSD.MODDATE', moddate, COUNT (1)
    FROM mpugvvsd
   WHERE moddate >= '29-MAY-2014'
GROUP BY moddate;

  SELECT 'MPUHOTAB.HODATE', hodate, COUNT (1)
    FROM mpuhotab
   WHERE hodate >= '29-MAY-2014'
GROUP BY hodate;

  SELECT 'MPUIHTAB.CUT_OFF_DATE', cut_off_date, COUNT (1)
    FROM mpuihtab
   WHERE cut_off_date >= '29-MAY-2014'
GROUP BY cut_off_date;

  SELECT 'MPULKEG2.VSDATE', vsdate, COUNT (1)
    FROM mpulkeg2
   WHERE vsdate >= '29-MAY-2014'
GROUP BY vsdate;

  SELECT 'MPULKEGM.VSDATE', vsdate, COUNT (1)
    FROM mpulkegm
   WHERE vsdate >= '29-MAY-2014'
GROUP BY vsdate;

  SELECT 'MPULKGV2.VSDATE', vsdate, COUNT (1)
    FROM mpulkgv2
   WHERE vsdate >= '29-MAY-2014'
GROUP BY vsdate;

  SELECT 'MPULKGVM.VSDATE', vsdate, COUNT (1)
    FROM mpulkgvm
   WHERE vsdate >= '29-MAY-2014'
GROUP BY vsdate;

  SELECT 'MPULKIXD.REF_DATE', ref_date, COUNT (1)
    FROM mpulkixd
   WHERE ref_date >= '29-MAY-2014'
GROUP BY ref_date;

  SELECT 'MPULKIXD.DISPATCH_DATE', dispatch_date, COUNT (1)
    FROM mpulkixd
   WHERE dispatch_date >= '29-MAY-2014'
GROUP BY dispatch_date;

  SELECT 'MPULKIXD.BILL_PERIOD_END_DATE', bill_period_end_date, COUNT (1)
    FROM mpulkixd
   WHERE bill_period_end_date >= '29-MAY-2014'
GROUP BY bill_period_end_date;

  SELECT 'MPULKIXD.DUE_DATE', due_date, COUNT (1)
    FROM mpulkixd
   WHERE due_date >= '29-MAY-2014'
GROUP BY due_date;

  SELECT 'MPULKIXD.ENTRY_DATE', entry_date, COUNT (1)
    FROM mpulkixd
   WHERE entry_date >= '29-MAY-2014'
GROUP BY entry_date;

  SELECT 'MPULKLZB.COLDATE', coldate, COUNT (1)
    FROM mpulklzb
   WHERE coldate >= '29-MAY-2014'
GROUP BY coldate;

  SELECT 'MPULKPV2.PRM_VALUE_DATE', prm_value_date, COUNT (1)
    FROM mpulkpv2
   WHERE prm_value_date >= '29-MAY-2014'
GROUP BY prm_value_date;

  SELECT 'MPULKPVM.PRM_VALUE_DATE', prm_value_date, COUNT (1)
    FROM mpulkpvm
   WHERE prm_value_date >= '29-MAY-2014'
GROUP BY prm_value_date;

  SELECT 'MPULKPVM_BK_20042011.PRM_VALUE_DATE', prm_value_date, COUNT (1)
    FROM mpulkpvm_bk_20042011
   WHERE prm_value_date >= '29-MAY-2014'
GROUP BY prm_value_date;

  SELECT 'MPULKRXA.VDATE_ST', vdate_st, COUNT (1)
    FROM mpulkrxa
   WHERE vdate_st >= '29-MAY-2014'
GROUP BY vdate_st;

  SELECT 'MPULKRXA.VDATE_END', vdate_end, COUNT (1)
    FROM mpulkrxa
   WHERE vdate_end >= '29-MAY-2014'
GROUP BY vdate_end;

  SELECT 'MPULKTM1.VSDATE', vsdate, COUNT (1)
    FROM mpulktm1
   WHERE vsdate >= '29-MAY-2014'
GROUP BY vsdate;

  SELECT 'MPULKTM2.VSDATE', vsdate, COUNT (1)
    FROM mpulktm2
   WHERE vsdate >= '29-MAY-2014'
GROUP BY vsdate;

  SELECT 'MPULKTMB.VSDATE', vsdate, COUNT (1)
    FROM mpulktmb
   WHERE vsdate >= '29-MAY-2014'
GROUP BY vsdate;

  SELECT 'MPULKTMM.VSDATE', vsdate, COUNT (1)
    FROM mpulktmm
   WHERE vsdate >= '29-MAY-2014'
GROUP BY vsdate;

  SELECT 'MPULKTW2.VSDATE', vsdate, COUNT (1)
    FROM mpulktw2
   WHERE vsdate >= '29-MAY-2014'
GROUP BY vsdate;

  SELECT 'MPULKTW2.COLDATE', coldate, COUNT (1)
    FROM mpulktw2
   WHERE coldate >= '29-MAY-2014'
GROUP BY coldate;

  SELECT 'MPULKTWM.VSDATE', vsdate, COUNT (1)
    FROM mpulktwm
   WHERE vsdate >= '29-MAY-2014'
GROUP BY vsdate;

  SELECT 'MPULKTWM.COLDATE', coldate, COUNT (1)
    FROM mpulktwm
   WHERE coldate >= '29-MAY-2014'
GROUP BY coldate;

  SELECT 'MPULKUP2.VSDATE', vsdate, COUNT (1)
    FROM mpulkup2
   WHERE vsdate >= '29-MAY-2014'
GROUP BY vsdate;

  SELECT 'MPULKUPM.VSDATE', vsdate, COUNT (1)
    FROM mpulkupm
   WHERE vsdate >= '29-MAY-2014'
GROUP BY vsdate;

  SELECT 'MPULZTAB.ENTRY_DATE', entry_date, COUNT (1)
    FROM mpulztab
   WHERE entry_date >= '29-MAY-2014'
GROUP BY entry_date;

  SELECT 'MPUNHTAB.VSDATE', vsdate, COUNT (1)
    FROM mpunhtab
   WHERE vsdate >= '29-MAY-2014'
GROUP BY vsdate;

  SELECT 'MPUPFTAB.ENTRY_DATE', entry_date, COUNT (1)
    FROM mpupftab
   WHERE entry_date >= '29-MAY-2014'
GROUP BY entry_date;

  SELECT 'MPUPUTAB.VSDATE', vsdate, COUNT (1)
    FROM mpuputab
   WHERE vsdate >= '29-MAY-2014'
GROUP BY vsdate;

  SELECT 'MPUPUTAB.VSENDDATE', vsenddate, COUNT (1)
    FROM mpuputab
   WHERE vsenddate >= '29-MAY-2014'
GROUP BY vsenddate;

  SELECT 'MPUREGBI.FLDATE', fldate, COUNT (1)
    FROM mpuregbi
   WHERE fldate >= '29-MAY-2014'
GROUP BY fldate;

  SELECT 'MPUREGIC.FLDATE', fldate, COUNT (1)
    FROM mpuregic
   WHERE fldate >= '29-MAY-2014'
GROUP BY fldate;

  SELECT 'MPURIVSD.VSDATE', vsdate, COUNT (1)
    FROM mpurivsd
   WHERE vsdate >= '29-MAY-2014'
GROUP BY vsdate;

  SELECT 'MPURIVSD.APDATE', apdate, COUNT (1)
    FROM mpurivsd
   WHERE apdate >= '29-MAY-2014'
GROUP BY apdate;

  SELECT 'MPURIVSD.MODDATE', moddate, COUNT (1)
    FROM mpurivsd
   WHERE moddate >= '29-MAY-2014'
GROUP BY moddate;

  SELECT 'MPUSHTAB.CUT_OFF_DATE', cut_off_date, COUNT (1)
    FROM mpushtab
   WHERE cut_off_date >= '29-MAY-2014'
GROUP BY cut_off_date;

  SELECT 'MPUTDTAB.COLDATE', coldate, COUNT (1)
    FROM mputdtab
   WHERE coldate >= '29-MAY-2014'
GROUP BY coldate;

  SELECT 'MPUTMTAB.VSDATE', vsdate, COUNT (1)
    FROM mputmtab
   WHERE vsdate >= '29-MAY-2014'
GROUP BY vsdate;

  SELECT 'MPUTMTAB.APDATE', apdate, COUNT (1)
    FROM mputmtab
   WHERE apdate >= '29-MAY-2014'
GROUP BY apdate;

  SELECT 'MPUTRVSD.VSDATE', vsdate, COUNT (1)
    FROM mputrvsd
   WHERE vsdate >= '29-MAY-2014'
GROUP BY vsdate;

  SELECT 'MPUTWVSD.VSDATE', vsdate, COUNT (1)
    FROM mputwvsd
   WHERE vsdate >= '29-MAY-2014'
GROUP BY vsdate;

  SELECT 'MPUTWVSD.APDATE', apdate, COUNT (1)
    FROM mputwvsd
   WHERE apdate >= '29-MAY-2014'
GROUP BY apdate;

  SELECT 'MPUTWVSD.MODDATE', moddate, COUNT (1)
    FROM mputwvsd
   WHERE moddate >= '29-MAY-2014'
GROUP BY moddate;

  SELECT 'MPUUPVSD.VSDATE', vsdate, COUNT (1)
    FROM mpuupvsd
   WHERE vsdate >= '29-MAY-2014'
GROUP BY vsdate;

  SELECT 'MPUUPVSD.APDATE', apdate, COUNT (1)
    FROM mpuupvsd
   WHERE apdate >= '29-MAY-2014'
GROUP BY apdate;

  SELECT 'MPUUPVSD.MODDATE', moddate, COUNT (1)
    FROM mpuupvsd
   WHERE moddate >= '29-MAY-2014'
GROUP BY moddate;

  SELECT 'RATEPLAN_AVAILABILITY_PERIOD.ENTRY_DATE', entry_date, COUNT (1)
    FROM rateplan_availability_period
   WHERE entry_date >= '29-MAY-2014'
GROUP BY entry_date;

  SELECT 'RATEPLAN_VERSION.VSDATE', vsdate, COUNT (1)
    FROM rateplan_version
   WHERE vsdate >= '29-MAY-2014'
GROUP BY vsdate;

  SELECT 'RATEPLAN_VERSION.APDATE', apdate, COUNT (1)
    FROM rateplan_version
   WHERE apdate >= '29-MAY-2014'
GROUP BY apdate;
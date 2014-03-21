*include file='//covenas/spssdata/duration.sps'.

recode minute cs_mnts hours cs_hours(sysmis=0).
compute hours2=0.
compute hours2=(minute+cs_mnts)/60.
recode grpsize(sysmis=1).
recode grpsize(0=1).
compute duration=(hours+cs_hours+hours2)/grpsize.
compute duration2=(hours+cs_hours+hours2).
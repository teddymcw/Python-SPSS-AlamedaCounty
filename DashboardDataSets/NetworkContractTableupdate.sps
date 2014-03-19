


GET DATA /TYPE=XLSX
  /FILE='\\Covenas\A&D_Fin\Network Office\Contract Monitoring\EMANIO\Contract Deliverables for Emanio Reports.xlsx'
  /SHEET=name 'contracts'
  /CELLRANGE=full
  /READNAMES=on
  /ASSUMEDSTRWIDTH=32767.
EXECUTE.

rename vars totalhours=CDtotalhours Days=CDDays provname=provnameNetwork.
delete vars agency  provnameDecSupp.
alter type fiscalyear(a10).
compute fiscalyear=concat('FY ',substr(fiscalyear,1,10)).


 * aggregate outfile=* mode=ADDVARIABLES
/break=ru fiscalyear
/count=n.
 * sort cases count(d).
 * temp.
 * select if count > 1 and ru ne 'nan'.
 * SAVE TRANSLATE OUTFILE='C:\Users\meinzerc\Desktop\more than 1 ru contract.xlsx'
  /TYPE=XLS
  /VERSION=12
  /MAP
  /REPLACE
  /FIELDNAMES
  /CELLS=VALUES.
sort cases by ru fiscalyear.
match files /file=* /by ru fiscalyear /last=last.
select if last=1.
exe.
delete vars last.
 * select if ru ne 'nan' or ru ne ''.
alter type ru(a6).
*save outfile='//covenas/decisionsupport/networkcontract.sav'.

 * string test(a2).
 * compute test= substr(fiscalyear, 4,2).
 * compute testnum=number(concat('20',test),f4.0).
save outfile='//covenas/decisionsupport/networkcontract.sav' /keep ru provnameNetwork FiscalYear Clients ClientsPerMonth CDDays @#CaseMgmtHrs @#MentalHealthHrs
@#MedSupportHrs @#CrisisInterventionHrs OtherHours CDtotalhours.
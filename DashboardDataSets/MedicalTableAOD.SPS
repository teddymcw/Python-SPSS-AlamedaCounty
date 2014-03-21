GET DATA /TYPE=ODBC /CONNECT=
 'DSN=AOD;UID=;APP=SPSS For'+
 ' Windows;WSID=HPMXL9360ZDD;Trusted_Connection=Yes'
 /SQL = 'SELECT  CLIENT_NUMBER as "case",   ELIGIBLE_YEAR, '+
 'ELIGIBLE_MONTH, UserName,  Medical_number as BOB, MEDICAL_ELIGIBILITY_STAMP as bob1,'+
  'PROCESSING_STATUS as pstatus, ELIGIBILITY_COUNTY_CODE as eCounty,  PRIMARY_AID_CODE as AidCode '+
   "FROM  dbo.MEDICAL_ELIGIBILITY  where ELIGIBLE_YEAR >= 2010 AND  PROCESSING_STATUS ='P' "
 /ASSUMEDSTRWIDTH=25.
CACHE.

compute calendar = date.moyr(eligible_Month, Eligible_Year).
formats calendar(moyr6).

compute  medical_Eligibility_Stamp= date.dmy(number(substr(bob1,9,2),f2.0),number(substr(bob1,6,2),f2.0),number(substr(bob1,1,4),f4.0)).
formats medical_Eligibility_Stamp(date11).

sort cases by  calendar case  AIdCode.
match files /file=* /by calendar case /last=prim1.
select if prim1=1.

sort cases by AidCode.
match files/table='//covenas/spssdata/AidCodes.sav' /file=* /by AidCode.
rename vars  AIdCode=InsystPrimAidCode.  
compute InMedsTable=1.

if substr(BOB,1,5) = "019H9" BOB = Substr(BOB,6,9).
string Medical_Number(a9).
compute Medical_Number = substr(BOB,1,9).

sort cases by  case calendar.
 * Xsave outfile='//covenas/spssdata/temp\MedicalTableAOD.sav' 
/keep case InsystPrimAidCode InMedsTable Ecounty calendar Full UserName Medical_Number Medical_Eligibility_Stamp.

 * save outfile='//covenas/decisionsupport/MedicalTableAOD.sav' 
/keep case InsystPrimAidCode InMedsTable Ecounty calendar Full UserName Medical_Number Medical_Eligibility_Stamp.

save outfile='//covenas/decisionsupport/Meinzer/Production/Backup/stage/MedicalTableAOD.sav'
/keep case InsystPrimAidCode InMedsTable Ecounty calendar Full UserName Medical_Number Medical_Eligibility_Stamp.




sort cases by ssnSSI reviewme lnameprob fnameprob  .
match files /file=* /by ssnssi /first=ssnssi1.
select if ssnssi1=1.
*keeping SSIcountyReport so we can compare matches against client table later.
save outfile='//covenas/spssdata/temp\MatchedSSN.sav' /keep ssnSSI  ssiNumber SSIcountyReportAA SSIcountyReport.

*start with list of unique clients, take out those that matched on ssn.
*make uniue by name with wide SSN using case to vars.
*match names from IRA to client table with SSN match removed.

get file='//covenas/spssdata/SSI\SSIqueue\JustMaxedSSI.sav' /keep ssnSSI SSIcountyReportAA Name NameLast NameFirst.
match files /table='//covenas/spssdata/temp\MatchedSSN.sav' /file=* /by ssnSSI.
*freq ssiNumber.
select if missing(SSINumber).

*change names to enable match to client table.
rename vars 
NameLast=lnamessi
namefirst=fnamessi.

sort cases by lnamessi fnamessi.
CASESTOVARS
   /id=lnamessi fnamessi
   /drop Name ssiNumber SSIcountyReport.

*alter type NameLast NameFirst(a30).
*sort cases by namelast namefirst.
save outfile='//covenas/spssdata/SSI\SSIqueue\JustMaxedSSINameMatch.sav' .

get file='//covenas/spssdata/SSI\SSIqueue\JustMaxedSSINameMatch.sav' .

 GET DATA  /TYPE=ODBC
  /CONNECT='DSN=SSI;DBQ=//covenas/spssdata/Wong\SSI Advocacy Referrals '+
    '02-01-2012.mdb;DriverId=25;FIL=MS Access;MaxBufferSize=2048;PageTimeout=5;'
  /SQL='SELECT ssnSSI, SSINumber, SSIcountyReport, LNameSSI , FNameSSI , BdaySSI, ssnMEDS, SSNinsyst, SSNSSA, SSNSSA1  FROM CLIENTS '
  /ASSUMEDSTRWIDTH=30.
 CACHE.

*take out previous matches with SSN.
sort cases by ssnSSI.
match files/table='//covenas/spssdata/temp\MatchedSSN.sav'/file=* /by ssnSSI.
select if missing(SSIcountyReportAA).
exe.
delete vars  ssicountyreportaa .
exe.

rename vars ssnssi=ClientTableSSNSSI.
sort cases by lnamessi fnamessi.
match files/table='//covenas/spssdata/SSI\SSIqueue\JustMaxedSSINameMatch.sav' /file=* /by lnamessi fnamessi.
select if not missing(ssnSSI.1).
exe.

*create end markers for varstocases so we dont have to specify the end of the "to".
compute ssnSSIx=999.
compute SSIcountyReportAAx=9999999.
sort variables by name.
varsToCases 
   /make ssnSSI from SSNssi.1 to ssnSSIx   
   /make SSIcountyReportAA from SSIcountyReportAA.1 to SSIcountyReportAAx.

*take out the end markers.  both erronious markers fall in the same row since there is a date for every ssn.
select if ssnssi ne 999.

*estimate how many numbers match by placement in established string of 9    note 0's are used to fill in missing, and will count as a match if comparison number has a zero value.
compute matchSSNSSI=0.
loop #count=1 to 9.
do if substr(ltrim(string(ClientTableSSNSSI,n9)),#count,1)=substr(ltrim(string(ssnSSI,n9)),#count,1).
compute matchSSNSSI=matchSSNSSI+1.
end if.
compute #count=#count+1.
end loop.

sort cases matchssnssi(d).
match files /file=* /keep ClientTableSSNSSI ssnSSI matchSSNSSI fnamessi lnamessi all.
exe.

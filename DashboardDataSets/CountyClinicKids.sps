DEFINE 	DBStartDate() -5 !ENDDEFINE.

GET FILE='//covenas/decisionsupport/dbsvc.sav'.
Select if not any(proced, 200, 300, 400, 197).

Sort cases by Ru.
Match files /Table='//covenas/decisionsupport/RuTable.sav'/File=*/by Ru
     /Keep ru case opdate svcdate agency provname psmask2 county duration duration2.

Select if psmask2=262145 AND county=1.
select if ru ne '81692'.
insert file='//covenas/decisionsupport/modules/uncookedmonth.sps'.

do if xdate.quarter(uncookedmonth) =1.
   compute UCQtrEnd=date.dmy(1,1,xdate.year(uncookedmonth)).
   else if xdate.quarter(uncookedmonth) =2.
      compute UCQtrEnd=date.dmy(1,4,xdate.year(uncookedmonth)).
      else if xdate.quarter(uncookedmonth) =3.
         compute UCQtrEnd=date.dmy(1,7,xdate.year(uncookedmonth)).
         else if xdate.quarter(uncookedmonth) =4.
            compute UCQtrEnd=date.dmy(1,10,xdate.year(uncookedmonth)).
end if.

formats ucqtrEnd(date11).

compute UCqtrstart = datesum(ucqtrend,DBStartDate,'years').

select if svcdate lt ucqtrEnd and svcdate ge UCqtrstart.

freq svcdate /format=notable /stats=min max.

string Quarter(a11).
compute quarter=concat(string(xdate.year(svcdate),n4),' ',"Qtr",string(xdate.quarter(svcdate),n1)).

save outfile='//covenas/decisionsupport/temp/outcountywork.sav'.
get file='//covenas/decisionsupport/temp/outcountywork.sav'.

*combine Alameda and Oakland clinics as requested.

If provname = "ALAMEDA MHS CHILD" or provname = "OAKLAND MHS CHILD" provname = "ALAMEDA/OAKLAND".
If RU="01522" or RU="01082" RU="66666".
*merge provname and ru #s.

Sort cases by quarter ru case.
Match Files /File=*/by Quarter ru case/First=QuarterRuCase1.

Sort cases by case.
Match Files /Table='//covenas/spssdata/clinfo.sav'/File=*/by case
	/KEEP Quarter CIN Ru case opdate svcdate duration duration2 QuarterRuCase1 agency provname bday sex ethnic hispanic language.

Sort cases by case.
Match Files/Table='//covenas/spssdata/AddressMHS.sav'/File=*/by case
	/Keep Quarter CIN Ru case opdate svcdate duration duration2 QuarterRuCase1 agency provname city bday sex ethnic hispanic language.

Rename vars language=Language_Clinfo city=City_Insyst sex=Sex_Insyst.

*add more months.
insert file='//covenas/decisionsupport/meinzer/production/ps/matchaddressmc.sps'.
match files /file=* 	/Keep quarter CIN Ru case opdate svcdate duration duration2 QuarterRuCase1 agency provname City City_Insyst aidcode bday sex_Insyst ethnic hispanic Language_Clinfo .
Rename vars Language_Clinfo=Language City=CityMC sex_Insyst=sex.

insert file ='//covenas/decisionsupport/modules/calsvcdate.sps'.

SAVE OUTFILE='//covenas/decisionsupport/temp\CountyClinicKids_TempWork.sav'.
Get File='//covenas/decisionsupport/temp\CountyClinicKids_TempWork.sav'.

String City(A20).
If CityMC ne " " and CityMC ne "UNKNOWN" City=CityMC.
If City=" " City=City_Insyst.
If City=" " City="UNKNOWN".

Sort cases by city.
Match Files /Table='//covenas/spssdata/SELPA.sav'/File=*/by city
	/Keep quarter CIN Ru case opdate svcdate duration duration2 QuarterRuCase1 agency provname CityMC City_Insyst aidcode Calendar bday sex ethnic hispanic Language City SELPA.

*Temp.
*Select if SELPA=" ".
*Freq City.

if SELPA="North Region" SELPA= "1. North Region".
if SELPA="Oakland" SELPA="2. Oakland".
if SELPA="Mid County" SELPA="3. Mid County".
if SELPA="Mission Valley" SELPA="4. Mission Valley".
if SELPA="Tri-Valley" SELPA="5. Tri-Valley".

If SELPA=" " and Agency="Alameda" SELPA = "1. North Region".
If SELPA=" " and Agency="Oakland" SELPA="2. Oakland".
If SELPA=" " and Agency="Eden" SELPA="3. Mid County".
If SELPA=" " and Agency="Tri-City" SELPA="4. Mission Valley".
If SELPA=" " and Agency="Valley" SELPA="5. Tri-Valley".

freq SELPA.
*no blanks.

**********Match to //covenas/spssdata/Temp\MedicalTable (dot) sav and use InMedsTable (not MediCal) variable.
Sort cases by case calendar.
Match Files/Table='//covenas/spssdata/Temp\MedicalTable.sav'/File=*/by case calendar
	/Keep quarter CIN Ru case opdate svcdate duration duration2 QuarterRuCase1 agency provname City SELPA aidcode Calendar bday sex ethnic hispanic Language InMedsTable.

Sort cases by quarter case svcdate.
match files /file=* /by  quarter case  /First=QuarterCase1.
sort cases by case.
Match files /Table='//covenas/spssdata/AB3632\tblClients_insystList.sav'/File=*/by case.

Recode AB3632 InMedsTable EndDate QualifyingDate(sysmis=0).
if EndDate =0 endDate = Date.dmy(2,2,2040).
if QualifyingDate = 0 QualifyingDate  = Date.dmy(2,2,2040).


SAVE OUTFILE='//covenas/decisionsupport/temp\CountyClinicKids_TempWorkx2.sav'.
Get File='//covenas/decisionsupport/temp\CountyClinicKids_TempWorkx2.sav'.

 * Sort cases by case quarter.
 * split file by case quarter.
 * freq ab3632. 


********** CHANGE -- New yrmoda per Report.

do if xdate.quarter(svcdate) =1.
   compute QtrStart=date.dmy(1,1,xdate.year(svcdate)).
   compute QtrEnd=date.dmy(0,4,xdate.year(svcdate)).
   else if xdate.quarter(svcdate) =2.
      compute QtrStart=date.dmy(1,4,xdate.year(svcdate)).
      compute QtrEnd=date.dmy(0,7,xdate.year(svcdate)).
      else if xdate.quarter(svcdate) =3.
         compute QtrStart=date.dmy(1,7,xdate.year(svcdate)).
         compute QtrEnd=date.dmy(0,10,xdate.year(svcdate)).
         else if xdate.quarter(svcdate) =4.
            compute QtrStart=date.dmy(1,10,xdate.year(svcdate)).
            compute QtrEnd=date.dmy(31,12,xdate.year(svcdate)).
end if.
formats qtrstart qtrend (date11).
*If QuarterRuCase1=1 AND (qualifyingDate gt qtrend OR EndDate lt qtrstart) AB3632=0.

*GO.
If (qualifyingDate gt qtrend OR EndDate lt qtrstart) AB3632=0.
********** If QualifyingDate falls after the qtr and EndDate falls before it, AB3632=0.

 * If QuarterCase1 ne 1 AND AB3632=1 AB3632=0.
 * If QuarterCase1 ne 1 AND InMedsTable=1 InMedsTable=0.
*GO.
if QuarterRuCase1 = 1 and AB3632=1 ClinicAB3632QtrCounter=1.
if QuarterRuCase1 = 1 and InMedsTable=1 ClinicMedsQtrCounter=1.
Rename vars InMedsTable=MediCal.

 * Sort cases by case SELPA svcdate.
 * Sort cases by case SELPA.
 * Match Files/File=*/by case SELPA/First=SELPACase1.

*GO.
sort cases by SELPA quarter case.
Match Files /File=*/by SELPA quarter case /First=SELPAQtrCase1.
if SELPAQtrCase1 = 1 and AB3632=1 SELPAAB3632QtrCounter=1.
if SELPAQtrCase1 = 1 and MediCal=1 SELPAMedsQtrCounter=1.

*Temp.
*Select if Case1=1.
*Freq ruCase1.

insert file='//covenas/decisionsupport/modules\language.sps'.

Aggregate Outfile=* mode=addVariables/Break=case quarter /MinQtrSvcDate=min(svcdate).

Compute Age=TRUNC((xdate.tday(minqtrsvcdate)-xdate.tday(bday))/365.25).

String AgeGroup(A15).
If Age ge 18 AgeGroup="D. 18+".
If Age ge 12 and Age lt 18 AgeGroup="C. 12 to 17".
If Age ge 6 and Age lt 12 AgeGroup="B. 6 to 11".
If AgeGroup=" " AgeGroup="A. 0 to 5".

include file='//covenas/decisionsupport/Modules\Ethnicity.sps'.

Aggregate outfile=* mode=addVariables/break=quarter/TotalClients=sum(Quartercase1).

String Gender(A10).
if sex = 'M' Gender= 'Male'.
if sex = 'F' Gender= 'Female'.
if sex = 'U' Gender= 'Unknown'.

aggregate outfile =*
   /break= Quarter Case provname City SELPA Gender Ethnicity LANGUAGE TotalClients
   /Age=max(Age)
   /AgeGroup=max(AgeGroup)
   /SELPAQtrCase1=max(SELPAQtrCase1)
   /QuarterRuCase1=max(QuarterRuCase1)
   /ClinicAB3632QtrCounter=max(ClinicAB3632QtrCounter)
   /ClinicMedsQtrCounter=max(ClinicMedsQtrCounter)
   /SELPAAB3632QtrCounter=max(SELPAAB3632QtrCounter)
   /SELPAMedsQtrCounter=max(SELPAMedsQtrCounter).

*GO.

aggregate outfile=* mode=addvariables overwrite=yes
   /break case quarter
   /AB3632=max(ClinicAB3632QtrCounter) 
   /medical=max(ClinicMedsQtrCounter).

*GO.
sort cases by quarter case.
Match Files /File=*/by quarter case /First=QtrCase1.
if QtrCase1 = 1 and AB3632=1 AB3632QtrCounter=1.
if QtrCase1 = 1 and MediCal=1 MedsQtrCounter=1.

if language = 'UNKNOWN/UN' language='UNKNOWN'.
if Ethnicity = 'Other/Unknown' Ethnicity ='Other /Unknown'.

save outfile='//covenas/decisionsupport/temp/countyclinic.sav'.

*aggregate outfile = * mode ADDVARIABLES /break= quarter provname case /records=n /medsum=sum(medical) /absum=sum(ab3632).

*SAVE OUTFILE='//covenas/decisionsupport/temp\CountyClinicKids_WORK.sav'.
*save outfile='//covenas/decisionsupport/temp\CountyClinicKids_WORK.sav'.

 * get FILE='//covenas/decisionsupport/temp\CountyClinicKids_WORK.sav' /keep 
case
MediCal
ab3632
Quarter
provname
City
SELPA
Gender
Ethnicity
LANGUAGE
TotalClients
Age
AgeGroup
QuarterCase1
SELPAQtrCase1
QuarterRuCase1
ClinicAB3632QtrCounter
ClinicMedsQtrCounter
SELPAAB3632QtrCounter
SELPAMedsQtrCounter. 

 * freq medical.

*pushbreak.
*sqlTable = 'CountyClinic'.
*spsstable='//covenas/decisionsupport/temp/countyclinic.sav'.
*pushbreak.




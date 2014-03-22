
GET DATA
  /TYPE=ODBC
  /CONNECT='DSN=AOD;UID=;Trusted_Connection=Yes;APP=IBM SPSS Products: Statistics '+
    'Common;WSID=HPMXL2221NXK;DATABASE=CG_AOD'
  /SQL='SELECT ADDRESS_EFFECTIVE_DATE, CLIENT_NUMBER as "case", STREET_NUMBER as number, STREET_NAME as street, CITY as city, ZIP_CODE as zipcode, LAST_CHANGE_STAMP as lstchnge, '+
    'PHONE_NUMBER as phone FROM CG_AOD.dbo.[ADDRESS_MASTER]'
  /ASSUMEDSTRWIDTH=255.

CACHE.
EXECUTE.
AUTORECODE ZIPCODE
 /INTO tm1.
DELETE VARIABLES ZIPCODE.
RENAME VARIABLES (tm1=ZIPCODE).

select if case ne 0.
sort cases by case ADDRESS_EFFECTIVE_DATE.
match files /file=* /by case /last=case1.
 
select if case1=1.
exe.
delet variables case1.

insert file= '//covenas/spssdata/cities.sps'.
 * rename variables str_dir=Street_Direction.
 * rename variables str_type=Street_Type.
 * rename variables apt_num=Apt_Number.
*this is new-- creates street address.
 * string StreetAddressINSYST(a40).
 * compute StreetAddressINSYST = CONCAT(ltrim(rtrim(String(Number,f12.0)))," ", ltrim(rtrim(street_Direction)), " ", ltrim(rtrim(street)), " " , ltrim(rtrim(street_Type)), " " ,  ltrim(rtrim(APt_Number))). 

sort cases by case.

save outfile='//covenas/decisionsupport/Meinzer/Production/Backup/stage/aodAddress.sav'.

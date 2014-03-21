compute Lname = Upcas(ltrim(rtrim(lname))).
compute fname = Upcas(ltrim(rtrim(fname))).

compute bob=0.
compute bob=index(lname,".").
do if bob ne 0.
Compute lname=Concat(substr(lname,1,bob-1), " ", substr(lname,bob+1)).
end if.

compute biff=0.
compute biff=index(lname,"'").
do if biff ne 0.
Compute lname=Concat(substr(lname,1,biff-1), substr(lname,biff+1)).
end if.

compute bam=0.
compute bam=index(lname,"-").
do if bam ne 0.
Compute lname=Concat(substr(lname,1,bam-1), substr(lname,bam+1)).
end if.

compute LnameLeng = length(rtrim(lname)).
compute newStart = LnameLeng-2.
exe.

do if newStart ge 1.
do if substr(lname, newStart ,3) = " JR" OR  substr(lname, newStart ,3) = " SR" OR  substr(lname, newStart ,3) = " II" OR  substr(lname, newStart ,3) = " IV" .
compute lname = substr(lname,1,newStart).
end if.
end if.

compute newStart = LnameLeng-3.

do if newStart ge 1.
do if substr(lname, newStart ,4) = " III" OR  substr(lname, newStart ,4) = " IST" OR  substr(lname, newStart ,3) = " II" .
compute lname = substr(lname,1,newStart).
end if.
end if.

compute lname = replace(lname," ","").

compute bob1=0.
compute bob1=index(fname,".").
do if bob1 ne 0.
Compute fname=Concat(substr(fname,1,bob1-1), " ", substr(fname,bob1+1)).
end if.

compute biff1=0.
compute biff1=index(fname,"'").
do if biff1 ne 0.
Compute fname=Concat(substr(fname,1,biff1-1), substr(fname,biff1+1)).
end if.

compute bam1=0.
compute bam1=index(fname,"-").
do if bam1 ne 0.
Compute fname=Concat(substr(fname,1,bam1-1), substr(fname,bam1+1)).
end if.

compute FnameLeng = length(rtrim(fname)).
compute newStart1 = FnameLeng-2.
exe.

do if newStart1 ge 1.
do if substr(fname, newStart1 ,3) = " JR" OR  substr(fname, newStart1 ,3) = " SR".
compute fname = substr(fname,1,newStart1).
end if.
end if.

compute fname = replace(fname," ","").

*sort cases by fname sex.
*match files/table='//covenas/decisionsupport/modules\fnameFix.sav' /file=* /by fname sex.

sort cases fname. 
string fname2 (A75). 

if fname2 = " " fname2=fname.

string SSNx(a9).
compute SSNx = string(ssn,f9).

if substr(ssnx,1,1) = "9" OR substr(ssnx,1,1) = "8"or substr(ssnx,1,3) = "666" or substr(ssnx,1,3) = "000" ssnx="0". 
compute ssn= number(ssnx,f9).
if ssn lt 100000000 ssn=0.
recode ssn(0=sysmis).


match files/file=* /drop ssnX bam bam1 biff biff1 bob bob1 newStart LnameLeng FnameLeng newStart1.

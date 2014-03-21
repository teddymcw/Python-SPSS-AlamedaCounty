***Staff Name Fix Module***.
string lname(a16).
compute lname=substr(name,1,16).

string fname(a14).
compute fname=substr(name,17,30).

string StaffName(a30).
Compute StaffName=concat(rtrim(fname), " ",ltrim(lname)).

match files /file =* /drop lname fname name.



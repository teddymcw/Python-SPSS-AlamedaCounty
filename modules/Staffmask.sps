*replace test.
*comment out part will create the detail, but it needs to be added to each section.


 * string staffDetail(a200).

 * do if staffdetail="".
 * compute staffDetail=staffdetail(#svec).
 * else.
 * compute staffDetail=concat(rtrim(staffdetail),", ",ltrim(StaffPosition(#svec))).
 * end if.



compute #svec=1.
compute #tempv=position.
vector StaffPosition(17 a30).
loop.
   do if #tempv  ge	524288.
      compute StaffPosition(#svec) = "Clinical Nurse Spec".
      compute #tempv = #tempv-524288.
      compute #svec=#svec+1.
      compute ClinicalNurseSpec=1.
      compute Nurse=1.
   else if #tempv  ge	262144.
      compute StaffPosition(#svec) = "Nurse Practitioner".
      compute #tempv = #tempv-262144.
      compute #svec=#svec+1.
      compute NursePractitioner=1.
      compute Doc=1.
   else if #tempv  ge	131072.
      compute StaffPosition(#svec) = "Psychologist Intern".
      compute #tempv = #tempv-131072.
      compute #svec=#svec+1.
   else if #tempv  ge	65536.
      compute StaffPosition(#svec) = "LPCC w/family".
      compute #tempv = #tempv-65536.
      compute #svec=#svec+1.
   else if #tempv  ge	32768.
      compute StaffPosition(#svec) = "LPCC".
      compute #tempv = #tempv-32768.
      compute #svec=#svec+1.
   else if #tempv  ge	16384.
      compute StaffPosition(#svec) = "Rehab Counselor".
      compute #tempv = #tempv-16384.
      compute #svec=#svec+1.
      compute RehabCounselor=1.
   else if #tempv ge 8192.
      compute StaffPosition(#svec) = "Intern".
      compute #tempv = #tempv-8192.
      compute #svec=#svec+1.
      compute Intern=1.
   else if #tempv ge 4096.
      compute StaffPosition(#svec) = "Physician Assistant".
      compute #tempv = #tempv-4096.
      compute #svec=#svec+1.
      compute Doc=1.
   else if #tempv ge 2048.
      compute StaffPosition(#svec) = "Occupation Therapist".
      compute #tempv = #tempv-2048.
      compute #svec=#svec+1.
   else if #tempv ge 1024.
      compute StaffPosition(#svec) = "Unlicensed Worker".
      compute #tempv = #tempv-1024.
      compute #svec=#svec+1.
   else if #tempv ge 512.
      compute StaffPosition(#svec) = "Medical Records".
      compute #tempv = #tempv-512.
      compute #svec=#svec+1.
   else if #tempv ge 256.
      compute StaffPosition(#svec) = "Educator".
      compute #tempv = #tempv-256.
      compute #svec=#svec+1.
   else if #tempv ge 128.
      compute StaffPosition(#svec) = "Pharmacist".
      compute #tempv = #tempv-128.
      compute #svec=#svec+1.
   else if #tempv ge 64.
      compute StaffPosition(#svec) = "Marriage Family Counselor".
      compute #tempv = #tempv-64.
   else if #tempv ge 32.
      compute StaffPosition(#svec) = "Social Worker".
      compute #tempv = #tempv-32.
      compute #svec=#svec+1.
   else if #tempv ge 16.
      compute StaffPosition(#svec) = "Psychologist".
      compute #tempv = #tempv-16.
      compute #svec=#svec+1.
      compute Psychologist=1.
   else if #tempv ge 8.
      compute StaffPosition(#svec) = "Nurse".
      compute #tempv = #tempv-8.
      compute #svec=#svec+1.
      compute Nurse=1.
   else if #tempv ge 4.
      compute StaffPosition(#svec) = "Psych Tech".
      compute #tempv = #tempv-4.
      compute #svec=#svec+1.
   else if #tempv ge 2.
      compute StaffPosition(#svec) = "Psychiatrist".
      compute #tempv = #tempv-2.
      compute #svec=#svec+1.
      compute PsycDoc=1.
      compute Doc=1.
   else if #tempv ge 1.
      compute StaffPosition(#svec) = "Physician".
      compute #tempv = #tempv-1.
      compute #svec=#svec+1.
      compute MedDoc=1.
      compute Doc=1.
   else if #tempv ge 0.
      compute StaffPosition(#svec) = "None".
      compute #tempv = #tempv-0.
   else if #tempv = -1.
      compute StaffPosition(#svec) = "All".
      compute #tempv = #tempv--1.
   end if.
end loop if #tempv=0 or #tempv=-1.
exe.

string positiontype(a120).
do if staffposition2=''.
compute positionType=(rtrim(staffposition1)).
else if staffposition3=''.
compute positionType=concat(rtrim(staffposition1),', ',ltrim(rtrim(staffposition2))).
else if staffposition4=''.
compute positionType=concat(rtrim(staffposition1),', ',ltrim(rtrim(staffposition2)),', ',ltrim(rtrim(staffposition3))).
else if staffposition5=''.
compute positionType=concat(rtrim(staffposition1),', ',ltrim(rtrim(staffposition2)),', ',ltrim(rtrim(staffposition3)),', ',ltrim(rtrim(staffposition4))).
else if staffposition6=''.
compute positionType=concat(rtrim(staffposition1),', ',ltrim(rtrim(staffposition2)),', ',ltrim(rtrim(staffposition3)),', ',ltrim(rtrim(staffposition4)),', ',ltrim(rtrim(staffposition5))).
else if staffposition7=''.
compute positionType=concat(rtrim(staffposition1),', ',ltrim(rtrim(staffposition2)),', ',ltrim(rtrim(staffposition3)),', ',ltrim(rtrim(staffposition4)),', ',ltrim(rtrim(staffposition5)),' and more').
end if.
exe.
delete vars staffposition1 to staffposition17.
exe.

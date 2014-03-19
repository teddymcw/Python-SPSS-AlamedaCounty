get file='//covenas/decisionsupport/doesnotexist.sav'.
EXECUTE.
xxxx.
get file='//covenas/decisionsupport/epsCG.sav' /keep ru case opdate epFlag closDate .
freq closdate /formats=notable /stats=max.


dataset close *.

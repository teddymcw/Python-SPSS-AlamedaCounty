rename variable Language=l.
STRING Language(A18).
if L='A' Language='English'.
IF L='B' Language='Spanish'.
IF L='C' Language='Chinese Dialect'.
IF L='D' Language='Japanese'.
IF L='E' Language='Filipino Dialect'.
IF L='F' Language='Vietnamese'.
IF L='G' Language='Laotian'.
IF L='H' Language='Cambodian'.
IF L='I' Language='Sign'.
IF L='J' Language='Other Non-English'.
IF L='K' Language='Korean'.
IF L='L' Language='Russian'.
IF L='M' Language='Polish'.
IF L='N' Language='German'.
IF L='O' Language='Italian'.
IF L='P' Language='Mien'.
IF L='Q' Language='Hmong'.
IF L='R' Language='Turkish'.
IF L='S' Language='Hebrew'.
IF L='T' Language='French'.
IF L='U' Language='Cantonese'.
IF L='V' Language='Mandarin'.
IF L='W' Language='Portugese'.
IF L='X' Language='Armenian'.
IF L='Y' Language='Arabic'.
IF L='Z' Language='Samoan'.
IF L='1' Language='Thai'.
IF L='2' Language='Farsi'.
IF L='3' Language='Other Sign'.
IF L='4' Language='Other Chinese'.
IF L='5' Language='Ilocano'.
IF L='9' Language='Unknown/Unreported'.
IF L=' ' Language='Missing'.
RENAME VARIABLE L=LANGCODE.
execute.
do if (county =1).
do if any(Agency, "Eden", "Oakland", "Tri-City", "Valley", "Alameda").
do if kidsru=1.
compute Agency = concat(rtrim(Agency), " ","Child").
else.
compute Agency=concat(rtrim(Agency)," ","Adult").
end if.
end if.
end if.

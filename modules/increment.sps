*compute incrementthing='Days'.


string TempOrder(a3).
string catInc (a33).
format increment(f4.0).
loop #count=1 to 7.
do if #count =1.
compute tempOrder='a. '.
   do if daysSinceOp lt (increment*#count) and daysSinceOp ge ((increment*#count)-increment).
      do if incrementthing='Days'.
         do if increment=1.
         compute catInc=concat(tempOrder,ltrim(string(((increment*#count)-increment),f4.0)),' to less than ',ltrim(string(increment*#count,f4.0)),' ',incrementthing).
         else.
         compute catInc=concat(tempOrder,ltrim(string(((increment*#count)-increment),f4.0)),'-',ltrim(string(increment*#count,f4.0)),' ',incrementthing).
         end if.
      else if incrementthing='Months'.
         do if increment=30.
         compute catInc=concat(tempOrder,ltrim(string((((increment*#count)-increment)/30),f4.0)),' to less than ',ltrim(string((increment*#count)/30,f4.0)),' ',incrementthing).
         else.
         compute catInc=concat(tempOrder,ltrim(string((((increment*#count)-increment)/30),f4.0)),'-',ltrim(string((increment*#count)/30,f4.0)),' ',incrementthing).
      end if.
      else if incrementthing='Years'.
         do if increment=365.
         compute catInc=concat(tempOrder,ltrim(string((((increment*#count)-increment)/365),f4.0)),' to less than ',ltrim(string((increment*#count)/365,f4.0)),' ',incrementthing).
         else.
         compute catInc=concat(tempOrder,ltrim(string((((increment*#count)-increment)/365),f4.0)),'-',ltrim(string((increment*#count)/365,f4.0)),' ',incrementthing).
end if.
      end if.
end if.
else if #count lt 7.
if #count=2 tempOrder='b. '.
if #count=3 tempOrder='c. '.
if #count=4 tempOrder='d. '.
if #count=5 tempOrder='e. '.
if #count=6 tempOrder='f. '.
do if daysSinceOp lt (increment*#count) and daysSinceOp ge ((increment*#count)-increment).
      do if incrementthing='Days'.
         do if increment=1.
         compute catInc=concat(tempOrder,ltrim(string((((increment*#count)-increment)),f4.0)),' to less than ',ltrim(string(increment*#count,f4.0)),' ',incrementthing).
         else.
         compute catInc=concat(tempOrder,ltrim(string((((increment*#count)-increment)+1),f4.0)),'-',ltrim(string(increment*#count,f4.0)),' ',incrementthing).
end if.
      else if incrementthing='Months'.
         do if increment=30.
         compute catInc=concat(tempOrder,ltrim(string(((((increment*#count)-increment)/30)),f4.0)),' to less than ',ltrim(string((increment*#count)/30,f4.0)),' ',incrementthing).
         else.
         compute catInc=concat(tempOrder,ltrim(string(((((increment*#count)-increment)/30)+1),f4.0)),'-',ltrim(string((increment*#count)/30,f4.0)),' ',incrementthing).
end if.
      else if incrementthing='Years'.
         do if increment=365.
         compute catInc=concat(tempOrder,ltrim(string(((((increment*#count)-increment))/365),f4.0)),' to less than ',ltrim(string((increment*#count)/365,f4.0)),' ',incrementthing).
         else.
         compute catInc=concat(tempOrder,ltrim(string(((((increment*#count)-increment)+1)/365),f4.0)),'-',ltrim(string((increment*#count)/365,f4.0)),' ',incrementthing).
      end if.
    end if.
end if.
else if #count=7.
compute tempOrder='g. '.
   do if daysSinceOp ge ((increment*#count)-increment).
      do if incrementthing='Days'.
         compute catInc=concat(tempOrder,ltrim(string((((increment*#count)-increment)+1),f4.0)),' ',rtrim(incrementthing),'+').
       else if incrementthing='Months'.
         compute catInc=concat(tempOrder,ltrim(string(((((increment*#count)-increment)+1)/30),f4.0)),' ',rtrim(incrementthing),'+').
      else if incrementthing='Years'.
         compute catInc=concat(tempOrder,ltrim(string(((((increment*#count)-increment)+1)/365),f4.0)),' ',rtrim(incrementthing),'+').
    end if.
end if.
end if.
end loop.

exe.
delete vars temporder.
exe.



 * string TempOrder(a3).
 * string catInc (a33).
 * format increment(f4.0).
 * loop #count=1 to 7.
 * do if #count =1.
 * compute tempOrder='a. '.
 *    do if daysSinceOp lt (increment*#count) and daysSinceOp ge ((increment*#count)-increment).
 *          compute catInc=concat(tempOrder,ltrim(string(((increment*#count)-increment),f4.0)),'-',ltrim(string(increment*#count,f4.0)),' ',incrementthing).
 *     end if.
 * else if #count lt 7.
 * if #count=2 tempOrder='b. '.
 * if #count=3 tempOrder='c. '.
 * if #count=4 tempOrder='d. '.
 * if #count=5 tempOrder='e. '.
 * if #count=6 tempOrder='f. '.
 *    do if daysSinceOp lt (increment*#count) and daysSinceOp ge ((increment*#count)-increment).
 *          compute catInc=concat(tempOrder,ltrim(string((((increment*#count)-increment)+1),f4.0)),'-',ltrim(string(increment*#count,f4.0)),' ',incrementthing).
 *     end if.
 * else if #count=7.
 * compute tempOrder='g. '.
 *    do if daysSinceOp ge ((increment*#count)-increment).
 *          compute catInc=concat(tempOrder,ltrim(string((((increment*#count)-increment)+1),f4.0)),' ',rtrim(incrementthing),'+').
 * end if.
 * end if.
 * end loop.

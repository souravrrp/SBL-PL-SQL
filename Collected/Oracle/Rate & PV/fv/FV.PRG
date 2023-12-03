clos all
*SET TALK OFF
clear


NEWDIR=TRIM('D:\BACKUP\BEFRWEEK\HIRE\DATA\')
dir=TRIM('D:\BACKUP\BEFRWEEK\HIRE\')

sele 2
use c:\anis\irate inde c:\anis\irate

*mpid=pid

sele 1
USE '&newdir'+'PRODUCT' INDE '&newdir'+'PRODUCT'

scan for (left(pid,2)<>'30' and left(pid,2)<>'99' AND left(pid,2)<>'20' AND left(pid,2)<>'45' AND left(pid,2)<>'25') and phipr>0 and pinstno>0

mpid=pid
store 0 to hp,cp,dp,inst,term,prin,inter,ip,pp
*@ 10,10 SAY MPID
hp=phipr
cp=pcapr
dp=pdnpay
inst=pminst
term=pinstno

prin=cp-dp

inter=(inst*term-prin)/(prin*term)
*incr=.001
*count=1
do while .T.
for i=1 to term
ip=prin*inter
pp=inst-ip
prin=prin-pp
endfor

if abs(prin)>.01

incr=prin/((cp-dp)*term)

inter=inter-incr
prin=cp-dp
else
exit
endif

*count=count+1
*?prin
enddo
sele 2
seek mpid
if !found()
append blank
endif
repl pid with mpid,rate with round(inter*100,5)

sele 1
endscan
*endif
clear
*?prin
*?inter*100
*?count
clos all

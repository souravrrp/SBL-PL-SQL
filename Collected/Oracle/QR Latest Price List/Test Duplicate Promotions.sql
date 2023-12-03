--***** Test Duplicate Promotions Sysdate
select T.part_no, COUNT(*)
  from SBL_DISCOUNT_PROMOTION t
 WHERE trunc(sysdate) between T.valid_from and T.valid_to
   and T.transaction_no = 2
   and T.channel in ('ALL', '24', '736', '762', '1142')
   GROUP BY T.part_no
   HAVING COUNT(*) > 1


--***** Test Duplicate Promotions Date Range
select T.part_no, COUNT(*)
  from SBL_DISCOUNT_PROMOTION t
 WHERE T.valid_to >= to_date('&from_date', 'yyyy/mm/dd')
   and T.valid_from <= to_date('&to_date', 'yyyy/mm/dd')
   and T.transaction_no = 2
   and T.channel in ('ALL', '24'/*, '736', '762', '1142'*/)
 GROUP BY T.part_no
HAVING COUNT(*) > 1

--***** Test Promotion Data Range
select /*t.valid_from,*/ t.valid_to
  from ifsapp.SBL_DISCOUNT_PROMOTION t
 where T.valid_to >= to_date('&from_date', 'yyyy/mm/dd')
   and T.valid_from <= to_date('&to_date', 'yyyy/mm/dd')
 group by /*t.valid_from,*/ t.valid_to
 order by /*t.valid_from,*/ t.valid_to


--***** Test Duplicate Promotions Date Range Product Details
select *
  from SBL_DISCOUNT_PROMOTION t
 where t.part_no = /*'SRTV-SLE49E3SMTV'*/ /*'SRFUR-BDWD001F'*/
   and T.valid_to >= to_date('&from_date', 'yyyy/mm/dd')
   and T.valid_from <= to_date('&to_date', 'yyyy/mm/dd')
   and T.transaction_no = 2
   and T.channel in ('ALL', '24'/*, '736', '762', '1142'*/)

--*****
/*
PK-SRFUR-JOVANA-TABS-SET2
SRFUR-BCWD001F
PK-SRFUR-JOVANA-COFF-SET2
SRFUR-BDWD001F
SRFUR-CBMG006F
*/

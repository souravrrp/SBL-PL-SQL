--latest 100 hire sales receipt data
select * from 
  (select * from HPNRET_PAY_RECEIPT_head_TAB T
    ORDER BY T.RECEIPT_DATE DESC) Hire_Sales
  where rownum <=100
  order by rownum desc;

--latest 100 cash sales receipt data  
select * from
  (select * from HPNRET_CO_PAY_HEAD_TAB s
    order by s.receipt_date desc) Cash_Sales
  where rownum <= 100
  order by rownum desc;

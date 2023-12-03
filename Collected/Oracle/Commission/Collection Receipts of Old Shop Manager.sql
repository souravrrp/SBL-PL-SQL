SELECT 
    --COUNT(T2.receipt_no) receipt_no
    t2.identity,
    t2.receipt_no,
    (t2.amount - NVL(t2.discount, 0)) amt
FROM 
  hpnret_pay_receipt_head_tab t1,
  hpnret_pay_receipt t2  
WHERE 
  t1.receipt_no = t2.receipt_no AND 
  t1.company = t2.company AND 
  t1.contract like '&Site' AND 
  t1.account_no IN 
    (SELECT DISTINCT t.account_no 
      FROM hpnret_hp_dtl_tab t 
      WHERE 
        trunc(t.variated_date) BETWEEN to_date('&FromDate','yyyy/mm/dd') AND to_date('&ToDate','yyyy/mm/dd') AND 
        t.contract like '&Site' AND 
        t.rowstate in ('CashConverted', 'ExchangedIn', 'Returned')) AND --like '&State' 'CashConverted', 'ExchangedIn', 'Returned', ''
  t1.identity like '&Salesman' AND 
  t1.receipt_no LIKE '%-HC%' and
  t1.rowstate <> 'Cancelled'

--select distinct(t.rowstate) from HPNRET_HP_DTL_TAB t

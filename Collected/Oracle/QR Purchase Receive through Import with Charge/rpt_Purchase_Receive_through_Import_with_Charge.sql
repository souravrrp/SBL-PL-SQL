--***** Purchase Receive through Import with Charge
select *
  from IFSAPP.SBL_PURCHASE_REC_THR_IMP_CHG r
 where r.arrival_date between to_date('&from_date', 'YYYY/MM/DD') and
       to_date('&to_date', 'YYYY/MM/DD')

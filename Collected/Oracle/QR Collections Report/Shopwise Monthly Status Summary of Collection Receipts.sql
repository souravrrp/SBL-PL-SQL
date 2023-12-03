--Shopwise Monthly Status Summary of Collection Receipts
select extract(year from h.receipt_date) "YEAR",
       extract(month from h.receipt_date) period,
       p.contract,
       s.area_code,
       s.district_code,
       p.rowstate,
       count(p.receipt_no) no_of_receipts
  from ifsapp.HPNRET_PAY_RECEIPT_TAB p
 inner join ifsapp.HPNRET_PAY_RECEIPT_HEAD_TAB h
    on p.receipt_no = h.receipt_no
 inner join ifsapp.shop_dts_info s
    on p.contract = s.shop_code
 where substr(p.receipt_no, 4, 3) = '-HC'
   and trunc(h.receipt_date) between to_date('&from_date', 'YYYY/MM/DD') and
       to_date('&to_date', 'YYYY/MM/DD')
/*and h.rowstate = 'Approved'*/ --'Cancelled'
/*and p.rowstate != 'Approved'*/ --'Cancelled'
 group by extract(year from h.receipt_date),
          extract(month from h.receipt_date),
          p.contract,
          s.area_code,
          s.district_code,
          p.rowstate
 order by extract(year from h.receipt_date),
          extract(month from h.receipt_date),
          p.contract,
          p.rowstate;

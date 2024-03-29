--***** Daily VAT Report
select s.sales_date, s.vat_code, sum(abs(s.unit_nsp) * s.sales_quantity) nsp, sum(s.vat) vat
  from (select *
          from IFSAPP.SBL_JR_SALES_DTL_INV i
        union all
        select * from IFSAPP.SBL_JR_SALES_DTL_PKG_COMP c) s
 where s.sales_date between to_date('&FROM_DATE', 'YYYY/MM/DD') and
       to_date('&TO_DATE', 'YYYY/MM/DD')
   and s.status not in ('CashConverted', 'PositiveCashConv')
 group by s.sales_date, s.vat_code
 order by s.sales_date, s.vat_code

--***** WS Receivable
select sum(s.sales_price), sum(s.amount_rsp) receivable
  from (select *
          from IFSAPP.SBL_JR_SALES_DTL_INV i
        union all
        select * from IFSAPP.SBL_JR_SALES_DTL_PKG_COMP c) s
 inner join IFSAPP.SBL_JR_PRODUCT_DTL_INFO p
    on s.product_code = p.product_code
 where s.sales_price != 0
   and s.site in ('JWSS', 'SAOS', 'SWSS', 'WSMO')
   and /*(s.product_code like 'SRSM-%' or*/ s.product_code like '%FUR-%'/*)*/
   and s.sales_date between to_date('&FROM_DATE', 'YYYY/MM/DD') and
       to_date('&TO_DATE', 'YYYY/MM/DD')

--Wholesale Computer Sales Invoice Details
select *
  from (select *
          from IFSAPP.SBL_JR_SALES_DTL_INV i
        union all
        select * from IFSAPP.SBL_JR_SALES_DTL_PKG_COMP c) s
 where s.invoice_id in
       (select s.invoice_id
          from (select *
                  from IFSAPP.SBL_JR_SALES_DTL_INV i
                union all
                select * from IFSAPP.SBL_JR_SALES_DTL_PKG_COMP c) s
         inner join IFSAPP.SBL_JR_PRODUCT_DTL_INFO p
            on s.product_code = p.product_code
         where s.sales_price != 0
           and s.sales_date between to_date('&FROM_DATE', 'YYYY/MM/DD') and
               to_date('&TO_DATE', 'YYYY/MM/DD')
           and p.product_family in ('COMPUTER-DESKTOP', 'COMPUTER-LAPTOP')
           and s.site in ('JWSS', 'SAOS', 'SWSS', 'WSMO'))
 order by s.sales_date, s.invoice_id, s.item_id

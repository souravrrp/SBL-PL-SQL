--***** Sales Returns
select s.*, p.product_family, p.brand, n.sales_date
  from (select i.*
          from IFSAPP.SBL_JR_SALES_DTL_INV i
        union all
        select c.* from IFSAPP.SBL_JR_SALES_DTL_PKG_COMP c) s
 inner join IFSAPP.SBL_JR_PRODUCT_DTL_INFO p
    on s.product_code = p.product_code
  left join (select s2.order_no, max(s2.sales_date) sales_date
               from (select *
                       from IFSAPP.SBL_JR_SALES_DTL_INV i2
                     union all
                     select * from IFSAPP.SBL_JR_SALES_DTL_PKG_COMP c2) s2
              where s2.status in ('HireSale', 'CashSale')
              group by s2.order_no) n
    on s.order_no = n.order_no
 where s.sales_price != 0
   and s.status in ('Returned', 'ReturnCompleted')
   and s.sales_date between to_date('&FROM_DATE', 'YYYY/MM/DD') and
       to_date('&TO_DATE', 'YYYY/MM/DD')

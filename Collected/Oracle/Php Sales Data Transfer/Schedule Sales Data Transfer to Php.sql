--*****Schedule Sales Data Transfer to Php
select S4 as shop_code,
       S8 as product_name,
       S9 as product_code,
       S10 as account_no,
       to_char(to_date(s1, 'yyyy-mm-dd'), 'yyyy-mm-dd') as sale_date,
       S15 as sales_type,
       N1 as total_sales,
       N2 as quantity,
       decode(N2, 0, 0, ((N2 / abs(N2)) * c.tax_amount)) tax_amount,
       (N1 - decode(N2, 0, 0, ((N2 / abs(N2)) * c.tax_amount))) NSP
  from ifsapp.info_services_rpt r,
       (select x.order_no, l.catalog_no, avg(x.tax_amount) tax_amount
          from ifsapp.CUST_ORDER_LINE_TAX_LINES_TAB x
         inner join CUSTOMER_ORDER_LINE_TAB l
            on x.order_no = l.order_no
           and x.line_no = l.line_no
           and x.rel_no = l.rel_no
           and x.line_item_no = l.line_item_no
         group by x.order_no, l.catalog_no) c
 where r.RESULT_KEY =
       (select max(a.RESULT_KEY)
          from IFSAPP.ARCHIVE a
         where a.REPORT_TITLE = 'Sales Analysis Report - Schedule'
           and a.owner = 'IFSAPP')
   and r.S10 = c.ORDER_NO(+)
   and r.s9 = c.CATALOG_NO(+)
 order by s10, s9

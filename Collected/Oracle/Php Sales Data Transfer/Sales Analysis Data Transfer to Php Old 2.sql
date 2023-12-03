--*****Sales Analysis Data Transfer to Php Old 2
select S4 as shop_code,
       S8 as product_name,
       S9 as product_code,
       S10 as account_no,
       to_char(to_date(s1, 'yyyy-mm-dd'), 'yyyy-mm-dd') as sale_date,
       S15 as sales_type,
       N1 as total_sales,
       N2 as quantity,
       Customer_Order_Line_API.Get_Total_Tax_Amount(c.order_no,
                                                    c.line_no,
                                                    c.rel_no,
                                                    c.line_item_no) tax_amount,
       case
         when N2 > 0 THEN
          (N1 -
          Customer_Order_Line_API.Get_Total_Tax_Amount(c.order_no,
                                                        c.line_no,
                                                        c.rel_no,
                                                        c.line_item_no))
         ELSE
          (N1 +
          Customer_Order_Line_API.Get_Total_Tax_Amount(c.order_no,
                                                        c.line_no,
                                                        c.rel_no,
                                                        c.line_item_no))
       END NSP
  from ifsapp.info_services_rpt r,
       (Select d.order_no,
               max(d.line_no) line_no,
               max(d.rel_no) rel_no,
               max(d.line_item_no) line_item_no,
               d.catalog_no
          from customer_order_line d
         group by d.order_no, d.catalog_no) c
 where r.RESULT_KEY =
       (select max(a.RESULT_KEY)
          from IFSAPP.ARCHIVE a
         where a.REPORT_TITLE = 'Sales Analysis Report'
           and a.owner = 'IFSAPP')
   and r.S10 = c.ORDER_NO(+)
   and r.s9 = c.CATALOG_NO(+)

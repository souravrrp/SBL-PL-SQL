--Select Data from Sales Analysis Report using result key + NSP & Tax
select
    r.result_key as result_key,
    r.S4 as shop_code,
    r.S8 as product_name,
    r.S9  as product_code,
    r.S10 as account_no,
    to_char(to_date(r.s1,'yyyy-mm-dd'),'yyyy-mm-dd') as sale_date,
    r.S15 as sales_type,
    r.N1 as total_sales,
    r.N2 as quantity,
    Customer_Order_Line_API.Get_Total_Tax_Amount(c.order_no,c.line_no,c.rel_no,c.line_item_no) tax_amount,
    customer_order_line_api.Get_Sale_Price_Total(c.order_no, c.LINE_NO, c.REL_NO ,c.LINE_ITEM_NO) NSP
from 
  ifsapp.info_services_rpt r,
  (Select  d.order_no, 
      d.line_no, 
      d.line_item_no, 
      d.catalog_no, 
      max(d.rel_no) rel_no
  from customer_order_line d
  group by d.order_no, d.line_no, d.line_item_no, d.catalog_no) c
where r.RESULT_KEY = 7464479
  /*r.result_key = (select max(a.RESULT_KEY) from IFSAPP.ARCHIVE a where a.REPORT_TITLE='Sales Analysis Report' and a.owner = 'IFSAPP')*/
  and r.S10 = c.ORDER_NO(+)
  and r.s9 = c.CATALOG_NO(+)/* AND*/
  --r.s9 like '%REF%'
  --r.S4 = 'LXPB' AND
  --and r.s1 is null
  --AND R.N2>1 and
  /*r.S10 = 'NPZ-H935'*/
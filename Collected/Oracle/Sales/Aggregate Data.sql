--Sales Analysis Report aggregate data
select
    r.result_key as result_key,
    --r.S4 as shop_code,
    --r.S8 as product_name,
    --r.S9  as product_code,
    --r.S10 as account_no,
    --to_char(to_date(r.s1,'yyyy-mm-dd'),'yyyy-mm-dd') as sale_date--,
    --r.S15 as sales_type,
    sum(r.N1) as total_sales,
    sum(r.N2) as quantity--,
    --Customer_Order_Line_API.Get_Total_Tax_Amount(c.order_no,c.line_no,c.rel_no,c.line_item_no) tax_amount,
    --customer_order_line_api.Get_Sale_Price_Total(c.order_no, c.LINE_NO, c.REL_NO ,c.LINE_ITEM_NO) NSP
from 
  ifsapp.info_services_rpt r--,
  --(Select  * from customer_order_line d where d.rel_no=1 ) c
where --r.RESULT_KEY = 3166488
  r.result_key = (select max(a.RESULT_KEY) from IFSAPP.ARCHIVE a where a.REPORT_TITLE='Sales Analysis Report' and a.owner = 'IFSAPP') and
  --r.S10 = c.ORDER_NO(+) and
  --r.s9 = c.CATALOG_NO(+) AND
  r.s9 like '%TV%' and
  r.s4 not in ('BSCP', 'DSCP', 'CSCP', 'JSCP', 'SSCP', 'MS1C', 'MS2C', 'RSCP', 'BTSC', 
    'WSMO', 'SWSS', 'SAOS', 'JWSS', 'SCSM', 'SAPM', 'SESM')
group by r.result_key--, r.s4--, r.s9

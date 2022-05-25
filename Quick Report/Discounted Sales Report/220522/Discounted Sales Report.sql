select 
t.ORDER_NO,
to_char(t.WANTED_DELIVERY_DATE,'dd/mm/yyyy') SALE_DATE,
c.CATALOG_NO,
t.ROWSTATE,
c.buy_qty_due QUANTITY,
customer_order_line_api.Get_Sale_Price_Total(c.order_no, c.LINE_NO, c.REL_NO ,c.LINE_ITEM_NO) SALE_PRICE,
(SELECT SUM(t.discount_amount)
 FROM cust_order_line_discount t 
 WHERE t.order_no = c.order_no
 AND t.line_no = c.LINE_NO
 AND t.rel_no =  c.REL_No
 AND t.line_item_no = c.LINE_ITEM_NO ) DISCOUNT,
 
 (SELECT distinct  t.DISCOUNT_TYPE
 FROM cust_order_line_discount t 
 WHERE t.order_no = c.order_no
 AND t.line_no = c.LINE_NO
 AND t.rel_no =  c.REL_No
 AND t.line_item_no = c.LINE_ITEM_NO ) DISCOUNT_TYPE,
customer_order_line_api.Get_Total_Tax_Amount(c.order_no, c.LINE_NO, c.REL_NO ,c.LINE_ITEM_NO) TAX_PRICE
from
customer_order_tab t,
customer_order_line_tab c
where
c.ORDER_NO = t.ORDER_NO
and t.WANTED_DELIVERY_DATE between to_date('&Date','dd/mm/yyyy') and to_date('&Date1','dd/mm/yyyy')
and cust_ord_customer_api.get_cust_grp(t.CUSTOMER_NO) <> '003'
and t.ROWSTATE in ('Invoiced')
and t.internal_po_no is null
and (SELECT SUM(t.discount_amount)
 FROM cust_order_line_discount t 
 WHERE t.order_no = c.order_no
 AND t.line_no = c.LINE_NO
 AND t.rel_no =  c.REL_No
 AND t.line_item_no = c.LINE_ITEM_NO ) > 0
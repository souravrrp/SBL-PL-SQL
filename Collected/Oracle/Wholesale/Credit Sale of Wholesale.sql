select 
    t.CONTRACT,
    t.ORDER_NO,
    t.pay_term_id,
    trunc(c.ROWVERSION) SALE_DATE,
    c.VENDOR_NO,
    t.CUSTOMER_NO,
    customer_info_api.Get_Name(t.CUSTOMER_NO) CUSTOMER_NAME,
    c.CATALOG_NO,
    c.QTY_SHIPPED,
    customer_order_line_api.Get_Sale_Price_Total(c.order_no, c.LINE_NO, c.REL_NO ,c.LINE_ITEM_NO)*(c.QTY_SHIPPED/c.BUY_QTY_DUE) SALE_PRICE,
    customer_order_line_api.Get_Total_Discount(c.order_no, c.LINE_NO, c.REL_NO ,c.LINE_ITEM_NO)/**(c.QTY_SHIPPED/c.BUY_QTY_DUE)*/  DISCOUNT,
    customer_order_line_api.Get_Total_Tax_Amount(c.order_no, c.LINE_NO, c.REL_NO ,c.LINE_ITEM_NO)*(c.QTY_SHIPPED/c.BUY_QTY_DUE) TAX_AMOUNT,
    (customer_order_line_api.Get_Sale_Price_Total(c.order_no, c.LINE_NO, c.REL_NO ,c.LINE_ITEM_NO)*(c.QTY_SHIPPED/c.BUY_QTY_DUE)) + 
      customer_order_line_api.Get_Total_Tax_Amount(c.order_no, c.LINE_NO, c.REL_NO ,c.LINE_ITEM_NO)*(c.QTY_SHIPPED/c.BUY_QTY_DUE) "AMOUNT(RSP)"--,
    --o.ORDER_NO INTERNAL_PO_NO,
from
  customer_order_tab t,
  customer_order_line_tab c,
  purchase_order_line_tab o
where
  c.ORDER_NO=t.ORDER_NO and 
  t.ORDER_NO=o.DEMAND_ORDER_NO and 
  c.CATALOG_NO=o.PART_NO and 
  trunc(c.ROWVERSION) between to_date('&From_Date','YYYY/MM/DD') and to_date('&To_Date','YYYY/MM/DD') and 
  cust_ord_customer_api.get_cust_grp(t.CUSTOMER_NO) = '003' and 
  c.ROWSTATE in ('Invoiced','PartiallyDelivered') and 
  t.ROWSTATE in ('Invoiced','Delivered','PartiallyDelivered') and 
  customer_order_line_api.Get_Sale_Price_Total(c.order_no, c.LINE_NO, c.REL_NO ,c.LINE_ITEM_NO) > 0 and
  --and  UPPER(t.ORDER_NO) like UPPER('%$ORDER_NO%')
  --and  UPPER(t.CUSTOMER_NO) like UPPER('%$Customer_No%')
  --and UPPER(customer_info_api.Get_Name(t.CUSTOMER_NO)) like UPPER('%$Customer_Name%')
  --and UPPER(c.CATALOG_NO) like UPPER('%$PRODUCT_CODE%')
  --and UPPER(c.VENDOR_NO) like UPPER('%$VENDOR_NO%')
  t.ORDER_NO /*= 'WSM-R9993'*/ in
    (
    select
    L.DEMAND_ORDER_NO
     from IFSAPP.PURCHASE_ORDER_LINE_PART  L
     where L.STATE='Closed'
    ) and 
  o.ORDER_NO in 
    (
    select 
      t2.INTERNAL_PO_NO 
    from
      trn_trip_plan_co_line_tab t3,
      external_customer_order_tab t2
    where 
      t3.ORDER_NO=t2.ORDER_NO
    ) and
  t.pay_term_id like 'CR%' --AND
  --T.ORDER_NO = 'JWS-R2072'
  
order by c.ROWVERSION

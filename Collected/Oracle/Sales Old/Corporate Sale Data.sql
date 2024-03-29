select 
    t.ORDER_NO,
    to_char(t.WANTED_DELIVERY_DATE,'dd-MON-yyyy') SALE_DATE,
    c.CATALOG_NO,
    decode(substr(t.order_no,4,2),'-R','Cash Sale','-H','Hire Sale') ROWSTATE,
    c.buy_qty_due QUANTITY,
    customer_order_line_api.Get_Sale_Price_Total(c.order_no, c.LINE_NO, c.REL_NO ,c.LINE_ITEM_NO) SALE_PRICE,
    (SELECT 
        SUM(t.discount_amount)
      FROM 
        cust_order_line_discount t 
      WHERE 
        t.order_no = c.order_no
        AND t.line_no = c.LINE_NO
        AND t.rel_no =  c.REL_No
        AND t.line_item_no = c.LINE_ITEM_NO ) DISCOUNT,
    customer_order_line_api.Get_Total_Tax_Amount(c.order_no, c.LINE_NO, c.REL_NO ,c.LINE_ITEM_NO) TAX_PRICE , 
    (select 
        distinct h.VAT_RECEIPT
      from 
        IFSAPP.HPNRET_PAY_RECEIPT_head_tab h 
      where 
        h.ACCOUNT_NO=t.ORDER_NO and 
        h.VAT_RECEIPT is not null and 
        ROWNUM <= 1) VAT_RECEIPT,
    (select
        distinct  p.VAT_RECEIPT 
      from  
        hpnret_co_pay_head_tab p ,
        hpnret_co_pay_dtl_tab d
      where 
        p.PAY_NO=d.PAY_NO and 
        d.ORDER_NO= t.order_no and 
        d.PAY_LINE_NO=1 and 
        p.ROWSTATE in ('Approved','Printed') and 
        p.VAT_RECEIPT is not null and 
        ROWNUM <= 1) VAT_RECEIPT2

from
  customer_order_tab t,
  customer_order_line_tab c
where
  c.ORDER_NO = t.ORDER_NO
  and trunc(t.WANTED_DELIVERY_DATE) between to_date('&Date','dd/mm/yyyy') and to_date('&Date1','dd/mm/yyyy')
  --and cust_ord_customer_api.get_cust_grp(t.CUSTOMER_NO) <> '003'
  and customer_order_line_api.Get_Sale_Price_Total(c.order_no, c.LINE_NO, c.REL_NO ,c.LINE_ITEM_NO) <> 0
  and t.ROWSTATE in ('Invoiced')
  --and t.internal_po_no is null
  and c.ORDER_NO not in (select 
      ORDER_NO
    from 
      HPNRET_CUSTOMER_ORDER_TAB r
    where r.ORDER_NO=c.ORDER_NO 
      and r.CASH_CONV='TRUE')
  and c.CONTRACT in ('SCSM', 'SESM', 'SAPM', 'SFSM', 'SISM', 'SHDM')
ORDER BY t.ORDER_NO, SALE_DATE, c.CATALOG_NO


/*union all

select
c.Account_No,
to_char(c.VARIATED_DATE,'dd/mm/yyyy'),
c.CATALOG_NO,
c.ROWSTATE,
(-1)*c.QUANTITY,
(-1)*customer_order_line_api.Get_Sale_Price_Total(c.Account_No, c.REF_LINE_NO, c.REF_REL_NO ,c.REF_LINE_ITEM_NO) SALE_PRICE,
(SELECT SUM(t.discount_amount)
FROM cust_order_line_discount t 
 WHERE t.order_no = c.Account_No
AND t.line_no = c.REF_LINE_NO
AND t.rel_no =  c.REF_REL_No
AND t.line_item_no = c.REF_LINE_ITEM_NO ) DISCOUNT,
(-1)*customer_order_line_api.Get_Total_Tax_Amount(c.Account_No, c.REF_LINE_NO, c.REF_REL_NO ,c.REF_LINE_ITEM_NO) TAX_PRICE,
( select distinct  h.VAT_RECEIPT from IFSAPP.HPNRET_PAY_RECEIPT_head_tab h where h.ACCOUNT_NO=c.ACCOUNT_NO and h.VAT_RECEIPT is not null   and ROWNUM <= 1) VAT_RECEIPT,
'VAT_RECEIPT' VAT_RECEIPT2
from
hpnret_hp_dtl_tab c
where
trunc(c.VARIATED_DATE) between to_date('&Date','dd/mm/yyyy') and to_date('&Date1','dd/mm/yyyy')
and c.ROWSTATE in ('Returned','RevertReversed')
and c.CONTRACT in ('SCSM', 'SESM', 'SAPM', 'SFSM', 'SISM', 'SHDM')

union all

select 
c.ORDER_NO,
to_char(c.DATE_RETURNED,'dd/mm/yyyy'),
c.CATALOG_NO,
c.ROWSTATE,
(-1)*c.qty_returned_inv,
(-1)*customer_order_line_api.Get_Sale_Price_Total(c.order_no, c.LINE_NO, c.REL_NO ,c.LINE_ITEM_NO) SALE_PRICE,
(SELECT SUM(t.discount_amount)
FROM cust_order_line_discount t 
 WHERE t.order_no = c.order_no
AND t.line_no = c.LINE_NO
AND t.rel_no =  c.REL_No
AND t.line_item_no = c.LINE_ITEM_NO ) DISCOUNT,
(-1)*customer_order_line_api.Get_Total_Tax_Amount(c.order_no, c.LINE_NO, c.REL_NO ,c.LINE_ITEM_NO) TAX_PRICE,
( select distinct  h.VAT_RECEIPT from IFSAPP.HPNRET_PAY_RECEIPT_head_tab h where c.ORDER_NO=h.ACCOUNT_NO and h.VAT_RECEIPT is not null  and ROWNUM <= 1) VAT_RECEIPT,
  ( select
   distinct  p.VAT_RECEIPT 
   from  hpnret_co_pay_head_tab p ,
   hpnret_co_pay_dtl_tab d
   where
   p.PAY_NO=d.PAY_NO
   and d.ORDER_NO= c.order_no
   and d.PAY_LINE_NO=1
   and p.ROWSTATE in ('Approved','Printed')  
   and p.VAT_RECEIPT is not null
   and ROWNUM <= 1
   
   ) VAT_RECEIPT2
from
hpnret_sales_ret_line_tab c
where
trunc(c.DATE_RETURNED) between to_date('&Date','dd/mm/yyyy') and to_date('&Date1','dd/mm/yyyy')
and c.ROWSTATE  in ('ReturnCompleted') 
AND SUBSTR(C.ORDER_NO,5,1)='R' 
and c.CONTRACT in ('SCSM', 'SESM', 'SAPM', 'SFSM', 'SISM', 'SHDM')*/

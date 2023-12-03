select
  c.Account_No,
  c.VARIATED_DATE,
  c.CATALOG_NO,
  c.QUANTITY,
  (-1)*customer_order_line_api.Get_Sale_Price_Total(c.Account_No, c.REF_LINE_NO, c.REF_REL_NO ,c.REF_LINE_ITEM_NO) "SALE PRICE",
  (SELECT SUM(t.discount_amount)
     FROM cust_order_line_discount t 
     WHERE t.order_no = c.Account_No
     AND t.line_no = c.REF_LINE_NO
     AND t.rel_no =  c.REF_REL_No
     AND t.line_item_no = c.REF_LINE_ITEM_NO ) "DISCOUNT",
  (-1)*customer_order_line_api.Get_Total_Tax_Amount(c.Account_No, c.REF_LINE_NO, c.REF_REL_NO ,c.REF_LINE_ITEM_NO) "TAX PRICE",
  c.REFERENCE_CO,
  p.DOM_AMOUNT LAST_PAYMENT_AMOUNT,
  (SELECT
    REPLACE(H.RECEIPT_NO,'-C','-LP')
    FROM 
    hpnret_co_pay_head_tab H,
    (select * from hpnret_co_pay_dtl N1 where n1.dom_amount <> 0) N
    WHERE
    H.PAY_NO=N.PAY_NO
    and h.rowstate = 'Printed'
    and n.state = 'Paid'
    AND  N.ORDER_NO=C.REFERENCE_CO) "LPR NO"
from
  hpnret_hp_dtl_tab c,
  (select * from hpnret_co_pay_dtl N1 where n1.dom_amount <> 0) p
where 
  p.ORDER_NO=c.REFERENCE_CO
  and c.VARIATED_DATE between to_date('01/02/2014','dd/mm/yyyy') and to_date('28/02/2014','dd/mm/yyyy')
  --and c.CONTRACT='GSPB'
  and c.ROWSTATE in ('CashConverted')

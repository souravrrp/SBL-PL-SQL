select h.order_no,
    h.contract,
    --h.customer_no,
    l.catalog_no,
    sum(customer_order_line_api.Get_Sale_Price_Total(l.order_no, l.LINE_NO, l.REL_NO ,l.LINE_ITEM_NO)) SALE_PRICE,
    --h.salesman_code,
    --h.vat,
    --h.wanted_delivery_date,
    --h.pay_term_id,
    --h.customer_type,
    --h.sales_type,
    --h.order_category,
    --h.cash_conv,
    --h.vat_receipt,
    --h.orig_sale_date,
    C.ROWSTATE
from HPNRET_CUSTOMER_ORDER_TAB h,
  CUSTOMER_ORDER_TAB C,
  customer_order_line_tab L
WHERE h.ORDER_NO = C.ORDER_NO AND
  h.order_no = l.order_no and 
  h.WANTED_DELIVERY_DATE BETWEEN TO_DATE('2014/1/1', 'YYYY/MM/DD') AND TO_DATE('2014/1/31', 'YYYY/MM/DD') and
  l.create_sm_object_option = 'CREATESMOBJECT'
group by h.contract, h.order_no, l.catalog_no, c.rowstate
order by h.contract, h.order_no
--T.CASH_CONV = 'TRUE'

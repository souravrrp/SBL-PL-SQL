select 
    cl.ORDER_NO ORDER_NO,
    cl.line_no,
    cl.rel_no,
    cl.line_item_no,
    to_char(cl.real_ship_date, 'YYYY/MM/DD') "DATE",
    cl.qty_invoiced QUANTITY,
    cl.base_sale_unit_price,
    cl.dock_code,
    cl.part_no CATALOG_NO,
    cl.catalog_type,
    decode(substr(cl.order_no,4,2),'-R','Cash Sale','-H','Hire Sale') Sale_Type,
    --cl.rowstate line_status,
    --(select co.rowstate from customer_order_tab co where co.order_no = cl.order_no) head_status,
    (select hc.cash_conv from hpnret_customer_order_tab hc where hc.order_no = cl.order_no) cash_conv,
    --cl.demand_order_ref1,
    --cl.fee_code,
    customer_order_line_api.Get_Sale_Price_Total(cl.order_no, cl.LINE_NO, cl.REL_NO ,cl.LINE_ITEM_NO) SALE_PRICE,
    nvl((SELECT 
        SUM(d.discount_amount)
      FROM 
        cust_order_line_discount d 
      WHERE 
        d.order_no = cl.order_no AND 
        d.line_no = cl.LINE_NO AND 
        d.rel_no =  cl.REL_No AND 
        d.line_item_no = cl.LINE_ITEM_NO), 0) DISCOUNT,
    customer_order_line_api.Get_Total_Tax_Amount(cl.order_no, cl.LINE_NO, cl.REL_NO ,cl.LINE_ITEM_NO) TAX_PRICE, 
    (select 
        distinct  h.VAT_RECEIPT 
      from IFSAPP.HPNRET_PAY_RECEIPT_head_tab h 
      where 
        h.ACCOUNT_NO=cl.ORDER_NO and 
        h.VAT_RECEIPT is not null  and 
        ROWNUM <= 1) VAT_RECEIPT,
    (select
        distinct  p.VAT_RECEIPT 
      from
        hpnret_co_pay_head_tab p ,
        hpnret_co_pay_dtl_tab pd
      where
        p.PAY_NO=pd.PAY_NO and 
        pd.ORDER_NO= cl.order_no and 
        pd.PAY_LINE_NO=1 and 
        p.ROWSTATE in ('Approved','Printed') and 
        p.VAT_RECEIPT is not null and 
        ROWNUM <= 1) VAT_RECEIPT2
from
  customer_order_line_tab cl
where
  cl.REAL_SHIP_DATE between to_date('&from_Date','YYYY/MM/DD') and to_date('&to_Date','YYYY/MM/DD') and 
  cl.rowstate = 'Invoiced' and
  --cl.demand_order_ref1 is null and
  --cl.dock_code is null --and 
  --cl.fee_code is not null
  --cust_ord_customer_api.get_cust_grp(cl.CUSTOMER_NO) <> '003' and 
  --customer_order_line_api.Get_Sale_Price_Total(cl.order_no, cl.LINE_NO, cl.REL_NO ,cl.LINE_ITEM_NO) <> 0 and 
  cl.order_no in (select hc.order_no from hpnret_customer_order_tab hc where hc.order_no = cl.order_no and hc.cash_conv = 'TRUE') --and 
  --c.CONTRACT in (select shop_code from shop_dts_info)
order by cl.real_ship_date, cl.order_no, cl.part_no

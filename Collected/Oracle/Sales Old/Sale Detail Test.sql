--List of of Cash & Hire Sale (including Positive HP Variation Accounts)
select 
    cl.ORDER_NO ORDER_NO,
    cl.line_no,
    cl.rel_no,
    cl.line_item_no,
    cl.real_ship_date "DATE",
    cl.qty_invoiced QUANTITY,
    cl.base_sale_unit_price,
    --customer_order_line_api.Get_Base_Sale_Unit_Price(cl.order_no, cl.LINE_NO, cl.REL_NO ,cl.LINE_ITEM_NO),
    cl.dock_code,
    cl.part_no CATALOG_NO,
    cl.catalog_type,    
    decode(substr(cl.order_no,4,2),'-R','Cash Sale','-H','Hire Sale') STATUS /*ROWSTATE*/,
    --cl.rowstate line_status,
    --(select co.rowstate from customer_order_tab co where co.order_no = cl.order_no) head_status,
    --(select hc.cash_conv from hpnret_customer_order_tab hc where hc.order_no = cl.order_no) cash_conv,
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
  cl.demand_order_ref1 is null and
  cl.dock_code is null --and 
  --cl.fee_code is not null
  --cust_ord_customer_api.get_cust_grp(cl.CUSTOMER_NO) <> '003' and 
  --customer_order_line_api.Get_Sale_Price_Total(cl.order_no, cl.LINE_NO, cl.REL_NO ,cl.LINE_ITEM_NO) <> 0 and 
  --cl.order_no in (select co.order_no from customer_order_tab co where co.ROWSTATE = 'Cancelled') and 
  --c.CONTRACT in (select shop_code from shop_dts_info)
--order by cl.real_ship_date, cl.order_no, cl.part_no

union all

--List of RevertReversed Accounts
select
    hd.Account_No ORDER_NO,
    hd.REF_LINE_NO,
    hd.REF_REL_NO,
    hd.REF_LINE_ITEM_NO,
    trunc(hd.VARIATED_DATE) "DATE",
    hd.QUANTITY QUANTITY,
    customer_order_line_api.Get_Base_Sale_Unit_Price(hd.Account_No, hd.REF_LINE_NO, hd.REF_REL_NO, hd.REF_LINE_ITEM_NO) Base_Sale_Unit_Price,
    (SELECT 
          cl.dock_code
        FROM 
          customer_order_line_tab cl
        WHERE 
          cl.order_no = hd.Account_No AND 
          cl.line_no = hd.REF_LINE_NO AND 
          cl.rel_no =  hd.REF_REL_NO AND 
          cl.line_item_no = hd.REF_LINE_ITEM_NO) DOCK_CODE,
    hd.CATALOG_NO CATALOG_NO,
    hd.catalog_type,
    hd.ROWSTATE STATUS,
    customer_order_line_api.Get_Sale_Price_Total(hd.Account_No, hd.REF_LINE_NO, hd.REF_REL_NO, hd.REF_LINE_ITEM_NO) SALE_PRICE,
    nvl((SELECT 
          SUM(d.discount_amount)
        FROM 
          cust_order_line_discount d 
        WHERE 
          d.order_no = hd.Account_No AND 
          d.line_no = hd.REF_LINE_NO AND 
          d.rel_no =  hd.REF_REL_NO AND 
          d.line_item_no = hd.REF_LINE_ITEM_NO), 0) DISCOUNT,
    customer_order_line_api.Get_Total_Tax_Amount(hd.Account_No, hd.REF_LINE_NO, hd.REF_REL_NO, hd.REF_LINE_ITEM_NO) TAX_PRICE,
    (select 
        distinct  h.VAT_RECEIPT 
      from 
        IFSAPP.HPNRET_PAY_RECEIPT_head_tab h
      where 
        h.ACCOUNT_NO=hd.ACCOUNT_NO and 
        h.VAT_RECEIPT is not null and 
        ROWNUM <= 1) VAT_RECEIPT,
    '' VAT_RECEIPT2
from
  hpnret_hp_dtl_tab hd
where
  trunc(hd.VARIATED_DATE) between to_date('&from_date', 'YYYY/MM/DD') and to_date('&to_date', 'YYYY/MM/DD') and 
  hd.ROWSTATE in ('RevertReversed') --and 
  --hd.CONTRACT in (select shop_code from shop_dts_info)


union all

--List of CashConverted, Returned, ExchangedIn Accounts
select
    hd.Account_No ORDER_NO,
    hd.REF_LINE_NO,
    hd.REF_REL_NO,
    hd.REF_LINE_ITEM_NO,
    trunc(hd.VARIATED_DATE) "DATE",
    (-1) * hd.QUANTITY QUANTITY,
    customer_order_line_api.Get_Base_Sale_Unit_Price(hd.Account_No, hd.REF_LINE_NO, hd.REF_REL_NO, hd.REF_LINE_ITEM_NO) Base_Sale_Unit_Price,
    (SELECT 
          cl.dock_code
        FROM 
          customer_order_line_tab cl
        WHERE 
          cl.order_no = hd.Account_No AND 
          cl.line_no = hd.REF_LINE_NO AND 
          cl.rel_no =  hd.REF_REL_NO AND 
          cl.line_item_no = hd.REF_LINE_ITEM_NO) DOCK_CODE,
    hd.CATALOG_NO CATALOG_NO,
    hd.catalog_type,
    hd.ROWSTATE STATUS,
    (-1) * customer_order_line_api.Get_Sale_Price_Total(hd.Account_No, hd.REF_LINE_NO, hd.REF_REL_NO, hd.REF_LINE_ITEM_NO) SALE_PRICE,
    nvl((-1) * (SELECT 
          SUM(d.discount_amount)
        FROM 
          cust_order_line_discount d 
        WHERE 
          d.order_no = hd.Account_No AND 
          d.line_no = hd.REF_LINE_NO AND 
          d.rel_no =  hd.REF_REL_NO AND 
          d.line_item_no = hd.REF_LINE_ITEM_NO), 0) DISCOUNT,
    (-1)* customer_order_line_api.Get_Total_Tax_Amount(hd.Account_No, hd.REF_LINE_NO, hd.REF_REL_NO, hd.REF_LINE_ITEM_NO) TAX_PRICE,
    (select 
        distinct  h.VAT_RECEIPT 
      from 
        IFSAPP.HPNRET_PAY_RECEIPT_head_tab h
      where 
        h.ACCOUNT_NO=hd.ACCOUNT_NO and 
        h.VAT_RECEIPT is not null and 
        ROWNUM <= 1) VAT_RECEIPT,
    '' VAT_RECEIPT2
from
  hpnret_hp_dtl_tab hd
where
  trunc(hd.VARIATED_DATE) between to_date('&from_date', 'YYYY/MM/DD') and to_date('&to_date', 'YYYY/MM/DD') and 
  hd.ROWSTATE in ('CashConverted', 'Returned', 'Reverted', 'ExchangedIn') --and 
  --hd.CONTRACT in (select shop_code from shop_dts_info)

union all

--List of Reverted Accounts
select
    hd.Account_No ORDER_NO,
    hd.REF_LINE_NO,
    hd.REF_REL_NO,
    hd.REF_LINE_ITEM_NO,
    trunc(hd.reverted_date) "DATE",
    (-1) * hd.QUANTITY QUANTITY,
    customer_order_line_api.Get_Base_Sale_Unit_Price(hd.Account_No, hd.REF_LINE_NO, hd.REF_REL_NO, hd.REF_LINE_ITEM_NO) Base_Sale_Unit_Price,
    (SELECT 
          cl.dock_code
        FROM 
          customer_order_line_tab cl
        WHERE 
          cl.order_no = hd.Account_No AND 
          cl.line_no = hd.REF_LINE_NO AND 
          cl.rel_no =  hd.REF_REL_NO AND 
          cl.line_item_no = hd.REF_LINE_ITEM_NO) DOCK_CODE,
    hd.CATALOG_NO CATALOG_NO,
    hd.catalog_type,
    hd.ROWSTATE STATUS,
    (-1) * customer_order_line_api.Get_Sale_Price_Total(hd.Account_No, hd.REF_LINE_NO, hd.REF_REL_NO, hd.REF_LINE_ITEM_NO) SALE_PRICE,
    nvl((-1) * (SELECT 
          SUM(d.discount_amount)
        FROM 
          cust_order_line_discount d 
        WHERE 
          d.order_no = hd.Account_No AND 
          d.line_no = hd.REF_LINE_NO AND 
          d.rel_no =  hd.REF_REL_NO AND 
          d.line_item_no = hd.REF_LINE_ITEM_NO), 0) DISCOUNT,
    (-1)* customer_order_line_api.Get_Total_Tax_Amount(hd.Account_No, hd.REF_LINE_NO, hd.REF_REL_NO, hd.REF_LINE_ITEM_NO) TAX_PRICE,
    (select 
        distinct  h.VAT_RECEIPT 
      from 
        IFSAPP.HPNRET_PAY_RECEIPT_head_tab h
      where 
        h.ACCOUNT_NO=hd.ACCOUNT_NO and 
        h.VAT_RECEIPT is not null and 
        ROWNUM <= 1) VAT_RECEIPT,
    '' VAT_RECEIPT2
from
  hpnret_hp_dtl_tab hd
where
  trunc(hd.reverted_date) between to_date('&from_date', 'YYYY/MM/DD') and to_date('&to_date', 'YYYY/MM/DD') and 
  hd.ROWSTATE in ('Reverted') --and 
  --hd.CONTRACT in (select shop_code from shop_dts_info)

union all

--List of Cash Sale return accounts
select 
    sr.ORDER_NO ORDER_NO,
    sr.line_no,
    sr.rel_no,
    sr.line_item_no,
    trunc(sr.DATE_RETURNED) "DATE",
    (-1) * sr.qty_returned_inv QUANTITY,
    customer_order_line_api.Get_Base_Sale_Unit_Price(sr.order_no, sr.LINE_NO, sr.REL_NO ,sr.LINE_ITEM_NO) Base_Sale_Unit_Price,
    (SELECT 
          cl.dock_code
        FROM 
          customer_order_line_tab cl
        WHERE 
          cl.order_no = sr.ORDER_NO AND 
          cl.line_no = sr.LINE_NO AND 
          cl.rel_no =  sr.REL_NO AND 
          cl.line_item_no = sr.LINE_ITEM_NO) DOCK_CODE,
    sr.CATALOG_NO CATALOG_NO,
    (SELECT 
          cl.catalog_type
        FROM 
          customer_order_line_tab cl
        WHERE 
          cl.order_no = sr.ORDER_NO AND 
          cl.line_no = sr.LINE_NO AND 
          cl.rel_no =  sr.REL_NO AND 
          cl.line_item_no = sr.LINE_ITEM_NO) CATALOG_TYPE,
    sr.ROWSTATE STATUS,
    (-1) * customer_order_line_api.Get_Sale_Price_Total(sr.order_no, sr.LINE_NO, sr.REL_NO ,sr.LINE_ITEM_NO) SALE_PRICE,
    nvl((SELECT 
        SUM(d.discount_amount)
      FROM 
        cust_order_line_discount d
      WHERE 
        d.order_no = sr.order_no AND 
        d.line_no = sr.LINE_NO AND 
        d.rel_no =  sr.REL_No AND 
        d.line_item_no = sr.LINE_ITEM_NO), 0) DISCOUNT,
    (-1) * customer_order_line_api.Get_Total_Tax_Amount(sr.order_no, sr.LINE_NO, sr.REL_NO ,sr.LINE_ITEM_NO) TAX_PRICE,
    (select 
        distinct h.VAT_RECEIPT 
      from 
        IFSAPP.HPNRET_PAY_RECEIPT_head_tab h 
      where 
        h.ACCOUNT_NO = sr.ORDER_NO and 
        h.VAT_RECEIPT is not null and 
        ROWNUM <= 1) VAT_RECEIPT,
    (select
        distinct p.VAT_RECEIPT 
      from 
        hpnret_co_pay_head_tab p,
        hpnret_co_pay_dtl_tab pd
      where
        p.PAY_NO = pd.PAY_NO and 
        pd.ORDER_NO = sr.order_no and 
        pd.PAY_LINE_NO = 1 and 
        p.ROWSTATE in ('Approved','Printed') and 
        p.VAT_RECEIPT is not null and 
        ROWNUM <= 1) VAT_RECEIPT2
from
  hpnret_sales_ret_line_tab sr
where
  trunc(sr.DATE_RETURNED) between to_date('&from_date','YYYY/MM/DD') and to_date('&to_Date','YYYY/MM/DD') and 
  sr.ROWSTATE  in ('ReturnCompleted') AND 
  SUBSTR(sr.ORDER_NO, 5, 1) = 'R' --and 
  --c.CONTRACT in (select shop_code from shop_dts_info)

order by "DATE", ORDER_NO, CATALOG_NO

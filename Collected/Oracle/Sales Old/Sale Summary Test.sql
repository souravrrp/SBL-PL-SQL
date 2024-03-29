--Sum of Cash & Hire Sale (including Positive HP Variation Accounts)
select 
    sum(cl.base_sale_unit_price) base_sale_unit_price,
    sum(customer_order_line_api.Get_Sale_Price_Total(cl.order_no, cl.LINE_NO, cl.REL_NO ,cl.LINE_ITEM_NO)) SALE_PRICE,
    sum(nvl((SELECT 
        SUM(d.discount_amount)
      FROM 
        cust_order_line_discount d 
      WHERE 
        d.order_no = cl.order_no AND 
        d.line_no = cl.LINE_NO AND 
        d.rel_no =  cl.REL_No AND 
        d.line_item_no = cl.LINE_ITEM_NO), 0)) DISCOUNT,
    sum(customer_order_line_api.Get_Total_Tax_Amount(cl.order_no, cl.LINE_NO, cl.REL_NO ,cl.LINE_ITEM_NO)) TAX_PRICE
from
  customer_order_line_tab cl
where
  cl.REAL_SHIP_DATE between to_date('&from_Date','YYYY/MM/DD') and to_date('&to_Date','YYYY/MM/DD') and 
  cl.rowstate = 'Invoiced' and
  cl.demand_order_ref1 is null and
  cl.dock_code is null
  --cl.fee_code is not null --and 
  --c.CONTRACT in (select shop_code from shop_dts_info)

union all

--Sum of RevertReversed
select
    sum(customer_order_line_api.Get_Base_Sale_Unit_Price(hd.Account_No, hd.REF_LINE_NO, hd.REF_REL_NO, hd.REF_LINE_ITEM_NO)) Base_Sale_Unit_Price,
    sum(customer_order_line_api.Get_Sale_Price_Total(hd.Account_No, hd.REF_LINE_NO, hd.REF_REL_NO, hd.REF_LINE_ITEM_NO)) SALE_PRICE,
    sum(nvl((SELECT 
          SUM(d.discount_amount)
        FROM 
          cust_order_line_discount d 
        WHERE 
          d.order_no = hd.Account_No AND 
          d.line_no = hd.REF_LINE_NO AND 
          d.rel_no =  hd.REF_REL_NO AND 
          d.line_item_no = hd.REF_LINE_ITEM_NO), 0)) DISCOUNT,
    sum(customer_order_line_api.Get_Total_Tax_Amount(hd.Account_No, hd.REF_LINE_NO, hd.REF_REL_NO, hd.REF_LINE_ITEM_NO)) TAX_PRICE
from
  hpnret_hp_dtl_tab hd
where
  trunc(hd.VARIATED_DATE) between to_date('&from_date', 'YYYY/MM/DD') and to_date('&to_date', 'YYYY/MM/DD') and 
  hd.ROWSTATE in ('RevertReversed') --and 
  --hd.CONTRACT in (select shop_code from shop_dts_info)

union all

--Sum of CashConverted, Returned, & ExchangedIn (-)
select
    sum(customer_order_line_api.Get_Base_Sale_Unit_Price(hd.Account_No, hd.REF_LINE_NO, hd.REF_REL_NO, hd.REF_LINE_ITEM_NO)) Base_Sale_Unit_Price,
    sum((-1) * customer_order_line_api.Get_Sale_Price_Total(hd.Account_No, hd.REF_LINE_NO, hd.REF_REL_NO, hd.REF_LINE_ITEM_NO)) SALE_PRICE,
    sum((-1) * nvl((SELECT 
          SUM(d.discount_amount)
        FROM 
          cust_order_line_discount d 
        WHERE 
          d.order_no = hd.Account_No AND 
          d.line_no = hd.REF_LINE_NO AND 
          d.rel_no =  hd.REF_REL_NO AND 
          d.line_item_no = hd.REF_LINE_ITEM_NO), 0)) DISCOUNT,
    sum((-1)* customer_order_line_api.Get_Total_Tax_Amount(hd.Account_No, hd.REF_LINE_NO, hd.REF_REL_NO, hd.REF_LINE_ITEM_NO)) TAX_PRICE
from
  hpnret_hp_dtl_tab hd
where
  trunc(hd.VARIATED_DATE) between to_date('&from_date', 'YYYY/MM/DD') and to_date('&to_date', 'YYYY/MM/DD') and 
  hd.ROWSTATE in ('CashConverted', 'Returned', 'ExchangedIn') --and 
  --hd.CONTRACT in (select shop_code from shop_dts_info)

union all

--Sum of Reverted (-)
select
    sum(customer_order_line_api.Get_Base_Sale_Unit_Price(hd.Account_No, hd.REF_LINE_NO, hd.REF_REL_NO, hd.REF_LINE_ITEM_NO)) Base_Sale_Unit_Price,
    sum((-1) * customer_order_line_api.Get_Sale_Price_Total(hd.Account_No, hd.REF_LINE_NO, hd.REF_REL_NO, hd.REF_LINE_ITEM_NO)) SALE_PRICE,
    sum((-1) * nvl((SELECT 
          SUM(d.discount_amount)
        FROM 
          cust_order_line_discount d 
        WHERE 
          d.order_no = hd.Account_No AND 
          d.line_no = hd.REF_LINE_NO AND 
          d.rel_no =  hd.REF_REL_NO AND 
          d.line_item_no = hd.REF_LINE_ITEM_NO), 0)) DISCOUNT,
    sum((-1)* customer_order_line_api.Get_Total_Tax_Amount(hd.Account_No, hd.REF_LINE_NO, hd.REF_REL_NO, hd.REF_LINE_ITEM_NO)) TAX_PRICE
from
  hpnret_hp_dtl_tab hd
where
  trunc(hd.reverted_date) between to_date('&from_date', 'YYYY/MM/DD') and to_date('&to_date', 'YYYY/MM/DD') and 
  hd.ROWSTATE in ('Reverted') --and 
  --hd.CONTRACT in (select shop_code from shop_dts_info)

union all

--Sum of Cash Sale Return (-)
select 
    sum(customer_order_line_api.Get_Base_Sale_Unit_Price(sr.order_no, sr.LINE_NO, sr.REL_NO ,sr.LINE_ITEM_NO)) Base_Sale_Unit_Price,
    sum((-1) * customer_order_line_api.Get_Sale_Price_Total(sr.order_no, sr.LINE_NO, sr.REL_NO ,sr.LINE_ITEM_NO)) SALE_PRICE,
    sum(nvl((-1) * (SELECT 
        SUM(d.discount_amount)
      FROM 
        cust_order_line_discount d
      WHERE 
        d.order_no = sr.order_no AND 
        d.line_no = sr.LINE_NO AND 
        d.rel_no =  sr.REL_No AND 
        d.line_item_no = sr.LINE_ITEM_NO), 0)) DISCOUNT,
    sum((-1) * customer_order_line_api.Get_Total_Tax_Amount(sr.order_no, sr.LINE_NO, sr.REL_NO ,sr.LINE_ITEM_NO)) TAX_PRICE
from
  hpnret_sales_ret_line_tab sr
where
  trunc(sr.DATE_RETURNED) between to_date('&from_date','YYYY/MM/DD') and to_date('&to_Date','YYYY/MM/DD') and 
  sr.ROWSTATE  in ('ReturnCompleted') AND 
  SUBSTR(sr.ORDER_NO, 5, 1) = 'R' --and 
  --c.CONTRACT in (select shop_code from shop_dts_info)

--order by "DATE", ORDER_NO, CATALOG_NO

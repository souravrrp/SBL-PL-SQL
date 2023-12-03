CREATE OR REPLACE VIEW SBL_JR_VW_ALL_CNL_SALES_SUMM AS
--*****Retail Sales
SELECT IPV.SALES_DATE,
       SUM(IPV.SALES_PRICE) SALES_PRICE,
       'Retail' Sales_Channel
  FROM SBL_JR_SALES_INV_PKG_VIEW IPV
 GROUP BY IPV.SALES_DATE

UNION ALL  

--*****Wholesale Sales 
SELECT W.SALES_DATE,
       SUM(W.SALES_PRICE) SALES_PRICE,
       'Wholesale' Sales_Channel
  FROM IFSAPP.SBL_VW_WHOLESALE_SALES W
 WHERE W.SITE in ('JWSS', 'SAOS', 'SWSS', 'WSMO')
 GROUP BY W.SALES_DATE

UNION ALL

--*****Corporate Sales
SELECT C.SALES_DATE,
       SUM(C.SALES_PRICE) SALES_PRICE,
       'Corporate' Sales_Channel
  FROM IFSAPP.SBL_VW_WHOLESALE_SALES C
 WHERE C.SITE = 'SCSM'
 GROUP BY C.SALES_DATE

UNION ALL

--*****Staff, Online & Scrap Sales
select i.invoice_date SALES_DATE,
       SUM(t.net_curr_amount) SALES_PRICE,
       'Staff_Online_Scrap' Sales_Channel
  from ifsapp.invoice_item_tab t, ifsapp.INVOICE_TAB i
 where t.invoice_id = i.invoice_id
   and t.creator = 'CUSTOMER_ORDER_INV_ITEM_API'
   and t.rowstate = 'Posted'
   and IFSAPP.SALES_PART_API.Get_Catalog_Type(T.C5) in ('INV', 'PKG')
   and t.c10 in ('SAPM', 'SESM', 'SHOM', 'SISM', 'SFSM', 'SOSM') -- Employee, Online & Scrap Sites
   and t.net_curr_amount != 0
 GROUP BY i.invoice_date
   

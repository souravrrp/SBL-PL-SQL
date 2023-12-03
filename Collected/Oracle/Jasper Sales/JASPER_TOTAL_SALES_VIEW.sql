CREATE OR REPLACE VIEW JASPER_TOTAL_SALES_VIEW 
AS
--Retails sale
SELECT IPV.SALES_DATE, 
           sum(IPV.SALES_PRICE) SALES_PRICE,
           'Retail_Sale' Sales_Channel
  FROM SBL_JR_SALES_INV_PKG_VIEW IPV
 /*WHERE*/ /*IPV.SALES_DATE between to_date('&from_date', 'yyyy/mm/dd') and
       to_date('&to_date', 'yyyy/mm/dd')
   AND */
  group by  IPV.SALES_DATE 
UNION ALL  
  --------------wholesale and corporate 
  SELECT 
       W.SALES_DATE,
      sum(W.SALES_PRICE) SALES_PRICE,
       'Wholesale_And_Corporate' Sales_Channel
  FROM ifsapp.sbl_vw_wholesale_sales W
 WHERE  W.SITE in ('JWSS', 'SAOS', 'SCSM', 'SWSS', 'WSMO')
   /*AND W.SALES_DATE between to_date('&from_date', 'yyyy/mm/dd') and
       to_date('&to_date', 'yyyy/mm/dd')*/
   group by W.SALES_DATE  
UNION ALL  
  -----------------------------------Employee, & Scrap Sites 
  select 
       i.invoice_date SALES_DATE,
       SUM(t.net_curr_amount) SALES_PRICE,
       'Employee_And_Scrap' Sales_Channel
  from ifsapp.invoice_item_tab t, ifsapp.INVOICE_TAB i
 where t.invoice_id = i.invoice_id
   and t.creator = 'CUSTOMER_ORDER_INV_ITEM_API'
   and t.rowstate = 'Posted'
   and IFSAPP.SALES_PART_API.Get_Catalog_Type(T.C5) in('INV', 'PKG'/*, 'NON'*/)
   and t.c10 in ('SAPM','SESM', 'SHOM', 'SISM', 'SFSM') -- Employee, & Scrap Sites
  /* and i.invoice_date between to_date('&from_date', 'yyyy/mm/dd') and
       to_date('&to_date', 'yyyy/mm/dd')*/
   and t.net_curr_amount != 0
 GROUP BY i.invoice_date
   

CREATE OR REPLACE VIEW SBL_JR_VW_ALL_CNL_PF_SALE_SUMM AS
--*****Retail Sales
SELECT IPV.SALES_DATE,
       DI.PRODUCT_FAMILY PRODUCT_GROUP,
       IPV.PRODUCT_CODE,
       IPV.SALES_PRICE,
       IPV.SALES_QUANTITY,
       'Retail' Sales_Channel
  FROM IFSAPP.SBL_JR_SALES_INV_COMP_VIEW IPV, IFSAPP.SBL_JR_PRODUCT_DTL_INFO DI
 WHERE IPV.PRODUCT_CODE = DI.PRODUCT_CODE

UNION ALL  

--*****Wholesale Sales
SELECT W.SALES_DATE,
       DI.PRODUCT_FAMILY PRODUCT_GROUP,
       W.PRODUCT_CODE,
       W.SALES_PRICE,
       W.SALES_QUANTITY,
       'Wholesale' Sales_Channel
  FROM ifsapp.sbl_vw_wholesale_sales W, IFSAPP.SBL_JR_PRODUCT_DTL_INFO DI
 WHERE W.PRODUCT_CODE = DI.Product_Code
   AND W.SITE in ('JWSS', 'SAOS', 'SWSS', 'WSMO')

UNION ALL  

--*****Corporate Sales
SELECT C.SALES_DATE,
       DI.PRODUCT_FAMILY PRODUCT_GROUP,
       C.PRODUCT_CODE,
       C.SALES_PRICE,
       C.SALES_QUANTITY,
       'Corporate' Sales_Channel
  FROM ifsapp.sbl_vw_wholesale_sales C, IFSAPP.SBL_JR_PRODUCT_DTL_INFO DI
 WHERE C.PRODUCT_CODE = DI.Product_Code
   AND C.SITE = 'SCSM'

UNION ALL
  
--*****Staff, Online & Scrap Sales 
SELECT i.invoice_date SALES_DATE,
       ifsapp.INVENTORY_PRODUCT_FAMILY_API.Get_Description(ifsapp.inventory_part_api.Get_Part_Product_Family('SCOM',
                                                                                                             t.c5)) PRODUCT_GROUP,
       t.c5 PRODUCT_CODE,
       t.net_curr_amount SALES_PRICE,
       case
         when t.net_curr_amount != 0 then
          (t.n2 * (t.net_curr_amount / abs(t.net_curr_amount)))
         else
          IFSAPP.GET_SBL_FREE_ITEM_SALES_QTN(t.invoice_id, t.item_id, T.N2)
       end SALES_QUANTITY,
       'Staff_Online_Scrap' Sales_Channel
  from ifsapp.invoice_item_tab t, ifsapp.INVOICE_TAB i
 where t.invoice_id = i.invoice_id
   and t.creator = 'CUSTOMER_ORDER_INV_ITEM_API'
   and t.rowstate = 'Posted'
   and IFSAPP.SALES_PART_API.Get_Catalog_Type(T.C5) in ('INV', 'PKG')
   and t.c10 in ('SAPM', 'SESM', 'SHOM', 'SISM', 'SFSM', 'SOSM') -- Employee, Online & Scrap Sites
   /*and t.net_curr_amount != 0*/

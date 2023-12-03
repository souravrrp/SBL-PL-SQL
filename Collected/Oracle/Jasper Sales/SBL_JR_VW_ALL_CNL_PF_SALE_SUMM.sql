CREATE OR REPLACE VIEW SBL_JR_VW_ALL_CNL_PF_SALE_SUMM AS
--*****Retail Sales
SELECT IPV.SALES_DATE,
       DI.PRODUCT_FAMILY PRODUCT_GROUP,
       IPV.PRODUCT_CODE,
       IPV.SALES_PRICE,
       IPV.SALES_QUANTITY,
       'RETAIL' Sales_Channel
  FROM IFSAPP.SBL_JR_SALES_INV_COMP_VIEW IPV, IFSAPP.SBL_JR_PRODUCT_DTL_INFO DI
 WHERE IPV.PRODUCT_CODE = DI.PRODUCT_CODE

UNION ALL  

--*****Wholesale Sales
SELECT W.SALES_DATE,
       DI.PRODUCT_FAMILY PRODUCT_GROUP,
       W.PRODUCT_CODE,
       W.SALES_PRICE,
       W.SALES_QUANTITY,
       'WHOLESALE' Sales_Channel
  FROM ifsapp.SBL_VW_WHOLESALE_SALES_NEW W, IFSAPP.SBL_JR_PRODUCT_DTL_INFO DI
 WHERE W.PRODUCT_CODE = DI.Product_Code
   AND W.SITE in ('JWSS', 'SAOS', 'SWSS', 'WSMO', 'SITM', 'SSAM', 'WITM')

UNION ALL  

--*****Corporate Sales
SELECT C.SALES_DATE,
       DI.PRODUCT_FAMILY PRODUCT_GROUP,
       C.PRODUCT_CODE,
       C.SALES_PRICE,
       C.SALES_QUANTITY,
       'CORPORATE' Sales_Channel
  FROM ifsapp.SBL_VW_WHOLESALE_SALES_NEW C, IFSAPP.SBL_JR_PRODUCT_DTL_INFO DI
 WHERE C.PRODUCT_CODE = DI.Product_Code
   AND C.SITE = 'SCSM'

UNION ALL
  
--*****Staff, Online & Scrap Sales 
SELECT O.SALES_DATE,
       O.PRODUCT_GROUP,
       O.PRODUCT_CODE,
       O.SALES_PRICE,
       O.SALES_QUANTITY,
       'STAFF ONLINE & SCRAP' Sales_Channel
  FROM (select I.SALES_DATE,
               DI.PRODUCT_FAMILY PRODUCT_GROUP,
               I.PRODUCT_CODE,
               I.SALES_PRICE,
               I.SALES_QUANTITY
          from IFSAPP.SBL_JR_SALES_DTL_INV    I,
               IFSAPP.SBL_JR_PRODUCT_DTL_INFO DI
         WHERE I.PRODUCT_CODE = DI.PRODUCT_CODE
           AND I.SITE in ('SAPM', 'SESM', 'SHOM', 'SISM', 'SFSM', 'SOSM')
        
        UNION ALL
        
        select M.SALES_DATE,
               DI.PRODUCT_FAMILY PRODUCT_GROUP,
               M.PRODUCT_CODE,
               M.SALES_PRICE,
               M.SALES_QUANTITY
          from IFSAPP.SBL_JR_SALES_DTL_PKG_COMP M,
               IFSAPP.SBL_JR_PRODUCT_DTL_INFO   DI
         WHERE M.PRODUCT_CODE = DI.PRODUCT_CODE
           AND M.SITE IN ('SAPM', 'SESM', 'SHOM', 'SISM', 'SFSM', 'SOSM')) O

CREATE OR REPLACE VIEW SBL_JR_VW_ALL_CNL_SALES_SUMM AS
--*****Retail Sales
SELECT IPV.SALES_DATE,
       SUM(IPV.SALES_PRICE) SALES_PRICE,
       'Retail' Sales_Channel
  FROM SBL_JR_SALES_INV_PKG_VIEW IPV
 GROUP BY IPV.SALES_DATE

UNION ALL

--*****Wholesale Sales 
select W.SALES_DATE,
       SUM(W.SALES_PRICE) SALES_PRICE,
       'Wholesale' Sales_Channel
  from IFSAPP.SBL_JR_SALES_DTL_INV W
 WHERE W.SITE IN ('JWSS', 'SAOS', 'SWSS', 'WSMO')
 GROUP BY W.SALES_DATE

UNION ALL

--*****Corporate Sales
select C.SALES_DATE,
       SUM(C.SALES_PRICE) SALES_PRICE,
       'Corporate' Sales_Channel
  from IFSAPP.SBL_JR_SALES_DTL_INV C
 WHERE C.SITE = 'SCSM'
 GROUP BY C.SALES_DATE

UNION ALL

--*****Staff, Online & Scrap Sales
SELECT O.SALES_DATE, SUM(O.SALES_PRICE), 'Staff_Online_Scrap' Sales_Channel
  FROM (select I.SALES_DATE, SUM(I.SALES_PRICE) SALES_PRICE
          from IFSAPP.SBL_JR_SALES_DTL_INV I
         WHERE I.SITE in ('SAPM', 'SESM', 'SHOM', 'SISM', 'SFSM', 'SOSM')
         GROUP BY I.SALES_DATE
        
        UNION ALL
        
        select P.SALES_DATE, SUM(P.SALES_PRICE) SALES_PRICE
          from IFSAPP.SBL_JR_SALES_DTL_PKG P
         where P.site in ('SAPM', 'SESM', 'SHOM', 'SISM', 'SFSM', 'SOSM')
         GROUP BY P.SALES_DATE) O
 GROUP BY O.SALES_DATE
   

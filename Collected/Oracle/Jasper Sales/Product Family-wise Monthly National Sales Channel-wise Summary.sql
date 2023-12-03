--Product Family-wise Monthly National Sales Channel-wise Summary
--*****Retail Sales
SELECT EXTRACT(YEAR FROM C.SALES_DATE) "YEAR",
       EXTRACT(MONTH FROM C.SALES_DATE) PERIOD,
       'Retail' Sales_Channel,
       P.PRODUCT_FAMILY,
       SUM(C.SALES_QUANTITY) SALES_QUANTITY
  FROM SBL_JR_SALES_INV_COMP_VIEW C
 INNER JOIN IFSAPP.SBL_JR_PRODUCT_DTL_INFO P
    ON C.PRODUCT_CODE = P.PRODUCT_CODE
 WHERE C.SALES_DATE BETWEEN TO_DATE('&FROM_DATE', 'YYYY/MM/DD') AND
       TO_DATE('&TO_DATE', 'YYYY/MM/DD')
   AND C.SALES_PRICE != 0
   AND P.PRODUCT_FAMILY IN
       ('OVEN-MICROWAVE', 'WASHING-MACHINE-TOP-LOADER', 'RICE-COOKER')
 GROUP BY EXTRACT(YEAR FROM C.SALES_DATE),
          EXTRACT(MONTH FROM C.SALES_DATE),
          P.PRODUCT_FAMILY

UNION ALL

--*****Wholesale Sales 
SELECT EXTRACT(YEAR FROM I.SALES_DATE) "YEAR",
       EXTRACT(MONTH FROM I.SALES_DATE) PERIOD,
       'Wholesale' Sales_Channel,
       P.PRODUCT_FAMILY,
       SUM(I.SALES_QUANTITY) SALES_QUANTITY
  FROM IFSAPP.SBL_JR_SALES_DTL_INV I
 INNER JOIN IFSAPP.SBL_JR_PRODUCT_DTL_INFO P
    ON I.PRODUCT_CODE = P.PRODUCT_CODE
 WHERE I.SITE IN ('JWSS', 'SAOS', 'SWSS', 'WSMO')
   AND I.SALES_DATE BETWEEN TO_DATE('&FROM_DATE', 'YYYY/MM/DD') AND
       TO_DATE('&TO_DATE', 'YYYY/MM/DD')
   AND I.SALES_PRICE != 0
   AND P.PRODUCT_FAMILY IN
       ('OVEN-MICROWAVE', 'WASHING-MACHINE-TOP-LOADER', 'RICE-COOKER')
 GROUP BY EXTRACT(YEAR FROM I.SALES_DATE),
          EXTRACT(MONTH FROM I.SALES_DATE),
          P.PRODUCT_FAMILY

UNION ALL

--*****Corporate Sales
SELECT EXTRACT(YEAR FROM I.SALES_DATE) "YEAR",
       EXTRACT(MONTH FROM I.SALES_DATE) PERIOD,
       'Corporate' Sales_Channel,
       P.PRODUCT_FAMILY,
       SUM(I.SALES_QUANTITY) SALES_QUANTITY
  FROM IFSAPP.SBL_JR_SALES_DTL_INV I
 INNER JOIN IFSAPP.SBL_JR_PRODUCT_DTL_INFO P
    ON I.PRODUCT_CODE = P.PRODUCT_CODE
 WHERE I.SITE = 'SCSM'
   AND I.SALES_DATE BETWEEN TO_DATE('&FROM_DATE', 'YYYY/MM/DD') AND
       TO_DATE('&TO_DATE', 'YYYY/MM/DD')
   AND I.SALES_PRICE != 0
   AND P.PRODUCT_FAMILY IN
       ('OVEN-MICROWAVE', 'WASHING-MACHINE-TOP-LOADER', 'RICE-COOKER')
 GROUP BY EXTRACT(YEAR FROM I.SALES_DATE),
          EXTRACT(MONTH FROM I.SALES_DATE),
          P.PRODUCT_FAMILY

UNION ALL

--*****Staff, Online & Scrap Sales
SELECT EXTRACT(YEAR FROM I.SALES_DATE) "YEAR",
       EXTRACT(MONTH FROM I.SALES_DATE) PERIOD,
       'Staff_Online_Scrap' Sales_Channel,
       P.PRODUCT_FAMILY,
       SUM(I.SALES_QUANTITY) SALES_QUANTITY
  FROM IFSAPP.SBL_JR_SALES_DTL_INV I
 INNER JOIN IFSAPP.SBL_JR_PRODUCT_DTL_INFO P
    ON I.PRODUCT_CODE = P.PRODUCT_CODE
 WHERE I.SITE IN ('SAPM', 'SESM', 'SHOM', 'SISM', 'SFSM', 'SOSM')
   AND I.SALES_DATE BETWEEN TO_DATE('&FROM_DATE', 'YYYY/MM/DD') AND
       TO_DATE('&TO_DATE', 'YYYY/MM/DD')
   AND I.SALES_PRICE != 0
   AND P.PRODUCT_FAMILY IN
       ('OVEN-MICROWAVE', 'WASHING-MACHINE-TOP-LOADER', 'RICE-COOKER')
 GROUP BY EXTRACT(YEAR FROM I.SALES_DATE),
          EXTRACT(MONTH FROM I.SALES_DATE),
          P.PRODUCT_FAMILY
 ORDER BY 1, 2, 4, 3
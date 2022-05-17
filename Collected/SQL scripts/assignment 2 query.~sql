SELECT AREA_CODE,DISTRICT_CODE, SUM(SALES_PRICE)AS TOTAL_REVENUE
FROM ifsapp.shop_dts_info d
INNER JOIN (SELECT *
               FROM ifsapp.sbl_jr_sales_dtl_inv i
             UNION ALL
             SELECT * FROM ifsapp.sbl_jr_sales_dtl_pkg_comp c) s
ON d.SHOP_CODE=s.SITE
WHERE s.SALES_DATE BETWEEN TO_DATE('10/11/2017','MM/DD/YYYY') AND TO_DATE('10/11/2020','MM/DD/YYYY')
AND s.status not in ('CashConverted','PositiveCashConv','TransferAccount','PositiveTransferAccount')
AND AREA_CODE IN ('CENTRAL-A') 
AND DISTRICT_CODE IN ('1','2','3')
GROUP BY d.DISTRICT_CODE, d.AREA_CODE
ORDER BY CAST(DISTRICT_CODE AS INT)

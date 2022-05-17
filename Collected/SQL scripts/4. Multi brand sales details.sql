SELECT v.SHOP_CODE,
       v.AREA_CODE, 
       v.DISTRICT_CODE, 
       v.ORDER_NO, 
       v.SALES_DATE, 
       v.STATUS, 
       v.PRODUCT_CODE, 
       v.SALES_QUANTITY, 
       v.SALES_PRICE, 
       v.AMOUNT_RSP,
       p.brand, p.product_family
FROM ifsapp.sbl_jr_sales_inv_comp_view v
INNER JOIN  ifsapp.sbl_jr_product_dtl_info p
ON v.PRODUCT_CODE=p.product_code
WHERE v.sales_date BETWEEN TO_DATE('&FROM_DATE', 'YYYY/MM/DD') AND
       TO_DATE('&TO_DATE', 'YYYY/MM/DD')
   AND p.brand NOT IN ('Singer', 'Merritt', 'Singtech', 'Sinotec')
   AND p.product_family NOT IN ('GIFT', 'Raw Material')
   AND p.product_code != 'SGCOM-LED-18.5'
   AND v.AREA_CODE='&AREA_CODE'
   AND v.district_code='&DISTRICT_CODE'
ORDER BY to_number(v.district_code), v.shop_code

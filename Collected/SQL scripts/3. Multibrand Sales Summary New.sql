SELECT r.area_code,
       r.district_code,
       r.shop_code,
       SUM(r.sales_price) AS total_sales_price,
       SUM(r.amount_rsp) AS total_rsp
  FROM ifsapp.sbl_jr_sales_inv_comp_view r
 INNER JOIN ifsapp.sbl_jr_product_dtl_info p
    ON r.product_code = p.product_code
 WHERE r.sales_date BETWEEN TO_DATE('&FROM_DATE', 'YYYY/MM/DD') AND
       TO_DATE('&TO_DATE', 'YYYY/MM/DD')
   AND p.brand NOT IN ('Singer', 'Merritt', 'Singtech', 'Sinotec')
   AND p.product_family NOT IN ('GIFT', 'Raw Material')
   AND p.product_code != 'SGCOM-LED-18.5'
   AND 
 GROUP BY r.shop_code, r.area_code, r.district_code
 ORDER BY to_number(r.district_code), r.shop_code

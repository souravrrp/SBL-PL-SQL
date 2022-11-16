/* Formatted on 5/29/2022 2:18:36 PM (QP5 v5.381) */
  SELECT *
    FROM ifsapp.sbl_sales_tmp t
   WHERE     sale_date BETWEEN TO_DATE ('&DATE_F', 'dd/mm/yyyy')
                           AND TO_DATE ('&DATE_T', 'dd/mm/yyyy')
         AND shop_code LIKE '&site'
         AND shop_code IN (SELECT shop_code FROM shop_dts_info)
ORDER BY sale_date;
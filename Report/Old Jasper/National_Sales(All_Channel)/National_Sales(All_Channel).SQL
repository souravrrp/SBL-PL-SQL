/* Formatted on 8/1/2022 11:52:39 AM (QP5 v5.381) */
----------------------------Year Wise------------------------------------------

SELECT SUM (l.sales_price)
  FROM ifsapp.sbl_jr_vw_all_cnl_sales_summ l
 WHERE TO_CHAR (l.sales_date, 'RRRR') = '2022';

----------------------------Month Wise------------------------------------------

SELECT SUM (l.sales_price)
  FROM ifsapp.sbl_jr_vw_all_cnl_sales_summ l
 WHERE TO_CHAR (l.sales_date, 'MON-RRRR') = 'AUG-2022';

----------------------------Channel Wise----------------------------------------

  SELECT l.sales_channel, SUM (l.sales_price)
    FROM ifsapp.sbl_jr_vw_all_cnl_sales_summ l
   WHERE TO_CHAR (l.sales_date, 'MON-RRRR') = 'AUG-2022'
GROUP BY l.sales_channel;

----------------------------Day Wise--------------------------------------------

  SELECT l.sales_date, l.sales_channel, l.sales_price
    FROM ifsapp.sbl_jr_vw_all_cnl_sales_summ l
   WHERE TO_CHAR (l.sales_date, 'MON-RRRR') = 'JUL-2022'
ORDER BY l.sales_date, l.sales_channel;


----------------------------To Date Wise----------------------------------------

SELECT SUM (l.sales_price)
  FROM ifsapp.sbl_jr_vw_all_cnl_sales_summ l
 WHERE l.sales_date BETWEEN :p_from_date AND NVL ( :p_to_date, SYSDATE);